# Elyramart প্রকল্পের বর্তমান অবস্থা

সর্বশেষ আপডেট: ১৪ নভেম্বর ২০২৬  
Repository: https://github.com/mdabirbhuiyasandwip-boop/elyramart-android

## ১৪ নভেম্বর ২০২৬ — ডেমো কনটেন্ট বাদ দিয়ে বাস্তব ডেটা ব্যবহারের কাজ

- Home catalogue থেকে কাল্পনিক ছয়টি sample product সরানো হয়েছে; এখন শুধু Firestore-এর active seller listing আসে।
- Product card-এ category stock photo fallback বন্ধ; পণ্যের নিজের uploaded image ছাড়া product listing দেখানো হবে না।
- Home hero/category/service stock imagery বাদ দিয়ে clean icon/brand treatment ব্যবহার করা হয়েছে।
- সেলার পণ্য জমা দিতে লগইন, অনুমোদিত seller এবং নিজের তোলা আসল পণ্যের ছবি আবশ্যক।
- লগইন ছাড়া service booking বা checkout সফল/সংরক্ষিত বলে দেখানো হয় না; আগে account login করতে বলে।
- Customer profile local-only demo save বন্ধ; verified account দিয়ে cloud sync ছাড়া profile saved বলে দেখায় না।
- Technician আবেদনও verified login ছাড়া জমা হয় না; local-only technician profile/booking demo load বন্ধ করা হয়েছে।
- Firebase initialization ব্যর্থ হলে Home-এ স্পষ্ট server connection warning দেখায়।
- Widget tests-এ empty real catalogue ও login-required profile save-এর expectation যোগ করা হয়েছে।

**এখনো live নয়:** Firebase Storage bucket/Blaze setup ও Storage rules deployment, Cloud Functions deployment (Blaze billing দরকার), real seller product data, Android CI build result এবং physical-device QA। এই পরিবর্তনগুলোর পর build/test pass হয়েছে—CI result না দেখা পর্যন্ত এমন দাবি করা যাবে না।

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

1. Firebase service-account secret `FIREBASE_SERVICE_ACCOUNT_JSON` যাচাই হয়েছে এবং Firestore Rules deploy সফল। Firebase Console-এ Email/Password Authentication ও owner email verification এখনো বাস্তবে যাচাই করতে হবে।
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


## ১৪ নভেম্বর ২০২৬ — APK/AAB build সম্পন্ন

- Android workflow run [43581917105](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43581917105) সফল। Flutter analyze, widget tests, release APK build ও AAB build—সব ধাপ সফল।
- APK artifact: `Elyramart-APK-release` (ZIP-এ `app-release.apk`); artifact ID `14109195976`; মেয়াদ ২৮ নভেম্বর ২০২৬ পর্যন্ত।
- AAB artifact: `Elyramart-Play-Store-AAB` (ZIP-এ `app-release.aab`); artifact ID `14109310618`; মেয়াদ ২৮ নভেম্বর ২০২৬ পর্যন্ত।
- AAB signature inspection-এ `CN=Android Debug` পাওয়া গেছে; এটি Play Store upload keystore signature নয়। Production upload-এর আগে মালিকের নিজস্ব upload keystore ও চারটি GitHub signing secret দিয়ে পুনরায় build/sign করতে হবে।
- APK build success মানে বাস্তব Android ফোনে install/run বা Firebase end-to-end QA সম্পন্ন হয়েছে—এমন নয়।
- Owner Admin panel source-এ রাখা আছে এবং admin custom claim ছাড়া প্রবেশ বন্ধ। Cloud Functions/Blaze চালু না করায় `claimOwnerAdmin` এখনো live নয়; প্যানেলের production online actions আপাতত সীমিত। কোনো paid billing enable করা হয়নি।


## ১৪ নভেম্বর ২০২৬ — Release preflight (সর্বশেষ যাচাই)

### CI-তে যাচাইকৃত
- Android workflow run [43581917105](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43581917105) এবং job conclusion: **success**।
- Flutter analyzer: কোনো Error/Warning পাওয়া যায়নি; ৪৯টি Info-level lint/style suggestion আছে। Workflow-এর analyzer step Info-কে failure ধরে না।
- Widget test: **৬/৬ pass** — phone normalization, out-of-stock cart guard, sign-out-এর পর cached profile না দেখানো, rental screen, Bangladesh location filters, এবং main navigation/account flows।
- Release APK (55.6 MB) ও AAB (56.7 MB) build এবং artifact upload সফল।
- Artifact ID: APK `14109195976`; AAB `14109310618`। Artifact retention ১৪ দিন; ২৮ নভেম্বর ২০২৬ পর্যন্ত download করা যাবে।
- APK ও AAB archive integrity যাচাই হয়েছে। AAB certificate হলো `CN=Android Debug`; এটি Play Store release signing নয়।

