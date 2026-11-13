#!/usr/bin/env python3
"""Configure generated Flutter Web output as an installable Elyramart PWA."""
from pathlib import Path
import json
import re

manifest_path = Path("web/manifest.json")
if not manifest_path.exists():
    raise SystemExit("Flutter did not generate web/manifest.json")
manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
manifest.update({
    "name": "Elyramart",
    "short_name": "Elyramart",
    "description": "Elyramart marketplace and home services",
    "start_url": ".",
    "scope": ".",
    "display": "standalone",
    "orientation": "portrait-primary",
    "background_color": "#ffffff",
    "theme_color": "#087F5B",
    "prefer_related_applications": False,
    "icons": [
        {"src": "icons/Icon-192.png", "sizes": "192x192", "type": "image/png"},
        {"src": "icons/Icon-512.png", "sizes": "512x512", "type": "image/png"},
        {"src": "icons/Icon-maskable-192.png", "sizes": "192x192", "type": "image/png", "purpose": "maskable"},
        {"src": "icons/Icon-maskable-512.png", "sizes": "512x512", "type": "image/png", "purpose": "maskable"}
    ]
})
manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

index_path = Path("web/index.html")
html = index_path.read_text(encoding="utf-8")
html = re.sub(r"<title>.*?</title>", "<title>Elyramart</title>", html, count=1, flags=re.I | re.S)
tags = """
  <meta name="description" content="Elyramart — Marketplace and home services">
  <meta name="theme-color" content="#087F5B">
  <meta name="mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-title" content="Elyramart">
  <meta name="apple-mobile-web-app-status-bar-style" content="default">
  <link rel="apple-touch-icon" href="apple-touch-icon.png">
  <link rel="manifest" href="manifest.json">
"""
if 'name="apple-mobile-web-app-title"' not in html:
    html = html.replace("</head>", tags + "\n</head>")
index_path.write_text(html, encoding="utf-8")
print("Elyramart PWA metadata configured.")
