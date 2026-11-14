# Elyramart প্রকল্পের বর্তমান অবস্থা

সর্বশেষ যাচাই: ১৪ নভেম্বর ২০২৬  
Repository: https://github.com/mdabirbhuiyasandwip-boop/elyramart-android  
Latest deploy workflow change: `ec42852`

## যাচাইকৃত CI ফলাফল

- **Android APK/AAB build:** [run 43567716158](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43567716158) — success; APK 26.7 MB এবং AAB 56.2 MB artifact তৈরি। Signing secrets অনুপস্থিত ছিল, তাই AAB unsigned; Play Console upload-ready নয়।
- **Web build:** [run 43567716156](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43567716156) — success; Web artifact 14.3 MB।
- **GitHub Pages:** [run 43567976719](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43567976719) — Flutter Web build ও tests success; Pages publish steps skipped, কারণ owner variable `ENABLE_GITHUB_PAGES_DEPLOY=true` করা হয়নি। Public website URL এখনো verified নয়।
- **Firebase Rules:** [run 43570891759](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43570891759) — success; Firestore Rules project-এ deploy হয়েছে।
- **Firebase Functions:** একই workflow-তে TypeScript build success; Cloud Functions deployment skipped। Blaze billing চালু করা হয়নি।
- **Firebase Storage:** deployment skipped; Storage bucket/Blaze setup ও owner approval বাকি।

## অ্যাপের source-এ থাকা প্রধান capability

- Flutter Android marketplace UI; বাংলা/ইংরেজি এবং Elyramart short E mark।
- Customer email/password authentication ও email verification flow।
- Product catalogue, cart, Cash on Delivery checkout ও order history code।
- Seller ও technician application এবং owner/admin approval UI।
- Seller product submission ও product management code।
- Cloud Functions source: trusted COD order creation/stock validation, admin claim ও notifications।
- Firestore/Storage rules, product image upload ও FCM source code।
- Android APK/AAB, Web build, GitHub Pages এবং Firebase deploy workflows।

**গুরুত্বপূর্ণ:** source code-এ feature থাকা মানে live production backend-এ deployed বা বাস্তব ফোনে tested হওয়া নয়। Firestore Rules deploy হয়েছে; callable order function live নয়।

## এখনো owner-এর হাতে থাকা কাজ

1. Firebase Console-এ Email/Password Authentication ও Firestore database প্রস্তুত/যাচাই এবং owner email verify করা।
2. Blaze billing খরচ বুঝে অনুমোদন না দেওয়া পর্যন্ত Cloud Functions ও Storage deploy করা যাবে না। Functions চালু হলে `ENABLE_CLOUD_FUNCTIONS_DEPLOY=true` variable দিতে হবে।
3. Web app Firebase config-এর ছয়টি `ELYRAMART_FIREBASE_*` secrets যোগ করা; এরপর GitHub Pages variable/Pages settings অথবা Firebase Hosting setup করে public URL publish করা।
4. Android upload keystore তৈরি, offline backup, চারটি signing secret যোগ করে signed AAB rebuild ও signature verify করা।
5. Real Android device-এ customer/seller/technician/admin, checkout, order, stock, booking, image upload, notification ও security rules end-to-end QA।
6. Privacy policy/terms যাচাই, seller agreement, cancellation/refund/support info এবং Play Console declarations সম্পন্ন।
7. Play Console account, identity verification, internal testing, signed AAB upload ও Google review।

## এখনো implement হয়নি

- bKash/Nagad/card gateway; বর্তমান payment option COD।
- Rider self-service app/login, live GPS tracking, proof-of-delivery ও settlement।
- Production end-to-end QA এবং verified public website hosting।
- iOS/App Store build ও signing।

## গুরুত্বপূর্ণ নিরাপত্তা

Service-account JSON/private key, Android upload keystore/password, payment secret বা OTP কখনো chat বা public repository-তে দেবেন না। Android `google-services.json` deploy credential নয়। Paid billing কেবল মালিকের সচেতন অনুমোদনে চালু হবে।
