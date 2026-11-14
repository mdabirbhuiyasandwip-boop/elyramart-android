# Elyramart প্রকল্পের বর্তমান অবস্থা

সর্বশেষ যাচাই: ১৪ নভেম্বর ২০২৬  
Repository: https://github.com/mdabirbhuiyasandwip-boop/elyramart-android

## যাচাইকৃত build ফলাফল

### Android
- GitHub Actions run: https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43499666854
- ফলাফল: **completed / success**
- একই commit: `6f9b1da19314c388258f49b97d8a55c112f8cc2f`
- Artifact: `Elyramart-APK-release` (প্রায় 26.7 MB)
- Artifact: `Elyramart-Play-Store-AAB` (প্রায় 56.1 MB)
- Artifact দুটির মেয়াদ ২৭ নভেম্বর ২০২৬ পর্যন্ত। Build success মানে বাস্তব ফোনে সম্পূর্ণ QA বা Play Store প্রকাশ সম্পন্ন নয়।

### Web
- পূর্বের Web build run: https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43499666897 — **success**; `Elyramart-Web-release` artifact তৈরি হয়েছে (প্রায় 14.3 MB)।
- নতুন কোডে Web Firebase initialization যোগ হয়েছে; Firebase Console থেকে Web App config নিয়ে GitHub Actions secrets দিলে Web login/cloud data চালু হবে। Secrets না থাকলে Web demo mode-এ চলবে।
- নতুন Web build run: https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43565190109 — বর্তমানে running/pending; শেষ ফলাফল Actions-এ যাচাই করতে হবে.
- GitHub Pages deploy run: https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43499666844
- ফলাফল: **failure**। Flutter Web build ও tests সফল; `Configure GitHub Pages` ধাপে GitHub integration-এর Pages site তৈরি করার অনুমতি না থাকায় deploy আটকে গেছে। Repository owner-কে Settings → Pages-এ গিয়ে Build and deployment source হিসেবে **GitHub Actions** নির্বাচন/enable করতে হবে। তারপর workflow আবার চালাতে হবে।

### সর্বশেষ source পরিবর্তন
- Web app এখন `FirebaseOptions` দিয়ে platform-aware initialization সমর্থন করে; Android আগের মতো `google-services.json` ব্যবহার করে। Web-এর জন্য ৬টি `ELYRAMART_FIREBASE_*` GitHub Actions secret প্রয়োজন; তালিকা `docs/FIREBASE_SETUP_BN.md`-এ আছে।
- Duplicate `google-services (3).json` এবং repository-র ভেতরে থাকা পুরোনো nested APK workflow সরানো হয়েছে।
- Android build run: https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43565196528 — চলমান।

### Firebase backend
- Functions TypeScript compile/check run: https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43499739123 — **success**।
- Firebase deploy run: https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43499739022 — **failure**।
- ব্যর্থতার সুনির্দিষ্ট কারণ: GitHub Actions secret `FIREBASE_SERVICE_ACCOUNT_JSON`-এ Google Cloud Service Account key JSON নেই বা সেটি ভুল ফরম্যাটে আছে। Validation-এ `type`, `project_id`, `private_key`, `client_email`, `token_uri` পাওয়া যায়নি।
- Android-এর `google-services.json` এই deploy secret-এর বিকল্প নয়। Secret-এ Firebase project `elyramart`-এর service-account JSON সম্পূর্ণ contents নিরাপদে রাখতে হবে। কোনো private key chat বা repository-তে দেওয়া যাবে না।
- Firebase deploy-এর জন্য billing plan/Google Cloud API লাগতে পারে; মালিকের স্পষ্ট অনুমতি ছাড়া কোনো paid billing চালু করা যাবে না।

## App-এ থাকা প্রধান code/workflow

- Flutter app: customer, seller, technician ও owner/admin UI; বাংলা/ইংরেজি; E-only brand mark।
- Firebase email/password authentication ও email verification flow; online কাজের জন্য verified customer check।
- Seller/technician application, admin approval, seller product submission/publication flow-এর code।
- Callable `placeOrder` server-side order creation, stock validation/transaction এবং Cash on Delivery flow-এর code।
- Delivery fee Firestore settings থেকে পড়ার ব্যবস্থা; default ৳80।
- Product image upload ও FCM token/notification trigger-এর code আছে; backend deploy ও live-device test না হওয়া পর্যন্ত এগুলো live বলা যাবে না।
- Android APK ও Play Store AAB build workflow; Web build ও GitHub Pages deploy workflow।
- Developer handoff, Firebase setup ও production-readiness documents repository-তে আছে।

## এখনো সম্পন্ন/লাইভ প্রমাণিত নয়

1. Firebase Rules, Storage ও Cloud Functions production project-এ deploy এবং real account দিয়ে test।
2. Public website hosting (Web artifact তৈরি হয়েছে, কিন্তু Pages deploy সফল নয়)।
3. Real-device QA: customer, seller, technician, admin, order, booking, upload, notifications।
4. bKash/Nagad/card payment gateway: বর্তমানে checkout-এ COD-ই ব্যবহৃত হয়; gateway integration নেই।
5. Rider self-service login/app, live GPS tracking, proof-of-delivery ও rider settlement।
6. Play Store production signing, Play Console submission ও approval।
7. Privacy policy, terms, cancellation/refund policy, support এবং app-store compliance review।

## ভবিষ্যৎ developer-এর জন্য

- Flutter source code-কে মূল source of truth ধরুন; বর্তমান repository-র সম্পূর্ণ source, workflow ও docs পরীক্ষা করে কাজ শুরু করুন।
- Demo/local data-কে production cloud data হিসেবে দেখাবেন না।
- Order total, stock, payment verification ও commission trusted server-এ validate করুন।
- Firestore/Storage rules Emulator-এ role অনুযায়ী test করে deploy করুন।
- Firebase service-account key, upload keystore/password এবং payment secrets কখনো source code বা public repository-তে commit করবেন না।
- Build success, backend deployment, real-device QA এবং Play Store publication—এগুলো আলাদা milestone হিসেবে রিপোর্ট করুন।
