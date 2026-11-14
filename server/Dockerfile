FROM /base-server-dev:202611031105@sha256:a1569fa3e5de340495658c3683574a15c1cc675db4bee635dd83f66e0ec7212b AS builder
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0 \
  CI=1 \
  COREPACK_HOME=/tmp \
  PNPM_HOME=/buildcache/pnpm-store \
  PATH="/buildcache/pnpm-store:$PATH"

RUN npm install --global corepack@latest && \
  corepack enable pnpm && \
  pnpm config set store-dir "$PNPM_HOME"

WORKDIR /usr/src/app

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml .pnpmfile.cjs ./

FROM builder AS sdk

COPY ./packages/sdk/package.json ./packages/sdk/package.json
RUN --mount=type=cache,id=pnpm,target=/buildcache/pnpm-store pnpm --filter @universalphotos/sdk install --frozen-lockfile

COPY ./packages/sdk ./packages/sdk/
RUN --mount=type=cache,id=pnpm,target=/buildcache/pnpm-store pnpm --filter @universalphotos/sdk build

FROM sdk AS plugin-sdk

COPY ./packages/plugin-sdk/package.json ./packages/plugin-sdk/package.json
RUN --mount=type=cache,id=pnpm,target=/buildcache/pnpm-store pnpm --filter @universalphotos/plugin-sdk install --frozen-lockfile

COPY ./packages/plugin-sdk ./packages/plugin-sdk/
RUN --mount=type=cache,id=pnpm,target=/buildcache/pnpm-store pnpm --filter @universalphotos/plugin-sdk build

FROM plugin-sdk AS server

COPY ./server/package.json ./server/package.json
RUN --mount=type=cache,id=pnpm,target=/buildcache/pnpm-store pnpm --filter universalphotos install --frozen-lockfile

COPY ./server ./server/
RUN --mount=type=cache,id=pnpm,target=/buildcache/pnpm-store \
  pnpm --filter universalphotos build && \
  pnpm --filter universalphotos --prod --no-optional deploy /output/server-pruned
RUN --mount=type=cache,id=pnpm,target=/buildcache/pnpm-store \
  SHARP_FORCE_GLOBAL_LIBVIPS=true pnpm --config.verify-deps-before-run=false --dir /output/server-pruned/node_modules/sharp run build

FROM sdk AS web

COPY ./web/package.json ./web/package.json
RUN --mount=type=cache,id=pnpm,target=/buildcache/pnpm-store pnpm --filter universalphotos-web install --frozen-lockfile

COPY ./i18n ./i18n/
COPY ./web ./web/

ARG BUILD_ID
ENV UNIVERSALPHOTOS_BUILD=${BUILD_ID}

RUN --mount=type=cache,id=pnpm,target=/buildcache/pnpm-store pnpm --filter universalphotos-web build

FROM sdk AS cli

COPY ./packages/cli/package.json ./packages/cli/package.json
RUN --mount=type=cache,id=pnpm,target=/buildcache/pnpm-store pnpm --filter @universalphotos/cli install --frozen-lockfile

COPY ./packages/cli ./packages/cli/
RUN --mount=type=cache,id=pnpm,target=/buildcache/pnpm-store \
  pnpm --filter @universalphotos/cli build && \
  pnpm --filter @universalphotos/cli --prod --no-optional deploy /output/cli-pruned

FROM plugin-sdk AS plugins

ARG TARGETPLATFORM

COPY --from=ghcr.io/jdx/mise:2026.11.6@sha256:d4de1845114f6d73e90e15f7642885f74f3ca93074491038a2b9c43e4b897f21 /usr/local/bin/mise /usr/local/bin/mise

COPY ./mise.toml ./mise.toml
COPY ./mise.lock ./mise.lock
COPY ./.mise ./.mise
COPY ./packages/plugin-core/mise.toml ./packages/plugin-core/
ENV MISE_TRUSTED_CONFIG_PATHS=/usr/src/app/mise.toml
ENV MISE_DATA_DIR=/buildcache/mise
ENV MISE_DISABLE_TOOLS=flutter
RUN --mount=type=cache,id=mise-tools-${TARGETPLATFORM},target=/buildcache/mise \
  mise install --locked
COPY ./packages/plugin-core ./packages/plugin-core/

# Build plugins
RUN --mount=type=cache,id=pnpm,target=/buildcache/pnpm-store \
  --mount=type=cache,id=mise-tools-${TARGETPLATFORM},target=/buildcache/mise \
  mise //:plugins

FROM /base-server-prod:202611031105@sha256:11dd3d258ec519494fd116fc54e568b12769e4d26d2def063bcafb9b56cc064b

WORKDIR /usr/src/app
ENV NODE_ENV=production \
  NVIDIA_DRIVER_CAPABILITIES=all \
  NVIDIA_VISIBLE_DEVICES=all

COPY --from=server /output/server-pruned ./server
COPY --from=web /usr/src/app/web/build /build/www
COPY --from=cli /output/cli-pruned ./cli
COPY --from=plugins /usr/src/app/packages/plugin-core/dist /build/plugins/universalphotos-plugin-core/dist
COPY --from=plugins /usr/src/app/packages/plugin-core/manifest.json /build/plugins/universalphotos-plugin-core/manifest.json
RUN ln -s ../../cli/bin/universalphotos server/bin/universalphotos
COPY LICENSE /licenses/LICENSE.txt
COPY LICENSE /LICENSE

ENV PATH="${PATH}:/usr/src/app/server/bin"

ARG BUILD_ID
ARG BUILD_IMAGE
ARG BUILD_SOURCE_REF
ARG BUILD_SOURCE_COMMIT

ENV UNIVERSALPHOTOS_BUILD=${BUILD_ID}
ENV UNIVERSALPHOTOS_BUILD_URL=https://github.com/yashhasan570/UniversalPhotos/actions/runs/${BUILD_ID}
ENV UNIVERSALPHOTOS_BUILD_IMAGE=${BUILD_IMAGE}
ENV UNIVERSALPHOTOS_BUILD_IMAGE_URL=https://github.com/yashhasan570/UniversalPhotos/pkgs/container/universalphotos-server
ENV UNIVERSALPHOTOS_REPOSITORY=universalphotos-app/universalphotos
ENV UNIVERSALPHOTOS_REPOSITORY_URL=https://github.com/yashhasan570/UniversalPhotos
ENV UNIVERSALPHOTOS_SOURCE_REF=${BUILD_SOURCE_REF}
ENV UNIVERSALPHOTOS_SOURCE_COMMIT=${BUILD_SOURCE_COMMIT}
ENV UNIVERSALPHOTOS_SOURCE_URL=https://github.com/yashhasan570/UniversalPhotos/commit/${BUILD_SOURCE_COMMIT}

COPY --from=ghcr.io/futo-org/backups/restic-proxy:v1.11.2@sha256:a88252d884d22a55749f45dd39a2458c6391ca3e4d3b0d9e0c2246786cf923be /usr/local/bin/restic-proxy /usr/local/bin/restic-proxy
COPY --from=ghcr.io/futo-org/restic:sha-1e904f0@sha256:501bb3e696bd78db0d89ae4e5c51b6993b9cb3f88e657020777dba49226169bc /usr/bin/restic /usr/local/bin/restic

VOLUME /data
EXPOSE 2283
ENTRYPOINT ["tini", "--", "/bin/bash", "-c"]
CMD ["start.sh"]

HEALTHCHECK CMD universalphotos-healthcheck
