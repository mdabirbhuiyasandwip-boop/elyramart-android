# Elyramart implementation status

Last reviewed: 15 November 2026.

This file separates code that exists from services that are actually deployed and verified.

## Changes made in this implementation pass
- Added a wishlist heart control to active seller product cards.
- Added a Wishlist screen reachable from the top app bar, with add-to-cart and remove actions.
- Wishlist IDs persist locally on the current device using SharedPreferences.
- Updated Android CI so `flutter analyze --no-pub` runs directly and its non-zero exit status cannot be hidden by `|| true`.
- Added the complete product requirements and phased delivery plan in `docs/PRODUCT_REQUIREMENTS.md`.
- Added a customer Help & Support screen with request categories, subject/details validation, verified-account submission, and customer-only request history.
- Added Firestore security rules for support tickets: verified users can create their own tickets; customers can read only their own; admin can review/update status and reply fields.
- Added Owner Admin ticket queue with ticket status changes and admin replies; customer support history now displays replies.
- Added owner rental listing edit form and owner-only field-limited Firestore update rule.
- Added a widget test for the support centre guest state.
- Added a Travel & Stay home shortcut and hub for toll, launch/steamer tickets, hotel booking and house/flat/office rentals. It links to the official D-Toll app, Shohoz launch-ticket app and BIWTC site; hotel API partnership research link is shown.
- The hub explicitly labels direct in-app toll payment, launch ticketing and live hotel availability/booking as not yet integrated; no fake payment or booking confirmation is shown.
- Added a widget test for the Travel & Stay hub and its integration-pending disclosures.
- Expanded the product plan to cover practical everyday-life and future-ready services: verified essential directories, transport, jobs, education, home/family support, community help, accessibility, low-data use, privacy and trust/safety. These are roadmap items, not falsely labelled live features.

## Existing source features confirmed during repository audit
- Flutter Android app with Bengali/English toggle and Elyramart E-only mark.
- Firebase email/password authentication source and phone OTP client flow (OTP provider still needs Firebase Console configuration and real-device testing).
- Firestore-backed active seller product catalogue, seller application/product management and owner approval UI.
- Cart and Cash on Delivery checkout client; trusted server-side `placeOrder` Cloud Function source validates stock and calculates delivery charge.
- House/office rental listings with search and owner-only delete; rental image upload, favourites, in-app chat and moderation/report workflow are not yet complete.
- Service directory and booking request form; technician application and assigned-booking status UI.
- Owner Admin UI checks the Firebase custom `admin` claim; the owner claim Cloud Function exists in source but is not deployed while paid Functions billing remains disabled.
- Hospital/beauty parlour directory UI and Bangladesh division/district/upazila data asset.

## Not implemented or not production-verified
- Wishlist cloud sync across devices.
- Product detail screen with full gallery, brand/condition/stock detail, and customer review/rating workflow.
- Product search filters/sort beyond the existing home search; complete category/subcategory management.
- Service provider public profiles, technician discovery by location, provider availability calendar and date/time booking.
- Genuine live technician GPS tracking and in-app chat.
- Dedicated notifications inbox and production push delivery (FCM deployment/configuration and device tests remain).
- Support ticket customer UI, Owner Admin queue, and Firestore rules are committed; rules still need deployment to Firebase before real online ticket submission can work. Staffed 24/7 live support, blog CMS and referral rewards remain future work.
- Direct toll payment integration inside Elyramart (D-Toll/official operator authorization and secure transaction confirmation still required); the current hub links users to the official D-Toll app.
- Direct launch/steamer ticket inventory and ticketing integration (authorized operator/aggregator API and booking confirmation still required); current hub links to Shohoz and BIWTC.
- Live hotel inventory, price/availability and booking/cancellation integration (hotel API contract and credentials required); current hub provides a partner research link only.
- bKash, Nagad, Rocket and card gateway integration. These remain disabled until owner approval, merchant credentials and testing.
- Rider self-service, proof of delivery and settlement.
- Rental owner edit flow is now implemented in source with restricted owner-only Firestore update rules; these rules still need Firebase deployment. Rental image gallery, saved rentals, map view and admin moderation/report queue remain incomplete.
- Production website hosting and signed Play Store AAB.
- Real-device end-to-end QA.
- The newly added future-ready roadmap modules (jobs, education, transport, family/home-care, community-help, reminders and advanced accessibility) are not implemented or production-verified.

## Current CI
- Android workflow run: https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43630016244
- Run was in progress at the time this status file was written. Do not describe the new wishlist build as passing until the workflow finishes successfully.
- Previous verified CI results are documented in `docs/PROJECT_STATUS_BN.md` and `docs/PRODUCTION_READINESS.md`.

## Owner-only setup still required
- Firebase project: enable the intended authentication providers and verify the owner email.
- If enabling Cloud Functions or Firebase Storage requires a paid billing plan, obtain the owner's explicit approval first. Do not enable billing automatically.
- Owner must create and securely store their Android upload keystore and add the required protected GitHub signing secrets before generating a Play Store upload-signed AAB.
- Owner must configure payment merchant credentials only after choosing and approving a payment provider.
- Never commit service-account keys, upload keystore files/passwords, payment secrets or OTP secrets.

## Next implementation order
1. Confirm CI passes for wishlist and analyzer changes; fix any compile/test failures.
2. Add product detail and product review/report flows.
3. Add cloud-synced customer wishlist with Firestore rules.
4. Complete rental edit/image/admin moderation.
5. Complete service-provider discovery and booking lifecycle.
6. Add support ticket and notification inbox.
7. Finish owner dashboard data and web admin.
8. Build authorized toll, launch-ticket and hotel booking integrations after provider agreements/API access; meanwhile keep the Travel & Stay hub transparent about external links and pending in-app booking.
9. Implement future roadmap modules incrementally after core marketplace is stable and each has verified data/providers.
9. Real-device QA, signed release build and Play Store preparation.
