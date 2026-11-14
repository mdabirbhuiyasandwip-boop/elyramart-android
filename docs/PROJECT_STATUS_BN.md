# Elyramart প্রকল্পের বর্তমান অবস্থা

সর্বশেষ আপডেট: ১৪ নভেম্বর ২০২৬  
Repository: https://github.com/mdabirbhuiyasandwip-boop/elyramart-android

## বাসা ও অফিস ভাড়া — সংশোধিত নিয়ম

- শুধু বাড়ি/ফ্ল্যাট/অফিসের বিজ্ঞাপনদাতা পোস্ট করবেন।
- বাসা/অফিস খোঁজার মানুষ পোস্ট করবেন না; বিজ্ঞাপন দেখে সরাসরি ফোনে যোগাযোগ করবেন।
- Firestore rules-এ `listingType: offer` ছাড়া নতুন listing তৈরি নিষিদ্ধ; পুরোনো wanted posts app browse screen-এ দেখানো হয় না।

## হাসপাতাল ও মেয়েদের পার্লার ডিরেক্টরি

- Home screen-এ হাসপাতাল ও মেয়েদের পার্লার directory entry point যোগ হয়েছে।
- Offline location asset-এ ৮ বিভাগ, ৬৪ জেলা, ৪৯৫ উপজেলা আছে; user location ধরে filter করতে পারে।
- Active `directoryListings` records দেখায়; phone dialer এবং Google Maps search action আছে।
- সরকারি DGHS registry link fallback আছে। DGHS facility data import করা হয়নি; পার্লারের verified nationwide dataset-ও এখনো নেই।
- Owner Admin-only Firestore rules directory records protect করে। বিস্তারিত `docs/OWNER_LOGIN_AND_DAILY_DIRECTORY_BN.md`.

## নতুন বাসা ও অফিস ভাড়া ফিচার

- হোম স্ক্রিনে **বাসা ও অফিস ভাড়া** বিভাগ যোগ হয়েছে।
- কেবল ভাড়া দেওয়ার বিজ্ঞাপন পোস্ট করা যায়; খোঁজার ব্যবহারকারী সরাসরি বিজ্ঞাপনদাতার সঙ্গে যোগাযোগ করবেন।
- বাসা ও অফিস আলাদা filter-এ দেখা যাবে।
- শিরোনাম, মাসিক ভাড়া/বাজেট, এলাকা, ফোন ও বিস্তারিত দেখা যাবে।
- ইমেইল-ভেরিফায়েড account ছাড়া পোস্ট করা যাবে না।
- Firestore-এর `rentalListings` collection-এ পোস্ট সংরক্ষণ হয়।
- Firestore Rules-এ active listing read, owner-only verified create এবং owner/admin delete permission যোগ হয়েছে।
- ফিচারের বিস্তারিত: [RENTAL_MARKETPLACE_BN.md](RENTAL_MARKETPLACE_BN.md)।
- **সীমাবদ্ধতা:** listing ছবি, map, chat, favourite, edit/delete UI, report/scam review এবং admin moderation screen এখনো নেই। Firebase online configuration না থাকলে rental section live data দেখাতে পারবে না।

## যাচাইকৃত CI ফলাফল

- **Firestore Rules:** [run 43571797191](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43571797191) — success; rental listing rules-সহ Firestore Rules compile ও deploy সফল।
- **Android APK:** নতুন rental feature-এর পর build [run 43571843244](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43571843244) — যাচাই চলছে।
- **Web build:** [run 43571843264](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43571843264) — যাচাই চলছে।
- **Automated test:** rental marketplace screen-এর widget test যোগ হয়েছে; নতুন CI run-এর ফলাফল না আসা পর্যন্ত pass বলা হচ্ছে না।
- আগের Android APK/AAB build [run 43567716158](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43567716158) সফল হয়েছিল; APK 26.7 MB এবং AAB 56.2 MB ছিল। Signing secrets না থাকায় AAB unsigned ছিল।
- আগের Web build [run 43567716156](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43567716156) সফল হয়েছিল।
- GitHub Pages build [run 43567976719](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43567976719) সফল হলেও publish step skipped ছিল; public website URL এখনো verified নয়।
- Cloud Functions TypeScript build হয়; Cloud Functions deployment billing এড়াতে বন্ধ। তাই callable COD order function live নয়।
- Firebase Storage deployment বন্ধ; bucket/Blaze setup বাকি।

## অ্যাপের source-এ থাকা প্রধান capability

- Flutter Android marketplace UI; বাংলা/ইংরেজি এবং Elyramart short E mark।
- Customer email/password authentication ও email verification flow।
- Product catalogue, cart, Cash on Delivery checkout ও order history code।
- Seller ও technician application এবং owner/admin approval UI।
- Seller product submission ও product management code।
- বাসা/অফিস ভাড়া দেওয়া এবং বাসা/অফিস খোঁজার পোস্ট।
- Cloud Functions source: trusted COD order creation/stock validation, admin claim ও notifications।
- Firestore/Storage rules, product image upload ও FCM source code।

**গুরুত্বপূর্ণ:** source code-এ feature থাকা মানে live production backend-এ deployed বা বাস্তব ফোনে tested হওয়া নয়। Rental listing rules deploy হয়েছে, কিন্তু নতুন rental feature-এর APK/Web build ও real-device QA এখনো যাচাইাধীন।

## এখনো owner-এর হাতে থাকা কাজ

1. Firebase Console-এ Email/Password Authentication ও Firestore database প্রস্তুত/যাচাই এবং owner email verify করা।
2. Cloud Functions/Storage দরকার হলে Blaze billing-এর সম্ভাব্য খরচ বুঝে নিজে সিদ্ধান্ত নেওয়া। Functions চালু হলে `ENABLE_CLOUD_FUNCTIONS_DEPLOY=true` variable দিতে হবে।
3. Web app Firebase config-এর ছয়টি `ELYRAMART_FIREBASE_*` secrets যোগ করা; এরপর GitHub Pages variable/Pages settings অথবা Firebase Hosting setup করে public URL publish করা।
4. Android upload keystore তৈরি, offline backup, চারটি signing secret যোগ করে signed AAB rebuild ও signature verify করা।
5. Real Android device-এ customer/seller/technician/admin, checkout, order, stock, booking, rental post/browse, image upload, notification ও security rules end-to-end QA।
6. Privacy policy/terms যাচাই, seller agreement, cancellation/refund/support info এবং Play Console declarations সম্পন্ন।
7. Play Console account, identity verification, internal testing, signed AAB upload ও Google review।

## এখনো implement হয়নি

- bKash/Nagad/card gateway; বর্তমান payment option COD।
- Rider self-service app/login, live GPS tracking, proof-of-delivery ও settlement।
- Rental listing ছবি, map, chat, favourite, edit/delete UI এবং moderation/report flow।
- Production end-to-end QA এবং verified public website hosting।
- iOS/App Store build ও signing।

## গুরুত্বপূর্ণ নিরাপত্তা

Service-account JSON/private key, Android upload keystore/password, payment secret বা OTP কখনো chat বা public repository-তে দেবেন না। Android `google-services.json` deploy credential নয়। Paid billing কেবল মালিকের সচেতন অনুমোদনে চালু হবে।