### Release blocker — এখনো সম্পন্ন নয়
- বাস্তব Android ফোনে install/launch এবং end-to-end QA হয়নি।
- Firebase Email/Password login, email verification ও owner account বাস্তবে যাচাই বাকি।
- Cloud Functions deploy হয়নি; COD server-side callable ও Owner Admin claim function live নয়।
- Firebase Storage bucket/rules deploy হয়নি; seller image upload live নয়।
- Owner Admin UI source-এ আছে, কিন্তু custom claim ছাড়া production admin access/online actions কার্যকর নয়।
- bKash/Nagad/card gateway নেই; checkout-এর production COD flow-ও Functions deploy না হওয়া পর্যন্ত সম্পূর্ণ নয়।
- Signed AAB-এর জন্য owner-owned upload keystore ও চারটি protected GitHub secret বাকি।
- Public website hosting/configuration, privacy/terms এবং Play Console review বাকি।

### সিদ্ধান্ত
**এটি CI-তে build ও widget-test pass করা install-test candidate; production launch বা Play Store submission-ready release নয়।** কোনো paid Firebase billing চালু করা হয়নি। Owner-এর স্পষ্ট অনুমতি ছাড়া billing enable করা যাবে না।


## ১৪ নভেম্বর ২০২৬ — লগইন স্থিতিশীলতা ও মোবাইল OTP

- Email/password login-এর পর Firestore profile sync সাময়িকভাবে ব্যর্থ হলেও authentication সফল থাকলে অ্যাপ আর ভুল করে login failure দেখাবে না।
- নতুন account তৈরি হওয়ার পর verification email বা profile sync সাময়িকভাবে ব্যর্থ হলেও account creation-এর সফলতা আলাদাভাবে দেখানো হয়।
- Firebase Phone Authentication-এর Android OTP request, SMS code verification, automatic SMS verification, resend এবং বাংলা error message-এর client flow যোগ হয়েছে।
- **OTP live activation এখনো বাকি:** Firebase Console → Authentication → Sign-in method-এ Phone provider enable, SMS region policy যাচাই, Android app SHA-1/SHA-256 fingerprint যোগ, real device-এ SMS delivery ও abuse/limit testing প্রয়োজন। Firebase billing/SMS charge হতে পারে; owner অনুমতি ছাড়া billing enable করা হবে না।
- Google Sign-In ও email numeric OTP এখনো live নয়; email/password ও email verification link বিদ্যমান পদ্ধতি।
- Commit `1da47afe494556b026f445e260238ee7e65fb9fa`-এ পরিবর্তন push হয়েছে। Android/Web CI run [43586109910](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43586109910) / [43586109896](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43586109896) যাচাই চলছে; ফলাফল না আসা পর্যন্ত build/test pass বলা হচ্ছে না।


## ১৪ নভেম্বর ২০২৬ — সর্বশেষ পুনঃযাচাই (commit cefe05f8)

