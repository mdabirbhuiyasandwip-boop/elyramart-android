# Elyramart production readiness

This document separates code that exists in the repository from services that still require owner-side Firebase/Google Play configuration. A successful Flutter build does not mean the live backend has been deployed or the app is ready to accept real orders.

## Implemented in the app/repository

- Flutter Android marketplace client with Bangla/English interface and the short E brand mark.
- Email/password customer authentication and email-verification checks for online actions.
- Seller and technician applications with owner/admin approval flows.
- Seller product submission and admin publication flow.
- Server-side COD order callable that reads current product prices and stock, checks stock, decrements inventory in a Firestore transaction, and creates the order.
- Customer order history, seller order visibility/status flow, and technician booking/assignment screens.
- Firestore and Storage security rules are checked into the repository.
- Android build workflow builds both APK and Play Store AAB and uploads them as workflow artifacts.
- Codemagic YAML configuration is checked into the repository.

## Not yet live / owner action required

1. **Firebase backend deployment:** The latest backend deployment attempt failed because the GitHub Actions secret `FIREBASE_SERVICE_ACCOUNT_JSON` was not a Google Cloud service-account key. The Android `google-services.json` file is not a service-account key and must not be used for this secret.
2. Create a dedicated Google Cloud service account for deployment, grant only the required Firebase deployment permissions, create a JSON key, and save the entire JSON as the repository secret `FIREBASE_SERVICE_ACCOUNT_JSON`. Never paste the key into chat or commit it to the repository. Then rerun the `Deploy Elyramart Firebase backend` workflow.
3. In Firebase Console, confirm Email/Password Authentication is enabled and the Firestore database and Storage bucket exist in project `elyramart`.
4. Set the owner email parameter to `elyramartbd@gmail.com` for the Functions deployment. The owner must sign in with that verified email and claim Owner Admin inside the app after deployment.
5. **Billing:** Cloud Functions deployment/runtime may require the Firebase project to be on the Blaze billing plan. Do not upgrade or authorize paid usage without the account owner's explicit approval.
6. **Android release signing:** The current CI build produces APK/AAB artifacts, but a Play Store production release requires a protected upload keystore and signing secrets. Generate and securely back up the upload key; never commit it or share its password in chat. Configure the signing values in the build system before a production release.
7. **Play Store:** The owner must create/verify the Play Console developer account, complete identity and app-content declarations, provide privacy policy/data-safety details, and submit the signed AAB. These account/legal steps cannot be completed by repository code alone.

## Features that are not implemented yet

- bKash/Nagad/card gateway integration. At present the only enabled checkout method is Cash on Delivery. A real gateway needs an approved merchant account and API credentials.
- Delivery rider assignment, delivery tracking, rider settlement, and delivery-fee calculation.
- Push notifications (Firebase Cloud Messaging) for orders, seller updates, and technician bookings.
- Live production end-to-end tests using real customer, seller, admin, and technician accounts.
- A publicly deployed production website/hosting setup.

## Build evidence

- A previous GitHub Actions Android build completed successfully and produced APK and AAB artifacts. That build was for an earlier commit, not proof that the latest commit has passed.
- A newer Android build run was started for the current source, but its job remained in progress at the last check and had no artifacts yet. Do not treat it as a successful build until GitHub reports a completed success and the artifacts are present.
- Firebase Functions TypeScript compilation succeeded in CI, but the Firebase deployment failed at credential validation. The backend is therefore not confirmed live.
