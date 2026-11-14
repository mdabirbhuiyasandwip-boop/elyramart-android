# Elyramart — সব ফাইল ও কোডের সহজ বাংলা ব্যাখ্যা

এই নথি ভবিষ্যৎ মালিক ও IT technician-এর জন্য। Repository-র মূল source of truth হলো `main` branch। কোনো secret বা password এই নথিতে রাখা যাবে না।

## ১. প্রকল্পের মূল কাঠামো

| ফাইল/ফোল্ডার | সহজ ব্যাখ্যা |
|---|---|
| `lib/main.dart` | Flutter অ্যাপের প্রধান কোড। স্ক্রিন, লগইন, পণ্য, কার্ট, COD checkout, অর্ডার, seller, technician ও admin UI এখানে আছে। বর্তমানে প্রায় ১,৯৮২ লাইন; ভবিষ্যৎ technician চাইলে feature অনুযায়ী আলাদা ফাইলে ভাগ করতে পারবেন। |
| `pubspec.yaml` | অ্যাপের নাম, version এবং Flutter/Firebase package-এর তালিকা। নতুন package যোগ বা version বদলাতে এখানে পরিবর্তন হয়। |
| `pubspec.lock` | ব্যবহৃত package-গুলোর নির্দিষ্ট version lock করে; সাধারণত Flutter package manager এটি তৈরি/আপডেট করে। |
| `google-services.json` | Android app-কে Firebase project-এর সঙ্গে পরিচয় করায়। এটি server private key নয়; GitHub deploy secret-এর বিকল্পও নয়। |
| `firebase.json` | Firebase-কে বলে কোন Firestore/Storage rules এবং Cloud Functions source deploy করতে হবে; Hosting config-ও এখানে। |
| `firestore.rules` | কে কোন Firestore data দেখতে/লিখতে পারবে তার security policy। Customer, seller, technician ও admin-এর অনুমতি এখানে নিয়ন্ত্রিত। |
| `storage.rules` | Firebase Storage-এ profile/product image upload ও read permission নিয়ন্ত্রণ করে। |
| `functions/src/index.ts` | trusted server code: মালিকের admin claim, COD order তৈরি ও stock যাচাই, order/booking notification। |
| `rentalListings` Firestore collection | বাসা/অফিস ভাড়া দেওয়া ও বাসা/অফিস খোঁজার বিজ্ঞাপন সংরক্ষণ করে; নিয়ম `firestore.rules`-এ। |
| `functions/package.json` | Cloud Functions-এর Node dependencies ও build command। |
| `functions/tsconfig.json` | TypeScript কীভাবে JavaScript-এ compile হবে তার নিয়ম। |
| `test/widget_test.dart` | Flutter automated UI/business-flow tests। নতুন feature যোগ করলে এখানে test বাড়াতে হবে। |

## ২. GitHub Actions — স্বয়ংক্রিয় কাজ

`.github/workflows/`-এর YAML ফাইলগুলো GitHub-কে build/test/deploy করতে নির্দেশ দেয়।

- `build-apk.yml`: Android APK এবং Play Store AAB build করে; signing secrets না থাকলে unsigned artifact তৈরি করে।
- `build-web.yml`: Flutter Web build করে ZIP artifact তৈরি করে।
- `deploy-pages.yml`: GitHub Pages-এ Web প্রকাশ করার workflow; `ENABLE_GITHUB_PAGES_DEPLOY=true` variable না থাকলে শুধু build করে, publish করে না।
- `deploy-firebase.yml`: Firestore Rules বিনা Blaze-এ deploy করতে পারে। Cloud Functions-এর জন্য owner-কে সচেতনভাবে `ENABLE_CLOUD_FUNCTIONS_DEPLOY=true` দিতে হবে; Storage-এর জন্য আলাদা `ENABLE_FIREBASE_STORAGE_DEPLOY=true` opt-in আছে।
- `deploy-hosting.yml`: Firebase Hosting-এ Web প্রকাশের workflow; Service Account এবং Web config secrets লাগে।
- `check-functions.yml`: Functions-এর TypeScript compile check করে; এটি production deploy নয়।

## ৩. সহায়ক script

- `tools/generate_brand_assets.py`: Elyramart-এর শুধু stylized E short mark দিয়ে Android/Web icon তৈরি করে।
- `tools/configure_web_pwa.py`: Web title, manifest ও PWA metadata সাজায়।
- `tools/configure_android_signing.py`: GitHub Secrets থেকে upload keystore নিয়ে Android release signing configure করে। Secret না থাকলে unsigned build হয়।

