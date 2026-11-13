# Elyramart

Flutter-based marketplace and home-services app for Bangladesh.

## Platforms

Shared Flutter codebase for Android and responsive Web. iOS needs macOS/Xcode and Apple signing. Build artifacts, backend deployment, public hosting, device QA and Play Store publication are separate milestones.

## Verified build status (14 November 2026)

- **Android:** GitHub Actions run [43499666854](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43499666854) completed successfully. Artifacts: `Elyramart-APK-release` (~26.7 MB) and `Elyramart-Play-Store-AAB` (~56.1 MB).
- **Web:** [Build run 43499666897](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43499666897) completed successfully and uploaded `Elyramart-Web-release` (~14.3 MB).
- **GitHub Pages:** [Deploy run 43499666844](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43499666844) failed at Configure GitHub Pages because the GitHub integration cannot create the Pages site. Repository owner must enable Pages and choose GitHub Actions as the deployment source in Settings → Pages, then rerun the workflow.
- **Firebase Functions:** TypeScript check [43499739123](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43499739123) succeeded. Backend deploy [43499739022](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43499739022) failed because secret `FIREBASE_SERVICE_ACCOUNT_JSON` does not contain a valid Google Cloud service-account key JSON for project `elyramart`.

A successful build is not proof of full live functionality, real-device QA or Play Store publication. See [the detailed Bengali project status](docs/PROJECT_STATUS_BN.md).

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
- Firebase Functions compile check: `.github/workflows/check-functions.yml`

## Developer documentation

- [বাংলা Developer Handoff](docs/DEVELOPER_HANDOFF_BN.md)
- [বাংলা Firebase Setup](docs/FIREBASE_SETUP_BN.md)
- [বাংলা Project Status and Verified Blockers](docs/PROJECT_STATUS_BN.md)
- [Production Readiness Checklist](docs/PRODUCTION_READINESS.md)

## Security

Never commit service-account private keys, upload keystores/passwords, payment secrets or admin credentials. Never paste these secrets into chat. Android `google-services.json` is client configuration and is not a deploy credential.

## Versioning

Keep Flutter source as the single source of truth. Add tests for business rules and document schema changes before production releases.
