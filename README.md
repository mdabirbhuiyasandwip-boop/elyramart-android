# Elyramart

Flutter-based marketplace and home-services app for Bangladesh.

## Platforms

Shared Flutter codebase for Android and responsive Web. iOS needs macOS/Xcode and Apple signing. Build artifacts, backend deployment, public hosting, device QA and Play Store publication are separate milestones.

## Verified build status (14 November 2026)

- **Android APK/AAB:** Build [43567716158](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43567716158) succeeded and produced `Elyramart-APK-release` (26.7 MB) and `Elyramart-Play-Store-AAB` (56.2 MB). CI log confirms upload-signing secrets were absent, so the AAB is **unsigned and not ready for Play Console upload**.
- **Web:** Build [43567716156](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43567716156) succeeded and produced `Elyramart-Web-release` (14.3 MB).
- **GitHub Pages:** Workflow [43567976719](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43567976719) built successfully, but Pages publish steps were skipped because `ENABLE_GITHUB_PAGES_DEPLOY` is not `true`. No public website URL is verified yet.
- **Firebase backend:** Firestore Rules deployment [43570891759](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43570891759) succeeded. Cloud Functions and Storage deployment were intentionally skipped to avoid enabling paid Blaze billing.
- **Firebase Functions:** TypeScript build succeeded in the same backend workflow; callable functions are not deployed/live.

A successful build is not proof of full live functionality, real-device QA or Play Store publication. See [the Bengali owner setup guide](docs/OWNER_ACTIONS_BN.md), [the detailed launch checklist](docs/LAUNCH_CHECKLIST_BN.md), and [the file audit](docs/FILE_AUDIT_BN.md).

## App capabilities in source

- Bangla/English interface and Elyramart short E brand mark.
- Customer email/password authentication and email verification flow.
- Customer catalogue/cart/checkout and order history screens.
- Seller and technician applications, approval flows, product submission and admin screens.
- House and office rental listings: landlords post properties; seekers browse and contact advertisers directly.
- Daily-life directory UI for hospitals and women's beauty parlours, with Bangladesh division/district/upazila selectors and direct call/map actions.
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

- [বাংলা Code & File Explanation](docs/CODE_EXPLANATION_BN.md)
- [বাসা ও অফিস ভাড়া ফিচার গাইড](docs/RENTAL_MARKETPLACE_BN.md)
- [মালিকের লগইন ও দৈনন্দিন সেবা ডিরেক্টরি](docs/OWNER_LOGIN_AND_DAILY_DIRECTORY_BN.md)
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
