#!/usr/bin/env python3
"""Configure optional Android upload-key signing from GitHub Actions secrets."""
import base64
import os
import subprocess
from pathlib import Path

names = [
    "ANDROID_KEYSTORE_BASE64",
    "ANDROID_KEYSTORE_PASSWORD",
    "ANDROID_KEY_ALIAS",
    "ANDROID_KEY_PASSWORD",
]
values = {name: os.environ.get(name, "") for name in names}
present = [bool(value) for value in values.values()]
if not any(present):
    print("Android upload signing secrets are not configured; building an unsigned release artifact.")
    raise SystemExit(0)
if not all(present):
    missing = [name for name, value in values.items() if not value]
    raise SystemExit("Incomplete Android signing setup. Missing: " + ", ".join(missing))

root = Path("android")
app = root / "app"
app.mkdir(parents=True, exist_ok=True)
keystore = app / "upload-keystore.jks"
try:
    decoded = base64.b64decode(values["ANDROID_KEYSTORE_BASE64"], validate=True)
except Exception as exc:
    raise SystemExit("ANDROID_KEYSTORE_BASE64 is not valid base64.") from exc
if len(decoded) < 1024:
    raise SystemExit("Decoded Android keystore is unexpectedly small.")
keystore.write_bytes(decoded)

check = subprocess.run(
    [
        "keytool", "-list", "-keystore", str(keystore),
        "-storepass", values["ANDROID_KEYSTORE_PASSWORD"],
        "-alias", values["ANDROID_KEY_ALIAS"],
    ],
    capture_output=True, text=True,
)
if check.returncode != 0:
    keystore.unlink(missing_ok=True)
    raise SystemExit("Android keystore/password/alias validation failed. Check the four signing secrets.")

(root / "key.properties").write_text(
    "storePassword=" + values["ANDROID_KEYSTORE_PASSWORD"] + "\n"
    + "keyPassword=" + values["ANDROID_KEY_PASSWORD"] + "\n"
    + "keyAlias=" + values["ANDROID_KEY_ALIAS"] + "\n"
    + "storeFile=upload-keystore.jks\n",
    encoding="utf-8",
)

gradle = app / "build.gradle.kts"
if not gradle.exists():
    gradle = app / "build.gradle"
if not gradle.exists():
    raise SystemExit("Android app Gradle file not found.")

source = gradle.read_text(encoding="utf-8")
if gradle.suffix == ".kts":
    block = """
// Elyramart release signing: credentials are supplied only by protected CI secrets.
val signingProperties = java.util.Properties()
val signingPropertiesFile = rootProject.file("key.properties")
if (signingPropertiesFile.exists()) {
    signingPropertiesFile.inputStream().use { signingProperties.load(it) }
}
android {
    signingConfigs {
        create("release") {
            keyAlias = signingProperties["keyAlias"] as String
            keyPassword = signingProperties["keyPassword"] as String
            storeFile = file(signingProperties["storeFile"] as String)
            storePassword = signingProperties["storePassword"] as String
        }
    }
    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
"""
else:
    block = """
// Elyramart release signing: credentials are supplied only by protected CI secrets.
def signingProperties = new Properties()
def signingPropertiesFile = rootProject.file("key.properties")
if (signingPropertiesFile.exists()) {
    signingPropertiesFile.withInputStream { signingProperties.load(it) }
}
android {
    signingConfigs {
        release {
            keyAlias signingProperties['keyAlias']
            keyPassword signingProperties['keyPassword']
            storeFile file(signingProperties['storeFile'])
            storePassword signingProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
"""
if "Elyramart release signing:" not in source:
    gradle.write_text(source + "\n" + block, encoding="utf-8")
print("Android upload keystore validated and release signing configured.")
