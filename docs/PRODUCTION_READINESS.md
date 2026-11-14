# Elyramart production readiness

সর্বশেষ যাচাই: ১৪ নভেম্বর ২০২৬

এই নথিতে repository-তে থাকা code, CI build এবং live production deployment আলাদা করে দেখানো হয়েছে। Build success মানেই Firebase backend live, বাস্তব ফোনে QA সম্পন্ন, অথবা Play Store release-ready নয়।

## CI-তে যাচাইকৃত

- Android workflow run: https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43499666854 — success; commit `6f9b1da19314c388258f49b97d8a55c112f8cc2f`। APK artifact `Elyramart-APK-release` (~26.7 MB) এবং AAB artifact `Elyramart-Play-Store-AAB` (~56.1 MB) তৈরি হয়েছে। Artifacts ২৭ নভেম্বর ২০২৬ পর্যন্ত রাখা হবে।
- Web workflow run: https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43499666897 — success; `Elyramart-Web-release` (~14.3 MB) artifact তৈরি।
- Firebase Functions compile: https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43499739123 — success।
- Firebase deploy: https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43499739022 — failed at credential validation. Secret `FIREBASE_SERVICE_ACCOUNT_JSON`-এ service-account key JSON-এর আবশ্যিক `type`, `project_id`, `private_key`, `client_email`, `token_uri` fields পাওয়া যায়নি। Android `google-services.json` এই secret-এর বিকল্প নয়।
- GitHub Pages deploy: https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43499666844 — failed at Pages enablement/configuration. Repository owner-কে Settings → Pages → Build and deployment → Source-এ GitHub Actions নির্বাচন/enable করতে হবে।

## Repository-তে থাকা প্রধান code

- Flutter Android marketplace client; বাংলা/ইংরেজি UI ও short E brand mark।
- Customer email/password authentication এবং email verification flow।
- Seller ও technician application এবং owner/admin approval UI।
- Seller product submission/publication flow।
- Server-side COD order callable; stock validation ও Firestore transaction logic।
- Delivery fee setting; default ৳৮০।
- Product image upload ও FCM notification code।
- Firestore/Storage security rules, Android APK/AAB workflow, Web build/Pages workflow এবং Codemagic YAML।

উপরের feature code থাকা মানে production Firebase project-এ সেগুলো deployed বা বাস্তবে tested—এমন নয়।

## Live launch-এর জন্য এখনো প্রয়োজন

1. Firebase Console project `elyramart`-এ Email/Password Authentication, Firestore ও Storage প্রস্তুত/যাচাই।
2. সঠিক Google Cloud service-account JSON-কে GitHub Actions secret `FIREBASE_SERVICE_ACCOUNT_JSON` হিসেবে সংরক্ষণ এবং Firebase deploy workflow সফল করা।
3. Cloud Functions-এর জন্য প্রয়োজন হলে Blaze billing ও Google Cloud API enablement। মালিকের স্পষ্ট অনুমতি ছাড়া paid billing পরিবর্তন নয়।
4. Firebase deploy-এর পর owner email `elyramartbd@gmail.com` দিয়ে verified account sign-in করে app-এর মাধ্যমে Owner Admin claim করা।
5. Repository Settings → Pages-এ GitHub Actions source enable করে Pages workflow পুনরায় চালানো।
6. Android release upload signing key ও password নিরাপদে তৈরি/সংরক্ষণ এবং CI signing configure করা। বর্তমান AAB artifact-কে signed Play upload bundle ধরে নেওয়া যাবে না।
7. Real-device QA: customer, seller, technician, admin, order, stock, booking, image upload, notifications এবং security rules।
8. Privacy policy, terms, seller/technician verification, cancellation/refund/support information এবং Play Console declarations সম্পন্ন।
9. Play Console developer account, app-content/data-safety declarations, signed AAB upload, testing track এবং Google review।

## এখনও implement হয়নি / merchant বা product সিদ্ধান্ত প্রয়োজন

- bKash/Nagad/card gateway: বর্তমান checkout Cash on Delivery (COD)।
- Rider self-service app/login, live GPS tracking, proof of delivery এবং rider settlement।
- Production end-to-end QA এবং public website hosting।
- App Store/iOS release-এর জন্য আলাদা Apple signing ও App Store Connect setup।

## Security guardrails

- Service-account JSON, private key, upload keystore/password বা payment credentials কখনো chat, issue, log বা repository-তে commit করবেন না।
- Firebase service-account secret-এ Android `google-services.json` ব্যবহার করবেন না।
- Billing plan বা paid service চালু করার আগে মালিকের অনুমতি নিতে হবে।
- Payment PIN/OTP/card secrets কখনো অ্যাপে সংগ্রহ বা Firestore-এ সংরক্ষণ করবেন না।
- Order total, stock, commission ও payment verification trusted server-এ validate করতে হবে।