- Android source verification, Flutter package resolution, Dart analyze এবং widget tests সফল। Release APK build ধাপ এখনো চলমান; এই যাচাইয়ের সময় APK/AAB artifact তৈরি হয়নি। তাই APK download link এখনো দেওয়া যাচ্ছে না। [Android workflow](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43586412860)
- Web release build সফল এবং `Elyramart-Web-release` artifact তৈরি হয়েছে। এটি build artifact, public website deployment নয়। [Web workflow](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43586412811)
- GitHub Pages build সফল হলেও publish/deploy ধাপগুলো `ENABLE_GITHUB_PAGES_DEPLOY` repository variable `true` না থাকায় skipped। কোনো public Pages URL live বলে যাচাই হয়নি।
- Firebase Hosting workflow credential check পেরোলেও ছয়টি Web Firebase config secret খালি থাকায় থেমেছে: `ELYRAMART_FIREBASE_WEB_API_KEY`, `ELYRAMART_FIREBASE_WEB_APP_ID`, `ELYRAMART_FIREBASE_MESSAGING_SENDER_ID`, `ELYRAMART_FIREBASE_PROJECT_ID`, `ELYRAMART_FIREBASE_AUTH_DOMAIN`, `ELYRAMART_FIREBASE_STORAGE_BUCKET`। [Hosting workflow](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43586412848)
- Firestore rules-এ customer নিজের profile create করতে পারে শুধু `role: customer` দিয়ে; admin claim client থেকে সেট করার অনুমতি নেই। Seller-এর product submission approval-নির্ভর। তবে order rules-এ seller update কেবল এক-seller order-এর জন্য অনুমোদিত; multi-seller order-এর পৃথক seller fulfillment flow এখনো অসম্পূর্ণ।
- Cloud Functions deploy না হওয়ায় `claimOwnerAdmin`, server-side COD order এবং notification triggers live নয়। Deploy workflow-তে `ENABLE_CLOUD_FUNCTIONS_DEPLOY=true` দিলে Blaze billing দরকার হতে পারে; মালিকের অনুমতি ছাড়া এটি চালু করা হবে না।
- Android OTP client code আছে; Phone provider/SMS region/SHA fingerprints/real SMS verification বাকি। Google Sign-In, email numeric OTP, online payment gateway, rider live tracking, iOS build, production device QA এবং signed Play Store AAB এখনো অসম্পূর্ণ।
- Firebase setup guide-এর পুরোনো “OTP UI নেই” বক্তব্য সংশোধন করা হয়েছে।

**বর্তমান সিদ্ধান্ত:** source ও Web build CI-তে যাচাইকৃত; APK build ফলাফল pending। Elyramart এখনো production launch-ready নয়। বাস্তব ফোনে পরীক্ষা, live Firebase backend, private Owner Admin, secure payment/delivery workflow এবং signed AAB ছাড়া launch সম্পূর্ণ বলা যাবে না।


## ১৪ নভেম্বর ২০২৬ — OTP ও অর্ডার অনুমতির সামঞ্জস্য

- Firestore-এর `verifiedUser()` এখন Firebase-verified email **অথবা** Firebase Phone Authentication-এর verified `phone_number` token গ্রহণ করে। ফলে ফোন OTP ব্যবহারকারী customer-দের service booking, seller/technician application ও rental post rules-এ অযথা email-only বাধা থাকার কথা নয়।
- Cloud Function `placeOrder`-এর authentication guard-ও verified email অথবা verified phone token গ্রহণ করার মতো করা হয়েছে; COD order backend code এখন phone OTP user-দেরও অনুমতি দেবে।
- পরিবর্তনের পর Functions TypeScript compile workflow এবং Firebase backend workflow চালু হয়েছে। Compile ও Firestore rules deployment শেষ না হওয়া পর্যন্ত এই পরিবর্তন live/verified বলা হচ্ছে না। Cloud Functions deployment এখনো billing variable বন্ধ থাকায় করা হবে না।
- Multi-seller order fulfilment-এর সীমাবদ্ধতা রয়ে গেছে: Firestore rules-এ seller update বর্তমানে এক seller-যুক্ত order-এর জন্য অনুমোদিত; split seller order lifecycle আলাদা করে implement/test করতে হবে।


## ১৪ নভেম্বর ২০২৬ — OTP permission fix: CI ও Firestore deploy verified

- Firebase Functions TypeScript compile workflow [43586826897](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43586826897) **success**।
- Firestore rules compile ও Firebase project `elyramart`-এ deploy workflow [43586823063](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43586823063) **success**। Deploy log-এ rules compiled successfully এবং released rules দেখা গেছে। এখন verified email অথবা Firebase-verified phone token—দুই ধরনের user Firestore-এর verified-user gated actions ব্যবহার করতে পারবে।
- Cloud Functions deploy step paid billing variable বন্ধ থাকায় চালানো হয়নি; COD callable ও Owner Admin claim এখনো live নয়। Storage deployment-ও বন্ধ।
- APK workflow [43586412860](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43586412860)-এ Analyze ও Widget Tests সফল; Release APK build step এখনো in progress, AAB/artifact upload pending। APK/AAB পাওয়া না পর্যন্ত build complete বলা যাবে না।


## ১৪ নভেম্বর ২০২৬ — সর্বশেষ যাচাই (বিকাল)

