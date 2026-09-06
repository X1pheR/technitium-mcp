#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
cd "$root"
image=hypershell/technitium-mcp:candidate
prefix="technitium-mcp-verify-$$"
tmp=$(mktemp -d)
cleanup(){
  docker rm -f "${prefix}-ro" "${prefix}-rw" >/dev/null 2>&1 || true
  docker image rm "$image" >/dev/null 2>&1 || true
  rm -rf "$tmp"
}
trap cleanup EXIT

if [ -d .git ]; then
  git diff --check
  test -z "$(git status --porcelain)" || { echo 'ERROR: Git candidate is dirty' >&2; exit 1; }
  revision=$(git rev-parse HEAD)
  if [ -n "${VERIFY_REVISION:-}" ]; then test "$revision" = "$VERIFY_REVISION" || { echo 'ERROR: VERIFY_REVISION does not match HEAD' >&2; exit 1; }; fi
  echo "source_mode=git revision=$revision"
else
  test -z "${VERIFY_REVISION:-}" || { echo 'ERROR: VERIFY_REVISION supplied for non-Git candidate' >&2; exit 1; }
  revision=pre-first-release
  echo 'source_mode=pre-first-release'
fi

python3 - <<'PY'
import json
from pathlib import Path
m=json.loads(Path('UPSTREAM.json').read_text())
p=json.loads(Path('package.json').read_text())
t=json.loads(Path('tools-manifest.json').read_text())
assert m['repository']=='https://github.com/Slyke/mcp-technitium-dns.git'
assert m['commit']=='0b8f0478f4e759b17fe5d1410a72659fb3f61bfb'
assert m['node_image']=='node@sha256:c610fcdfb1d5b4740dd70c284ed3cb16bb857e0f7166196e36a5501df7a3aa32'
assert m['runtime_hardening']['runtime_package_manager']=='removed'
assert m['runtime_hardening']['runtime_user']=='node'
assert m['application_source_delta'] is True
assert m['distribution_model']=='upstream-source-snapshot-with-reviewed-security-integration-delta'
assert m['distribution_version']==p['version']=='0.0.1-x1pher.2'
assert m['tested_technitium_version']=='15.4.0'
assert t['read_only_tool_count']==31 and t['read_write_tool_count']==73 and len(t['tools'])==73
names=[x['name'] for x in t['tools']]
assert len(names)==len(set(names))
required=['Dockerfile','README.md','LICENSE','THIRD_PARTY_NOTICES.md','SECURITY.md','CONTRIBUTING.md','CHANGELOG.md','package.json','tools-manifest.json','docs/tools.md','scripts/verify.sh','.github/workflows/ci.yml','.github/workflows/release.yml','.github/dependabot.yml']
for f in required: assert Path(f).is_file(), f
for item in t['tools']: assert f'`{item["name"]}`' in Path('docs/tools.md').read_text(), item['name']
print('distribution_contract=ok')
PY

commit=$(python3 -c 'import json; print(json.load(open("UPSTREAM.json"))["commit"])')
git clone --quiet https://github.com/Slyke/mcp-technitium-dns.git "$tmp/base"
git -C "$tmp/base" checkout --quiet "$commit"
rm -rf "$tmp/base/.git"
python3 - "$tmp/base" "$root/upstream" "$root/UPSTREAM.json" <<'PY'
import json
from pathlib import Path
import sys
base,cand,manifest_path=map(Path,sys.argv[1:]); paths=set()
for r in (base,cand): paths.update(p.relative_to(r).as_posix() for p in r.rglob('*') if p.is_file())
changed=[]
for rel in sorted(paths):
 a,b=base/rel,cand/rel
 if not a.exists() or not b.exists() or a.read_bytes()!=b.read_bytes(): changed.append(rel)
manifest=json.loads(manifest_path.read_text())
expected=sorted(x.removeprefix('upstream/') for x in manifest['downstream_delta'] if x.startswith('upstream/'))
if changed != expected: raise SystemExit(f'ERROR: unexpected upstream application delta: observed={changed} expected={expected}')
print(f'upstream_delta=reviewed files={len(changed)}')
PY

cp -a "$root/upstream" "$tmp/work"
uid=$(id -u); gid=$(id -g)
docker run --rm --user "$uid:$gid" -e HOME=/tmp -v "$tmp/work:/work" -w /work node:22-alpine sh -lc 'npm ci --ignore-scripts && npm test && npm audit --omit=dev'

trivy_cache=${TRIVY_CACHE_DIR:-${HOME}/.cache/technitium-mcp/trivy}
mkdir -p "$trivy_cache"
docker run --rm -v "$root:/work:ro" -v "$trivy_cache:/root/.cache/trivy" ghcr.io/aquasecurity/trivy:0.74.0 filesystem --scanners vuln,secret --severity HIGH,CRITICAL --ignore-unfixed --exit-code 1 --no-progress /work
docker run --rm -v "$root/Dockerfile:/Dockerfile:ro" -v "$trivy_cache:/root/.cache/trivy" ghcr.io/aquasecurity/trivy:0.74.0 config --severity HIGH,CRITICAL --exit-code 1 /Dockerfile
docker run --rm -v "$root:/repo:ro" -w /repo rhysd/actionlint:1.7.7 -no-color .github/workflows/ci.yml .github/workflows/release.yml

