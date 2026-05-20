# Ghost MCP server — image for the anh-studio federated MCP setup (ToolHive).
# Upstream MFYDev/ghost-mcp ships no Dockerfile; this fork adds one so the
# server can run as a thv container workload. stdio transport.
FROM node:20-alpine

WORKDIR /app

# Copy sources first so the explicit `npm run build` below has src/ available.
# `--ignore-scripts` skips the `prepare` lifecycle hook (it would run tsc before
# we control the step); we then build explicitly and prune dev deps.
COPY . .
RUN npm ci --ignore-scripts \
 && npm run build \
 && npm prune --omit=dev \
 && npm cache clean --force

# MCP runs over stdio; thv attaches to the container's stdio.
CMD ["node", "build/server.js"]
