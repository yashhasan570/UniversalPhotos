# Universal Photos

A free, self-hosted photo and video backup solution: back up from your phone, browse, search, and share your media from your own server.

Universal Photos is a fork of the Immich server codebase, maintained as a private build. Server internals and the API are unchanged, so existing Immich-compatible clients keep working.

## Contact

Questions or feedback? Reach us on Telegram: [@johnconstantine570](https://t.me/johnconstantine570)

## Building

Monorepo layout: `server` (TypeScript), `web` (frontend), `mobile` (Flutter app), `machine-learning` (Python). See each folder for setup.

## Sync

`.github/workflows/sync.yml` pulls upstream changes from the Immich project daily, re-applies the Universal Photos branding via `scripts/migrate.py`, and pushes.
