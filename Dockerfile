ARG NODE_IMAGE=node@sha256:c610fcdfb1d5b4740dd70c284ed3cb16bb857e0f7166196e36a5501df7a3aa32
FROM ${NODE_IMAGE} AS deps
WORKDIR /app
COPY upstream/package*.json ./
RUN npm ci --omit=dev && npm cache clean --force

FROM ${NODE_IMAGE} AS runtime
ARG VERSION=dev
ARG REVISION=unknown
LABEL org.opencontainers.image.title="Technitium DNS MCP — X1pheR Distribution" \
      org.opencontainers.image.description="Community-maintained distribution of Slyke/mcp-technitium-dns" \
      org.opencontainers.image.source="https://github.com/X1pheR/technitium-mcp" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.revision="${REVISION}" \
      org.opencontainers.image.licenses="MIT"
RUN apk add --no-cache libcrypto3=3.5.8-r0 libssl3=3.5.8-r0 \
    && rm -rf /usr/local/lib/node_modules/npm /usr/local/bin/npm /usr/local/bin/npx
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY upstream/package.json ./package.json
COPY upstream/src ./src
COPY upstream/LICENSE.md ./LICENSE.upstream.md
RUN printf '{"version":"%s","buildHash":"%s"}\n' "$VERSION" "$REVISION" > /app/build-info.json \
    && mkdir -p /app/data/certs /app/data/backups /app/data/imports \
    && chown -R node:node /app/data
ENV CONFIG_FILE=./data/config.json5
EXPOSE 3443
USER node
CMD ["node", "src/index.js"]
