#!/bin/bash
# shellcheck source=common.sh
# shellcheck disable=SC1091
source /universalphotos-devcontainer/container-common.sh

export CI=1
log "Preparing UniversalPhotos Web Frontend"
log ""
run_cmd pnpm --filter @universalphotos/sdk install
run_cmd pnpm --filter @universalphotos/sdk build
run_cmd pnpm --filter @universalphotos/plugin-sdk install
run_cmd pnpm --filter @universalphotos/plugin-sdk build
run_cmd pnpm --filter universalphotos-web install

log "Starting UniversalPhotos Web Frontend"
log ""
cd "${UNIVERSALPHOTOS_WORKSPACE}/web" || (
    log "UniversalPhotos Workspace not found"
    exit 1
)

until curl --output /dev/null --silent --head --fail "http://127.0.0.1:${UNIVERSALPHOTOS_PORT}/api/server/config"; do
    log "Waiting for api server..."
    sleep 1
done

while true; do
    run_cmd pnpm --filter universalphotos-web exec vite dev --host 0.0.0.0 --port "${DEV_PORT}"
    log "Web crashed with exit code $?.  Respawning in 3s ..."
    sleep 3
done
