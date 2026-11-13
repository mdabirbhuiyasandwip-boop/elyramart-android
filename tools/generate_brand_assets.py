#!/usr/bin/env python3
"""Generate Elyramart's E-only app and web icons."""
from pathlib import Path
from PIL import Image, ImageDraw

GREEN = (8, 127, 91, 255)
WHITE = (255, 255, 255, 255)

def mark(size, rounded=True, transparent=False):
    image = Image.new("RGBA", (size, size), (0, 0, 0, 0) if transparent else GREEN)
    draw = ImageDraw.Draw(image)
    if not transparent and rounded:
        # Rounded green tile, with a clean white capital E.
        draw.rounded_rectangle((0, 0, size - 1, size - 1), radius=int(size * .23), fill=GREEN)
    width = max(2, int(size * .105))
    left, right = int(size * .29), int(size * .73)
    y1, ym, y2 = int(size * .27), int(size * .50), int(size * .73)
    draw.line((left, y1, left, y2), fill=WHITE, width=width)
    draw.line((left, y1, right, y1), fill=WHITE, width=width)
    draw.line((left, ym, int(size * .65), ym), fill=WHITE, width=width)
    draw.line((left, y2, right, y2), fill=WHITE, width=width)
    return image

# Android legacy and adaptive launcher resources.
android = Path("android/app/src/main/res")
for density, px in [("mdpi", 48), ("hdpi", 72), ("xhdpi", 96), ("xxhdpi", 144), ("xxxhdpi", 192)]:
    folder = android / f"mipmap-{density}"
    folder.mkdir(parents=True, exist_ok=True)
    mark(px).save(folder / "ic_launcher.png")
    mark(px, transparent=True).save(folder / "ic_launcher_foreground.png")

values = android / "values"
values.mkdir(parents=True, exist_ok=True)
(values / "ic_launcher_background.xml").write_text(
    '<?xml version="1.0" encoding="utf-8"?>\n<resources><color name="ic_launcher_background">#087F5B</color></resources>\n',
    encoding="utf-8"
)

# Flutter Web browser tab, install icons and Apple touch icon.
web = Path("web")
(web / "icons").mkdir(parents=True, exist_ok=True)
for filename, px in [
    ("favicon.png", 64),
    ("icons/Icon-192.png", 192),
    ("icons/Icon-512.png", 512),
    ("icons/Icon-maskable-192.png", 192),
    ("icons/Icon-maskable-512.png", 512),
    ("apple-touch-icon.png", 180),
]:
    mark(px).save(web / filename)
mark(64).save(web / "favicon.ico", format="ICO")
print("Generated Elyramart E-only Android and Web icons.")