## ৪. Documentation — ভবিষ্যৎ technician-এর জন্য

- `README.md`: project overview ও সর্বশেষ যাচাইকৃত status।
- `docs/FILE_AUDIT_BN.md`: repository-র ফাইলগুলোর কাজ ও অবস্থা।
- `docs/DEVELOPER_HANDOFF_BN.md`: app architecture, data model ও technician handoff।
- `docs/FIREBASE_SETUP_BN.md`: Firebase configuration ও secret setup।
- `docs/OWNER_ACTIONS_BN.md`: মালিককে নিজে যেসব নিরাপদ account-side কাজ করতে হবে।
- `docs/PROJECT_STATUS_BN.md`: বর্তমানে কী সফল, কী বাকি।
- `docs/LAUNCH_CHECKLIST_BN.md`: Play Store ও public launch checklist।
- `docs/PRODUCTION_READINESS.md`: production-এ দেওয়ার আগে কী কী পরীক্ষা দরকার।
- `docs/PRIVACY_POLICY_DRAFT_BN.md` এবং `docs/TERMS_DRAFT_BN.md`: যাচাই ও চূড়ান্ত করার জন্য বাংলা খসড়া; আইনগত পরামর্শের বিকল্প নয়।
- `docs/SERVICE_MARKETPLACE.md`: marketplace ও home-service scope।

## ৫. ১৪ নভেম্বর ২০২৬-এ যাচাইকৃত অবস্থা

- Android APK/AAB build সফল: [GitHub Actions run](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43567716158)। APK ২৬.৭ MB; AAB ৫৬.২ MB। Signing secrets না থাকায় AAB unsigned।
- Web build সফল: [GitHub Actions run](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43567716156)।
- Firestore Rules deploy সফল: [GitHub Actions run](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43570891759)।
- Cloud Functions ও Storage deploy ইচ্ছাকৃতভাবে বন্ধ—Blaze billing অনুমোদন করা হয়নি।
- GitHub Pages build হয়েছে, কিন্তু publish ধাপ skipped; তাই এখনো public website URL নিশ্চিত নয়।
- Checkout বর্তমানে Cash on Delivery (COD)। bKash/Nagad/card gateway এখনো নেই।
- Rider self-service app, live GPS, proof of delivery ও settlement এখনো নেই।
- Real-device end-to-end QA এবং Play Console release এখনো সম্পন্ন নয়।

## ৬. মালিককে পরে যা করতে হবে

1. আগে APK নিজের Android ফোনে install করে UI ও basic flow পরীক্ষা।
2. Firebase Console-এ Authentication/Firestore প্রস্তুত এবং owner email verify করা।
3. Cloud Functions/Storage দরকার হলে Blaze billing-এর সম্ভাব্য খরচ বুঝে নিজের সিদ্ধান্তে চালু করা। কোনো private key ChatGPT বা public repo-তে দেবেন না।
4. Public website চাইলে GitHub Pages অথবা Firebase Hosting-এর owner-side settings/secrets configure করা।
5. Play Store-এর জন্য Android upload keystore তৈরি করে নিরাপদ offline backup রাখা; চারটি signing secret configure করে signed AAB rebuild করা।
6. Play Console account, privacy policy/terms, Data Safety, testing ও Google review সম্পন্ন করা।

## ৭. Technician-কে কাজ দেওয়ার সময়

Technician-কে এই পুরো repository ZIP/clone এবং `docs/` folder দিন। বলবেন:

- আগে README, PROJECT_STATUS, FILE_AUDIT ও DEVELOPER_HANDOFF পড়তে।
- Flutter source-কে মূল source হিসেবে রাখতে; generated build folder edit না করতে।
- Firebase Emulator দিয়ে Firestore/Storage rules test করতে।
- Admin privilege client থেকে দেওয়া যাবে না; trusted Cloud Function দিয়েই দিতে হবে।
- Order total, price, stock, commission server-এ validate করতে হবে।
- Payment gateway যোগ করলে merchant approval ও server-side verification করতে হবে।
- কোনো secret repository, source file, issue বা chat-এ commit করা যাবে না।
- প্রতিটি পরিবর্তনের পর Android/Web build, automated tests ও real-device QA করতে হবে।

**সতর্কতা:** Build সফল হওয়া মানেই অ্যাপ production-ready বা Play Store-এ প্রকাশিত—এমন নয়। Live launch-এর আগে checklist-এর সব release gate বাস্তবে যাচাই করতে হবে।
