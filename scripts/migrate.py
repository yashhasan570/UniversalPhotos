#!/usr/bin/env python3
"""Re-apply the Universal Photos rebrand after each upstream sync (idempotent)."""
from pathlib import Path
import os

ROOT = Path(__file__).resolve().parent.parent

# Functional anchors that must never change:
#  -  /  hosted-service domains (maintenance login, map tiles, docs)
#  - '' on-disk marker file convention (existing server data)
#  - yucca.v1BackupFileName EXIF tag (photo metadata interop)
#  -  container images (postgres/base, build dependencies)
ANCHORS = [
    '', '', '', 'yucca.v1BackupFileName',
    '', '', '',
]
REPL = [
    ('github.com/yashhasan570/UniversalPhotos', 'github.com/yashhasan570/UniversalPhotos'),
    ('universal_photos_ml', 'universal_photos_ml'),
    ('universal_photos', 'universal_photos'),
    ('UNIVERSALPHOTOS_', 'UNIVERSALPHOTOS_'),
    ('UNIVERSAL PHOTOS', 'UNIVERSAL PHOTOS'),
    ('UniversalPhotos', 'UniversalPhotos'),
    ('universalphotos', 'universalphotos'),
]

def main():
    CODE_EXT = {'.ts', '.tsx', '.js', '.mjs', '.cjs', '.dart', '.py', '.kt', '.kts',
                '.swift', '.gradle', '.toml', '.yaml', '.yml', '.json', '.sh',
                '.properties', '.env', '.sql', '.sqlx'}
    SKIP = {'.git', 'scripts', 'node_modules'}
    changed = 0
    for dirpath, dirnames, filenames in os.walk(ROOT):
        rel = os.path.relpath(dirpath, ROOT).replace(os.sep, '/')
        if rel == '.':
            dirnames[:] = [d for d in dirnames if d not in SKIP]
        elif rel.split('/')[0] in SKIP:
            dirnames[:] = []
        for fn in filenames:
            p = Path(dirpath) / fn
            ext = p.suffix.lower()
            if ext not in CODE_EXT and ext != '': continue
            try: s = p.read_text(encoding='utf-8')
            except Exception: continue
            o = s
            for a in ANCHORS: s = s.replace(a, chr(2) + chr(1))
            pairs = [r for r in REPL]
            for a, b in pairs: s = s.replace(a, b)
            s = s.replace(chr(2) + chr(1), '')
            if s != o:
                p.write_text(s, encoding='utf-8'); changed += 1
    print(f'migrate: {changed} files swept')

if __name__ == '__main__':
    main()
