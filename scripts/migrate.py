#!/usr/bin/env python3
"""Re-apply the Universal Photos rebrand after each upstream sync (idempotent)."""
from pathlib import Path
import os, re, shutil, io, base64
from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
FORK = 'https://github.com/yashhasan570/UniversalPhotos'
TG = 'https://t.me/johnconstantine570'

def sweep_text():
    REPL = [
        ('app.alextran.immich','com.universalphotos.app'),
        ('https://github.com/immich-app/immich', FORK),
        ('github.com/immich-app/immich','github.com/yashhasan570/UniversalPhotos'),
        ('https://discord.immich.app', TG),
        ('https://immich.app/support', FORK),
    ]
    TEXT_EXTS = {'.kt','.kts','.gradle','.pro','.xml','.json','.md','.txt','.html','.ts','.js','.yml','.yaml','.properties','.cfg','.toml'}
    SKIP = {'.git','node_modules','scripts','.pnpm-store'}
    changed = 0
    for dirpath, dirnames, filenames in os.walk(ROOT):
        dirnames[:] = [d for d in dirnames if d not in SKIP]
        for fn in filenames:
            p = Path(dirpath)/fn
            if p.suffix.lower() not in TEXT_EXTS: continue
            try: s = p.read_text(encoding='utf-8')
            except Exception: continue
            o = s
            for a,b in REPL: s = s.replace(a,b)
            if p.suffix == '.json' and ('i18n/' in str(p) or str(p).endswith('manifest.json')):
                s = s.replace('Immich','Universal Photos')
            if p.suffix == '.html':
                s = s.replace('To use Immich','To use Universal Photos')
            if fn == 'AndroidManifest.xml':
                s = s.replace('Upload to Immich','Upload to Universal Photos').replace('View in Immich','View in Universal Photos')
            if s != o:
                p.write_text(s, encoding='utf-8'); changed += 1
    return changed

def remove_purchase():
    pairs = [('web/src/lib/components/shared-components/side-bar/BottomInfo.svelte','PurchaseInfo'),
             ('web/src/routes/(user)/user-settings/UserSettingsList.svelte','UserPurchaseSettings')]
    for rel, tag in pairs:
        p = ROOT/rel
        if p.exists():
            s = p.read_text(encoding='utf-8')
            lines = [l for l in s.splitlines(True) if tag not in l and f'import {tag}' not in l]
            s2 = re.sub(r'\n{3,}', '\n\n', ''.join(lines))
            p.write_text(s2, encoding='utf-8')
    for f in ['web/src/lib/components/shared-components/side-bar/PurchaseInfo.svelte',
              'web/src/routes/(user)/user-settings/UserPurchaseSettings.svelte']:
        p = ROOT/f
        if p.exists(): p.unlink()

def move_kotlin():
    kroot = ROOT/'mobile/android/app/src/main/kotlin/app/alextran'
    new_kroot = ROOT/'mobile/android/app/src/main/kotlin/com/universalphotos/app'
    if (kroot/'immich').exists():
        new_kroot.parent.mkdir(parents=True, exist_ok=True)
        if new_kroot.exists(): shutil.rmtree(new_kroot)
        shutil.move(str(kroot/'immich'), str(new_kroot))
        shutil.rmtree(ROOT/'mobile/android/app/src/main/kotlin/app', ignore_errors=True)

def icons():
    badge_path = ROOT/'scripts/icons/badge.png'
    if not badge_path.exists(): return 0
    badge = Image.open(badge_path).convert('RGBA')
    n = 0
    for d in ['mdpi','hdpi','xhdpi','xxhdpi','xxxhdpi']:
        size = {'mdpi':48,'hdpi':72,'xhdpi':96,'xxhdpi':144,'xxxhdpi':192}[d]
        p = ROOT/f'mobile/android/app/src/main/res/mipmap-{d}/ic_launcher.png'
        if p.exists(): badge.resize((size,size), Image.LANCZOS).save(p); n+=1
        fg = ROOT/f'mobile/android/app/src/main/res/mipmap-{d}/ic_launcher_foreground.png'
        fg_size = {'mdpi':108,'hdpi':162,'xhdpi':216,'xxhdpi':324,'xxxhdpi':432}[d]
        canvas = Image.new('RGBA',(fg_size,fg_size),(0,0,0,0))
        inner = badge.resize((int(fg_size*0.66),)*2, Image.LANCZOS)
        canvas.paste(inner, ((fg_size-inner.size[0])//2,)*2, inner)
        fg.parent.mkdir(parents=True, exist_ok=True); canvas.save(fg); n+=1
    for x in ROOT.glob('mobile/android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml'):
        s = x.read_text().replace('@drawable/ic_launcher_foreground','@mipmap/ic_launcher_foreground')
        x.write_text(s)
    adir = ROOT/'mobile/ios/Runner/Assets.xcassets/AppIcon.appiconset'
    if adir.exists():
        for p in adir.glob('*.png'):
            im = Image.open(p)
            badge.resize(im.size, Image.LANCZOS).save(p); n+=1
    web = ROOT/'web/static'
    if web.exists():
        badge.resize((180,180), Image.LANCZOS).save(web/'apple-icon-180.png')
        badge.resize((192,192), Image.LANCZOS).save(web/'manifest-icon-192.maskable.png')
        badge.resize((512,512), Image.LANCZOS).save(web/'manifest-icon-512.maskable.png')
        badge.resize((512,512), Image.LANCZOS).save(web/'favicon.ico', sizes=[(16,16),(32,32),(48,48)])
        buf = io.BytesIO(); badge.resize((512,512), Image.LANCZOS).save(buf,'PNG')
        b64 = base64.b64encode(buf.getvalue()).decode()
        (web/'icon.svg').write_text(f'<svg xmlns="http://www.w3.org/2000/svg" width="512" height="512"><image width="512" height="512" href="data:image/png;base64,{b64}"/></svg>')
        n+=5
    return n

def main():
    changed = sweep_text()
    remove_purchase()
    move_kotlin()
    n = icons()
    print(f'migrate: {changed} files swept, {n} icon files updated')

if __name__ == '__main__':
    main()
