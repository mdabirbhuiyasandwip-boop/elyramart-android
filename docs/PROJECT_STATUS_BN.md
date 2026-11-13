# Elyramart প্রকল্পের বর্তমান অবস্থা

সর্বশেষ repository review: ১৪ নভেম্বর ২০২৬

## তৈরি আছে
- Flutter Android app source এবং GitHub Actions release workflow।
- Elyramart-এর E-only সবুজ brand mark।
- Customer home, category/catalog demo, cart ও checkout UI।
- Seller, technician, admin এবং owner settings-এর প্রাথমিক UI।
- Home-service request categories: electrician, plumber/sanitary, AC, fridge/washing machine, computer/laptop, mobile, IPS/generator এবং TV/appliance।
- Firebase Auth/Firestore/Storage/Functions SDK dependencies এবং Android Firebase config file।
- প্রাথমিক Firestore ও Storage security rules।
- যাচাইকৃত owner email দিয়ে admin claim করার callable Cloud Function source।
- বাংলা developer handoff ও Firebase setup documentation।

## Cloud সংযোগের বর্তমান সীমা
- Email/password Firebase Auth এবং customer profile sync-এর প্রাথমিক code আছে; Firebase Console provider/database configuration ও real-device test ছাড়া live-ready নয়।
- Verified customer-এর checkout/service booking Firestore-এ পাঠানোর code আছে; seller/technician applications ও admin approval flow-ও আংশিক যুক্ত। নতুন অর্ডারে বর্তমানে COD paymentMethod বাধ্যতামূলক করা হয়েছে।
- Cart এখনো local cache-এ থাকে।
- Product image upload, payment gateway, push notifications, delivery assignment/settlement এবং production-grade server-side order/payment validation এখনো সম্পূর্ণ নয়।
- Firebase Cloud Functions deploy এবং owner-admin claim সফলভাবে live হয়েছে—এমন প্রমাণ এখনো নেই।
- Web Firebase app config/hosting setup অসম্পূর্ণ; iOS-এর জন্য Apple signing প্রয়োজন।

## বর্তমান Android build
GitHub Actions workflow-তে Java runtime Java 21 করা হয়েছে। সর্বশেষ run:
https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43489796616

শেষবার যাচাইয়ের সময় Java setup, Flutter setup, Android project generation, Firebase config, dependency resolution, Dart analysis এবং widget tests সফল ছিল। Release APK build ধাপে run চলমান ছিল; APK/AAB artifact upload সম্পন্ন হয়েছে বলে এখনো নিশ্চিত করা হয়নি। পুরোনো সফল build-কে নতুন commit-এর build success হিসেবে ধরা যাবে না।

## Play Store release-এর আগে বাধ্যতামূলক
1. APK এবং AAB build সফল করে artifacts যাচাই।
2. GitHub Secret FIREBASE_SERVICE_ACCOUNT_JSON-এ Firebase project `elyramart`-এর Google Cloud service-account key JSON দিতে হবে; বর্তমান Secret-এ প্রয়োজনীয় `type`, `project_id`, `private_key`, `client_email`, `token_uri` নেই। এরপর Firebase Auth, Firestore, Storage ও Functions configure/deploy এবং security rules test।
3. Cloud order/catalog/booking flows এবং server-side price/payment verification সম্পূর্ণ।
4. Payment provider merchant approval ও server integration।
5. Product image upload, FCM notifications, delivery assignment এবং operational settlement।
6. Privacy policy, terms, refund/cancellation policy, support contact এবং Play Console Data safety/App content declarations।
7. বাস্তব Android device QA, release signing, Play Console internal testing এবং policy review।

## মালিকের নিরাপত্তা
Firebase project মালিকের Google account-এর অধীনে রাখুন। Google password, OTP, service-account private key বা payment secret কারও সঙ্গে শেয়ার করবেন না। Cloud Functions deploy-এ billing plan লাগতে পারে; মালিকের অনুমতি ছাড়া কোনো paid billing enable করা যাবে না।

## ভবিষ্যৎ developer-এর নির্দেশনা
Flutter codebase-কে source of truth ধরুন। Business logic UI থেকে আলাদা করে feature/repository structure-এ ভাগ করুন, tests যোগ করুন, money calculation trusted server-এ রাখুন এবং demo/local data-কে production data হিসেবে উপস্থাপন করবেন না।
