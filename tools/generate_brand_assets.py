#!/usr/bin/env python3
"""Generate Elyramart's modern E-only brand mark for Android and Web."""
from pathlib import Path
from PIL import Image, ImageDraw

GREEN = (8, 127, 91, 255)
WHITE = (255, 255, 255, 255)

def mark(size, rounded=True, transparent=False):
    # Preserve Elyramart's green/white palette and recognizable E-only symbol.
    image = Image.new("RGBA", (size, size), (0, 0, 0, 0) if transparent else GREEN)
    draw = ImageDraw.Draw(image)
    if not transparent and rounded:
        draw.rounded_rectangle(
            (0, 0, size - 1, size - 1),
            radius=int(size * .24),
            fill=GREEN,
        )

    # A refined geometric monogram: one strong spine and three balanced,
    # softly rounded strokes. The middle arm is shorter to make the E feel
    # distinctive and compact at launcher-icon sizes.
    unit = size / 100.0
    thickness = max(2, int(size * .115))
    left = int(27 * unit)
    right = int(75 * unit)
    mid_right = int(64 * unit)
    top = int(25 * unit)
    middle = int(50 * unit)
    bottom = int(75 * unit)
    radius = max(1, thickness // 2)

    draw.rounded_rectangle(
        (left, top, left + thickness, bottom),
        radius=radius,
        fill=WHITE,
    )
    for y, end in ((top, right), (middle - thickness // 2, mid_right), (bottom - thickness, right)):
        draw.rounded_rectangle(
            (left, y, end, y + thickness),
            radius=radius,
            fill=WHITE,
        )
    return image

android = Path("android/app/src/main/res")
for density, px in [("mdpi", 48), ("hdpi", 72), ("xhdpi", 96), ("xxhdpi", 144), ("xxxhdpi", 192)]:
    folder = android / f"mipmap-{density}"
    folder.mkdir(parents=True, exist_ok=True)
    mark(px).save(folder / "ic_launcher.png")
    mark(px, transparent=True).save(folder / "ic_launcher_foreground.png")

values = android / "values"
values.mkdir(parents=True, exist_ok=True)
(values / "ic_launcher_background.xml").write_text(
    '<?xml version="1.0" encoding="utf-8"?>\\n<resources><color name="ic_launcher_background">#087F5B</color></resources>\\n',
    encoding="utf-8"
)

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
print("Generated modern Elyramart E-only Android and Web icons.")