version=$(python3 -c 'import json; print(json.load(open("package.json"))["version"])')
docker build --pull=false --build-arg VERSION="$version" --build-arg REVISION="$revision" -t "$image" "$root"
user=$(docker image inspect "$image" --format '{{.Config.User}}')
case "$user" in node|1000|1000:*) ;; *) echo "ERROR: image runtime user is not non-root: $user" >&2; exit 1;; esac
test "$(docker image inspect "$image" --format '{{index .Config.Labels "org.opencontainers.image.version"}}')" = "$version"
test "$(docker image inspect "$image" --format '{{index .Config.Labels "org.opencontainers.image.revision"}}')" = "$revision"
docker run --rm --entrypoint sh "$image" -lc 'test "$(id -u)" -ne 0; ! command -v npm; ! command -v npx; test ! -e /usr/local/lib/node_modules/npm; touch /app/data/.write-test; rm /app/data/.write-test'
test "$(docker run --rm --entrypoint node "$image" -e 'console.log(JSON.parse(require("fs").readFileSync("/app/build-info.json","utf8")).version)')" = "$version"

surface(){
  mode=$1; name=$2; out=$3
  if [ "$mode" = ro ]; then ro=true; reads='[{name:"test-reader",token:"synthetic-value"}]'; writes='[]'; else ro=false; reads='[]'; writes='[{name:"test-writer",token:"synthetic-value"}]'; fi
  docker run -d --rm --name "$name" --network none -e HTTP_ENABLED=true -e HTTPS_ENABLED=false -e HTTP_HOST=127.0.0.1 -e HTTP_PORT=3000 -e READ_ONLY="$ro" -e MCP_READ_BEARER_TOKENS="$reads" -e MCP_READWRITE_BEARER_TOKENS="$writes" -e TECHNITIUM_BASE_URL=http://127.0.0.1:5380 -e TECHNITIUM_ALLOW_HTTP_LOCAL=true -e TECHNITIUM_API_TOKEN=synthetic-value -e READY_CHECK_TECHNITIUM=false "$image" >/dev/null
  for i in $(seq 1 30); do docker exec "$name" node -e "fetch('http://127.0.0.1:3000/healthz').then(r=>{if(!r.ok)process.exit(1)}).catch(()=>process.exit(1))" >/dev/null 2>&1 && break; sleep .2; done
  docker exec -i "$name" node --input-type=module - > "$out" <<'NODE'
const h={Authorization:'Bearer synthetic-value','Content-Type':'application/json',Accept:'application/json, text/event-stream'};const u='http://127.0.0.1:3000/mcp';async function c(id,method,params={}){const r=await fetch(u,{method:'POST',headers:h,body:JSON.stringify({jsonrpc:'2.0',id,method,params})});const t=await r.text();if(!r.ok)throw new Error(String(r.status));const a=t.split(/\r?\n/).filter(x=>x.startsWith('data:')).map(x=>x.slice(5).trim());return JSON.parse(a.length?a.at(-1):t)};await c(1,'initialize',{protocolVersion:'2025-03-26',capabilities:{},clientInfo:{name:'contract-test',version:'1'}});const x=await c(2,'tools/list',{});process.stdout.write(JSON.stringify(x.result.tools));
NODE
  docker rm -f "$name" >/dev/null
}
surface ro "${prefix}-ro" "$tmp/ro.json"
surface rw "${prefix}-rw" "$tmp/rw.json"
python3 - "$tmp/ro.json" "$tmp/rw.json" tools-manifest.json <<'PY'
import json,sys
ro,rw,m=map(lambda p:json.load(open(p)),sys.argv[1:])
def norm(t):
 a=t.get('annotations') or {}
 return {'name':t['name'],'mode':None,'destructive':bool(a.get('destructiveHint',False)),'description':' '.join((t.get('description') or '').split())}
manifest=m['tools']; expected={x['name']:x for x in manifest}; ro_names={x['name'] for x in ro}; rw_names={x['name'] for x in rw}
assert len(ro)==m['read_only_tool_count']==31 and len(rw)==m['read_write_tool_count']==73
assert ro_names=={x['name'] for x in manifest if x['mode']=='read'} and rw_names==set(expected)
for t in rw:
 n=norm(t); e=expected[n['name']]; assert n['destructive']==e['destructive'] and n['description']==e['description'], n['name']
print('live_tool_contract=ok ro=31 rw=73')
PY

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v "$trivy_cache:/root/.cache/trivy" ghcr.io/aquasecurity/trivy:0.74.0 image --scanners vuln --severity HIGH,CRITICAL --ignore-unfixed --exit-code 1 --no-progress "$image"
echo 'verify=PASS'
