# Universal Photos

A free, self-hosted photo and video backup solution: back up from your phone, browse, search, and share your media from your own server.

## Contact

Questions or feedback? Reach us on Telegram: [@johnconstantine570](https://t.me/johnconstantine570)

## Building

Monorepo layout: `server` (TypeScript), `web` (frontend), `mobile` (Flutter app), `machine-learning` (Python). See each folder for setup.

## Sync

`.github/workflows/sync.yml` pulls upstream changes daily, re-applies the Universal Photos branding via `scripts/migrate.py`, and pushes.
