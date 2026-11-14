# Elyramart production readiness

সর্বশেষ যাচাই: ১৪ নভেম্বর ২০২৬

এই নথিতে repository-তে থাকা code, CI build এবং live production deployment আলাদা করে দেখানো হয়েছে। Build success মানেই Firebase backend live, বাস্তব ফোনে QA সম্পন্ন, অথবা Play Store release-ready নয়।

## CI-তে যাচাইকৃত

- Android APK/AAB: [run 43565797120](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43565797120) — success; APK ও AAB artifacts উপস্থিত। নতুন upload-key signing support-সহ rebuild [run 43566883247](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43566883247) যাচাইাধীন।
- Web: [run 43566515356](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43566515356) — success; `Elyramart-Web-release` artifact তৈরি।
- Firebase Functions compile: [run 43566429172](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43566429172) — success।
- Firebase backend deploy: [run 43566429137](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43566429137) — credential validation-এ ব্যর্থ; `FIREBASE_SERVICE_ACCOUNT_JSON`-এ সঠিক service-account JSON প্রয়োজন।
- Firebase Hosting deploy: [run 43566515366](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43566515366) — ছয়টি Web config secret ও Service Account validation-এ ব্যর্থ।
- GitHub Pages deploy: [run 43566515428](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43566515428) — Pages configuration/enablement-এ ব্যর্থ; owner-কে Settings → Pages → Source = GitHub Actions নির্বাচন করতে হবে।


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
5. Repository Settings → Pages-এ GitHub Actions source enable করে Pages workflow পুনরায় চালানো; অথবা Firebase Hosting workflow-তে Service Account ও ছয়টি Web config secret যোগ করা।
6. Android release upload signing key ও password নিরাপদে তৈরি/সংরক্ষণ এবং CI secrets configure করা। আগের AAB artifact-কে signed Play upload bundle ধরে নেওয়া যাবে না; নতুন signing workflow সফল হলে signature যাচাই করতে হবে।
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
