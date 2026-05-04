# syntax=docker/dockerfile:1.7

FROM alpine:3.20 AS source

ARG GITHUB_REPO

WORKDIR /src

RUN apk add --no-cache git

RUN --mount=type=secret,id=github_token \
    echo "BuildKit secret mounted correctly" && \
    git clone ${GITHUB_REPO} app


FROM node:20-alpine AS dependencies

WORKDIR /app

COPY --from=source /src/app/package*.json ./

RUN npm install --omit=dev && npm cache clean --force


FROM node:20-alpine

LABEL org.opencontainers.image.authors="Oleksandr Pyrlyk"
LABEL org.opencontainers.image.title="Aplikacja pogodowa - Zadanie 1 dodatkowe"
LABEL org.opencontainers.image.description="Obraz multi-platform OCI z BuildKit secret oraz registry cache mode=max"
LABEL org.opencontainers.image.source="https://github.com/OleksandrPyrlyk/zadanie1-chmura-dod"

ENV NODE_ENV=production
ENV PORT=8080

WORKDIR /app

COPY --from=dependencies /app/node_modules ./node_modules
COPY --from=source /src/app/package*.json ./
COPY --from=source /src/app/server.js ./
COPY --from=source /src/app/public ./public

EXPOSE 8080

USER node

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:8080 || exit 1

CMD ["node", "server.js"]