- Android workflow run [43586412860](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43586412860) সম্পূর্ণ **success**: Flutter analyze, widget tests, release APK ও Play Store AAB build এবং artifact upload সফল।
- APK artifact `Elyramart-APK-release`, artifact ID `14110683476`; AAB artifact `Elyramart-Play-Store-AAB`, artifact ID `14110837870`; উভয়ের GitHub artifact মেয়াদ ২৮ নভেম্বর ২০২৬ পর্যন্ত।
- Downloaded APK/AAB-এর signature পরীক্ষা: certificate subject `CN=Android Debug`; তাই AAB Play Console production upload-এর জন্য signed নয়। APK-ও production signing নয়।
- Firebase deploy run [43586823063](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43586823063) success: Firestore Rules deploy হয়েছে। Cloud Functions deployment billing gate-এর কারণে skipped; Storage deployment bucket/enablement gate-এর কারণে skipped।
- GitHub Pages workflow deploy condition `ENABLE_GITHUB_PAGES_DEPLOY == true`; variable enabled নয়, তাই deployment হয়নি। Web artifact build-only.
- Phone OTP code path build হয়েছে; Firebase Phone provider, SMS policy/quota and real handset SMS flow independently verified নয়.
- Owner Admin custom claim callable live নয় যতক্ষণ Cloud Functions deploy না হয়. Online gateway, Rider live tracking, and production end-to-end handset tests remain incomplete.
- **কোনো Firebase billing plan, paid SMS, payment gateway, Play Console purchase বা other paid service এই run-এ enable করা হয়নি।** Owner approval and secure credentials required.


## ১৪ নভেম্বর ২০২৬ — মালিকের Free-only সিদ্ধান্ত

মালিক স্পষ্টভাবে জানিয়েছেন: কোনো Firebase Blaze billing, paid SMS, paid hosting, payment gateway বা অন্য paid service চালু করা যাবে না। এই সিদ্ধান্ত অনুযায়ী কোনো billing বা paid service enable করা হয়নি এবং করা হবে না।

### বিনামূল্যে যাচাইকৃত/সম্পন্ন
- Android release APK/AAB CI build এবং widget tests সফল (run 43586412860); artifact তৈরি।
- Firestore Rules deployment সফল (run 43586823063)।
- Firebase Functions-এর TypeScript compile/check সফল (run 43586826897); compile সফল মানে Functions deploy নয়।
- Web release build artifact তৈরি (run 43586412811); public website deploy নয়।
- Complete source + docs archive artifact তৈরি (run 43587128667; artifact ID 14109724868; ৩০ দিন পর্যন্ত)।
- Project status, owner setup, launch checklist ও developer handoff docs repository-তে রাখা হয়েছে।

### Free-only অবস্থায় যেগুলো এখনো চালু নয়
- Cloud Functions callable deploy (Owner Admin claim, trusted COD order, server notifications) — এই project workflow-তে Blaze billing gate; তাই deploy বন্ধ থাকবে।
- Firebase Storage bucket/rules এবং cloud image upload — bucket/billing/enablement যাচাই ছাড়া live নয়।
- Phone OTP real SMS — Firebase Phone provider, SMS policy/quota ও device verification দরকার; সম্ভাব্য SMS charge থাকায় enable করা হয়নি।
- Public Firebase Hosting — Web Firebase config values ও owner configuration দরকার।
- GitHub Pages publish — repository Pages settings/owner configuration এবং valid web Firebase config দরকার; build artifact-কে live website বলা যাবে না।
- Play Store release — owner-owned upload keystore/signing secrets, Play Console account ও review দরকার; কোনো key বা account credential ChatGPT-তে পাঠানো যাবে না।
- Real Android device QA — হাতে থাকা physical device-এ install ও flow পরীক্ষা ছাড়া সম্পন্ন বলা যাবে না।

### Free-only launch boundary
বর্তমান অ্যাপটি CI-তে build/test pass করা install-test candidate, production-ready live marketplace নয়। COD screen/source থাকা সত্ত্বেও server-side callable deploy না হওয়া পর্যন্ত production COD order completion নিশ্চিত নয়। bKash/Nagad/card payment, rider live tracking ও full multi-seller fulfillment এখনো implement/deploy হয়নি। কোনো paid service ছাড়াই source, UI, tests, documentation, build artifacts এবং Firestore Rules-এ কাজ করা যাবে; কিন্তু external setup/paid gates এড়িয়ে বাস্তব live backend চালু করা যাবে না।
