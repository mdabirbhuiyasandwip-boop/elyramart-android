# Elyramart

Flutter-based marketplace and home-services app for Bangladesh.

## Platforms

Shared Flutter codebase for Android and responsive Web. iOS needs macOS/Xcode and Apple signing. Build artifacts, backend deployment, public hosting, device QA and Play Store publication are separate milestones.

## Verified build status (14 November 2026)

- **Android APK/AAB:** Latest fully verified build [43565797120](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43565797120) succeeded. Both artifacts are present: `Elyramart-APK-release` and `Elyramart-Play-Store-AAB`. A newer rebuild [43566534555](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43566534555) is in progress after adding optional upload-key signing support.
- **Web:** Latest build [43566515356](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43566515356) succeeded and produced `Elyramart-Web-release` (about 14.3 MB).
- **GitHub Pages:** Deploy [43566515428](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43566515428) failed at **Configure GitHub Pages**; repository owner must set Settings → Pages → Source = GitHub Actions.
- **Firebase Hosting:** Deploy [43566515366](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43566515366) stopped at configuration validation because required Firebase secrets are missing.
- **Firebase backend:** Deploy [43566429137](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43566429137) stopped at credential validation; `FIREBASE_SERVICE_ACCOUNT_JSON` must contain a Google Cloud service-account key JSON, not Android `google-services.json`.
- **Firebase Functions:** TypeScript compile check [43566429172](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43566429172) succeeded.

A successful build is not proof of full live functionality, real-device QA or Play Store publication. See [the Bengali owner setup guide](docs/OWNER_ACTIONS_BN.md), [the detailed launch checklist](docs/LAUNCH_CHECKLIST_BN.md), and [the file audit](docs/FILE_AUDIT_BN.md).

## App capabilities in source

- Bangla/English interface and Elyramart short E brand mark.
- Customer email/password authentication and email verification flow.
- Customer catalogue/cart/checkout and order history screens.
- Seller and technician applications, approval flows, product submission and admin screens.
- COD order callable source with server-side product/stock validation.
- Product image upload and FCM notification source.
- Firestore and Storage security rules.

These capabilities require Firebase Console setup, successful backend deployment and end-to-end device tests before being described as live production services. Current checkout supports Cash on Delivery; bKash/Nagad/card gateway integration is not implemented. Rider self-service app, live GPS tracking and settlement are not implemented.

## Build workflows

- Android APK and Play Store AAB: `.github/workflows/build-apk.yml`
- Flutter Web build artifact: `.github/workflows/build-web.yml`
- GitHub Pages deploy: `.github/workflows/deploy-pages.yml`
- Firebase backend deploy: `.github/workflows/deploy-firebase.yml`
- Firebase Hosting deploy: `.github/workflows/deploy-hosting.yml`
- Firebase Functions compile check: `.github/workflows/check-functions.yml`

## Developer documentation

- [বাংলা Repository File Audit](docs/FILE_AUDIT_BN.md)
- [বাংলা Developer Handoff](docs/DEVELOPER_HANDOFF_BN.md)
- [বাংলা Firebase Setup](docs/FIREBASE_SETUP_BN.md)
- [বাংলা Project Status and Verified Blockers](docs/PROJECT_STATUS_BN.md)
- [Production Readiness Checklist](docs/PRODUCTION_READINESS.md)
- [বাংলা End-to-end Launch Checklist](docs/LAUNCH_CHECKLIST_BN.md)
- [Privacy Policy draft (বাংলা)](docs/PRIVACY_POLICY_DRAFT_BN.md)
- [Terms draft (বাংলা)](docs/TERMS_DRAFT_BN.md)

## Security

Never commit service-account private keys, upload keystores/passwords, payment secrets or admin credentials. Never paste these secrets into chat. Android `google-services.json` is client configuration and is not a deploy credential.

## Versioning

Keep Flutter source as the single source of truth. Add tests for business rules and document schema changes before production releases.
