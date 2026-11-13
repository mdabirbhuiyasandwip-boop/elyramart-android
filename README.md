# Elyramart

Flutter-based marketplace and home-services app for Bangladesh.

## Platforms

The intended product targets Android, iOS and responsive Web from a shared Flutter codebase. Android APK and Flutter Web build workflows are provided. iOS requires macOS/Xcode and Apple signing. Web hosting and a shared cloud backend are separate launch steps.

## Current prototype status

Build status is verified in GitHub Actions, not assumed from source changes. The most recent APK attempt before the Kotlin-DSL fix stopped during Firebase Gradle setup; a corrected build is running. Do not treat this prototype as a tested release until the APK workflow completes and uploads its artifact.

The current app is still a **pre-launch prototype**, not a live marketplace:
- Customer profile, cart, order history and service requests are still stored on the current device. Firebase email/password sign-in and registration UI is now connected to Firebase Auth; authenticated customer profiles can be written to Firestore when the required Firebase providers and database are enabled.
- Seller demo can create and manage products locally. The public product list starts empty; no sample products are included.
- Seller, admin and technician screens still demonstrate intended workflows locally. The owner-admin claim button calls the protected Cloud Function, but only works after the function is deployed and the verified owner email parameter is configured.
- Home-services include technicians and restaurant-related services. Restaurant food/products are not preloaded.
- The Elyramart brand mark uses the short E symbol.

**Not live yet:** phone OTP, production-tested shared catalog/orders/bookings, seller/technician approval workflow, remote order dispatch, payment gateway, notifications and production hosting. Email/password auth and initial customer profile sync are implemented in the app but require Firebase Console setup and live-device testing.

## Build Android APK

The GitHub Actions workflow `.github/workflows/build-apk.yml` runs on pushes to `main` and can be started manually from Actions. It runs Flutter dependency resolution, static analysis, widget tests and a release APK build. The output artifact is named `Elyramart-APK-release`.

## Build Web

The workflow `.github/workflows/build-web.yml` builds the Flutter Web release and uploads `Elyramart-Web-release`. A separate GitHub Pages workflow exists, but automatic Pages enablement currently fails because the repository's Pages site has not been enabled/authorized. The Web build artifact itself succeeds.

## Developer documentation

- [বাংলা Developer Handoff: Android, iPhone, Web, cloud architecture and launch checklist](docs/DEVELOPER_HANDOFF_BN.md)
- [বাংলা Firebase setup and proposed data model](docs/FIREBASE_SETUP_BN.md)

## Suggested backend

Firebase Authentication, Cloud Firestore, Firebase Storage, Cloud Functions and Firebase Cloud Messaging are proposed. An Android Firebase client configuration (`google-services.json`) is included for the registered Android app. Firebase Console services (Authentication, Firestore, Storage and Functions) still need to be enabled/deployed and tested before cloud features are live. Never commit service-account private keys or admin credentials. Never commit service-account private keys, admin credentials or payment secrets.

## Versioning

Keep the Flutter source as the single source of truth. Add automated tests and document schema changes before production releases.
