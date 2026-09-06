import assert from "node:assert/strict";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import test from "node:test";
import { reserveSecretFile } from "../src/secretFile.js";

const withTempDir = async (fn) => {
  const root = fs.mkdtempSync(path.join(os.tmpdir(), "technitium-secret-file-"));
  try {
    await fn(root);
  } finally {
    fs.rmSync(root, { recursive: true, force: true });
  }
};

test("secret file reservation commits with mode 0600 without exposing content in metadata", async () => {
  await withTempDir(async (root) => {
    const reservation = reserveSecretFile({
      directory: root,
      fileName: "homepage-token"
    });

    const result = reservation.commit({ value: "synthetic-secret-token" });
    const stat = fs.statSync(result.filePath);

    assert.equal(stat.mode & 0o777, 0o600);
    assert.equal(fs.readFileSync(result.filePath, "utf8"), "synthetic-secret-token");
    assert.deepEqual(Object.keys(result).sort(), ["fileName", "filePath", "written"]);
    assert.equal(JSON.stringify(result).includes("synthetic-secret-token"), false);
  });
});

test("secret file reservation refuses overwrite", async () => {
  await withTempDir(async (root) => {
    fs.writeFileSync(path.join(root, "existing"), "preserve-me", { mode: 0o600 });

    assert.throws(() => reserveSecretFile({
      directory: root,
      fileName: "existing"
    }), /exists|EEXIST/i);

    assert.equal(fs.readFileSync(path.join(root, "existing"), "utf8"), "preserve-me");
  });
});

test("secret file reservation abort removes an empty reservation", async () => {
  await withTempDir(async (root) => {
    const reservation = reserveSecretFile({
      directory: root,
      fileName: "aborted"
    });

    reservation.abort();
    assert.equal(fs.existsSync(path.join(root, "aborted")), false);
  });
});

test("secret file reservation rejects traversal even without schema validation", async () => {
  await withTempDir(async (root) => {
    assert.throws(() => reserveSecretFile({
      directory: root,
      fileName: "../escape"
    }), /outside|file name/i);
  });
});
