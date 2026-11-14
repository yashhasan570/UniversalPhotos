#!/bin/bash
# shellcheck source=common.sh
# shellcheck disable=SC1091
source /universalphotos-devcontainer/container-common.sh

log "Preparing UniversalPhotos Nest API Server"
log ""
export CI=1
run_cmd pnpm --filter universalphotos install
SHARP_FORCE_GLOBAL_LIBVIPS=true run_cmd pnpm --config.verify-deps-before-run=false --dir "${UNIVERSALPHOTOS_WORKSPACE}/server/node_modules/sharp" run build

log "Starting Nest API Server"
log ""
cd "${UNIVERSALPHOTOS_WORKSPACE}/server" || (
    log "UniversalPhotos workspace not found"
    exit 1
)

while true; do
    run_cmd pnpm --filter universalphotos exec nest start --debug "0.0.0.0:9230" --watch
    log "Nest API Server crashed with exit code $?.  Respawning in 3s ..."
    sleep 3
done
