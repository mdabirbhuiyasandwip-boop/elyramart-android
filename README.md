# Elyramart

Flutter-based marketplace and home-services app for Bangladesh.

## Platforms
The intended product targets Android, iOS and responsive Web from a shared Flutter codebase. The current automated workflow builds Android APK only. iOS requires macOS/Xcode and Apple signing; Web needs a hosting deployment.

## Current prototype status
This repository currently contains a working-start Flutter prototype. Cart, sample catalog, seller/technician/admin demo screens and some order/booking data are local-device demonstrations. They are not yet shared across devices or connected to a live backend.

**Do not treat the current prototype as a production marketplace.** Phone login, cloud sync, seller approval, technician assignment, online payments, push notifications and cross-device account access still need implementation and testing.

## Build Android APK
The GitHub Actions workflow `.github/workflows/build-apk.yml` runs on pushes to `main` and can be started manually from Actions. It runs Flutter dependency resolution, static analysis and a release APK build. The output artifact is named `Elyramart-APK-release`.

## Developer documentation
- [বাংলা Developer Handoff: Android, iPhone, Web, cloud architecture and launch checklist](docs/DEVELOPER_HANDOFF_BN.md)
- [বাংলা Firebase setup and proposed data model](docs/FIREBASE_SETUP_BN.md)

## Suggested backend
Firebase Authentication, Cloud Firestore, Firebase Storage, Cloud Functions and Firebase Cloud Messaging are proposed. Project-specific Firebase configuration is not included. Never commit service-account private keys, admin credentials or payment secrets.

## Versioning
Keep the Flutter source as the single source of truth. Add automated tests and document schema changes before production releases.
