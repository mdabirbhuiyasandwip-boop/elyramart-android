# Elyramart backend setup (বাংলা)

এই repository-তে Android Firebase client configuration (`google-services.json`) যোগ করা আছে। এটি client-side public configuration—এটি Firebase Console-এ Authentication, Firestore, Storage বা Functions নিজে থেকে চালু/deploy করে না।

## বর্তমান অ্যাপের Firebase সংযোগ

Android app startup-এ Firebase Core initialize হয়। `google-services.json` Android app-এর config হিসেবে repository-তে আছে; APK workflow build-এর সময় এটি `android/app/`-এ কপি করে Google Services Gradle plugin যোগ করে। Customer account screen-এ Email/Password registration, login, email verification এবং customer profile-এর প্রাথমিক Firestore sync যুক্ত হয়েছে। Owner Admin button `claimOwnerAdmin` callable function ব্যবহার করে। এগুলো চালু করতে নিচের Console ও deploy ধাপ সম্পন্ন করতে হবে।

## Firebase project প্রস্তুত
1. Firebase Console-এ আগে থেকে তৈরি `elyramart` project খুলুন: https://console.firebase.google.com/
2. Project Settings → Your apps-এ Android app-এর package name `com.elyramartbd.elyramart` নিশ্চিত করুন; config ফাইলে এই package-ই নিবন্ধিত আছে।
3. Authentication-এ Email/Password provider চালু করুন। (Phone OTP UI এখনো অ্যাপে implement করা হয়নি; পরে আলাদা করে যোগ করতে হবে।)
4. Firestore Database তৈরি করুন (production mode)।
5. Storage চালু করুন।
6. Firestore database ও Storage bucket-এর billing/plan requirements দেখে নিন; Cloud Functions deploy করতে Blaze plan এবং প্রয়োজনীয় Google Cloud APIs লাগতে পারে।
7. Repository Settings → Secrets and variables → Actions-এ `FIREBASE_SERVICE_ACCOUNT_JSON` নামে secret যোগ করুন। এতে Firebase project `elyramart`-এর deploy permission-সহ service-account JSON-এর সম্পূর্ণ contents রাখুন। JSON কখনো repository-তে commit করবেন না।
8. GitHub Actions → **Deploy Elyramart Firebase backend** → Run workflow চালান। এটি Firestore Rules, Storage Rules ও `claimOwnerAdmin` Cloud Function deploy করবে; মালিকের email parameter workflow-তে সেট করা আছে।
9. Android native build-এ `google-services.json` থেকে Firebase options নেওয়া হয়। Web build-এ Firebase চালু করতে Firebase Console → Project settings → Your apps → Web app থেকে Web App config নিন। GitHub repository Settings → Secrets and variables → Actions-এ নিচের secrets যোগ করুন:
   - `ELYRAMART_FIREBASE_WEB_API_KEY`
   - `ELYRAMART_FIREBASE_WEB_APP_ID`
   - `ELYRAMART_FIREBASE_MESSAGING_SENDER_ID`
   - `ELYRAMART_FIREBASE_PROJECT_ID` (মান হবে `elyramart`)
   - `ELYRAMART_FIREBASE_AUTH_DOMAIN` (যেমন Firebase Console-এ দেখানো domain)
   - `ELYRAMART_FIREBASE_STORAGE_BUCKET` (Console-এর সঠিক bucket)
   এরপর Web build/Pages workflow এগুলো Dart compile-time config হিসেবে ব্যবহার করবে। Web config না থাকলে Web app demo mode-এ খুলবে; Firebase login/cloud data চালু হবে না। iOS-এর জন্য এখনও FlutterFire configure এবং Apple build/signing আলাদা করে করতে হবে।

## নিরাপত্তা ও অনুমোদন নিয়ম

- নতুন অ্যাকাউন্ট নিজে থেকে শুধু `customer` role পাবে। অ্যাপ থেকে নিজেকে seller, technician বা admin বানানো যাবে না।
- লগইন করা ও email-verified সেলার আবেদন `sellerApplications`-এ pending হিসেবে জমা হয়। Owner Admin প্যানেল থেকে যাচাই করে অনুমোদন দিলে সংশ্লিষ্ট `users/{uid}` ডকুমেন্টে `sellerApproved: true` সেট হয়।
- অনুমোদিত সেলারই `products`-এ pending পণ্য তৈরি/সম্পাদনা এবং `products/{sellerId}/...` Storage path-এ ছবি আপলোড করতে পারবে।
- পণ্যের public status `active` কেবল Owner Admin প্যানেল থেকে অনুমোদনের পর হবে। Admin claim কখনো Flutter client থেকে সেট করা যাবে না।
- Firestore/Storage rules পরিবর্তনের পর Emulator-এ customer, pending seller, approved seller ও admin—এই চারটি role দিয়ে read/write পরীক্ষা করে তারপর deploy করুন।

## প্রথম Owner Admin claim (বিশ্বস্ত Cloud Function)

এই repository-তে `functions/src/index.ts`-এ `claimOwnerAdmin` callable function যোগ করা হয়েছে, তবে এটি Firebase project-এ deploy না করা পর্যন্ত কাজ করবে না। এটি কেবল Firebase Authentication-এ লগইন করা এবং email-verified অ্যাকাউন্টকে অনুমতি দেবে, যার ইমেইল Firebase Functions parameter `ELYRAMART_OWNER_EMAIL`-এর সঙ্গে হুবহু মেলে। Flutter client নিজে admin claim লিখতে পারবে না।

প্রস্তুতির ধাপ:
1. Firebase Console → Authentication → Sign-in method থেকে Email/Password চালু করুন।
2. মালিকের ইমেইল `elyramartbd@gmail.com` দিয়ে অ্যাকাউন্ট তৈরি করে verification email নিশ্চিত করুন।
3. স্থানীয় নিরাপদ কম্পিউটারে Firebase CLI দিয়ে project select করুন: `firebase use --add`।
4. GitHub Actions → **Deploy Elyramart Firebase backend** → Run workflow চালালে workflow `ELYRAMART_OWNER_EMAIL=elyramartbd@gmail.com` parameter তৈরি করে এবং Functions/Rules deploy করে।
7. অ্যাপ/পরবর্তী Auth UI থেকে লগইন করা মালিক `claimOwnerAdmin` function call করবেন। সফল হলে sign-out/sign-in বা ID token refresh করে নতুন admin claim নিতে হবে।

নিরাপত্তা:
- Google/Firebase password, OTP, service-account JSON বা private key কাউকে দেবেন না এবং GitHub-এ commit করবেন না। `google-services.json`-এর client API key অ্যাপের public configuration; Firebase/Google Cloud Console-এ Android app restriction ও প্রয়োজনীয় API restriction দিন।
- মালিকের ইমেইল inbox-এর নিয়ন্ত্রণ ও email verification আবশ্যক। ওই ইমেইলের অ্যাক্সেস হারালে admin claim পুনরুদ্ধারে project owner-এর trusted server access লাগবে।
- Function deploy না হওয়া পর্যন্ত admin claim তৈরি হবে না। এই commit একা live login চালু করে না।
- App Check enforcement production launch-এর আগে configure ও enable করতে হবে; এখন callable function-এ App Check enforcement বন্ধ রাখা হয়েছে যাতে client integration না থাকা অবস্থায় owner bootstrap আটকে না যায়।

## Proposed collections
- `users/{uid}`: customer/seller/technician profile; admin role must be custom claim, never client-editable.
- `products/{productId}`: sellerId, title, category, price, stock, imageUrls, status.
- `orders/{orderId}`: customerId, sellerIds, items, deliveryAddress, totals, status.
- `serviceBookings/{bookingId}`: customerId, category, problem, photoUrls, address, preferredAt, technicianId, status.
- `sellerApplications/{id}` and `technicianApplications/{id}`: pending approval requests; Owner Admin approval updates the corresponding user approval flag.

## Important launch requirements
- Admin custom claims must be set by a trusted server (Cloud Functions/Admin SDK), not by the mobile app.
- Never store bKash/Nagad PIN, card PIN, passwords, or payment secrets in Firestore.
- Payment gateway integration needs merchant credentials and server-side verification.
- Review Firestore rules against your final data model before launch. The current rules are a starting security baseline, not a substitute for a security review.
- Add real provider verification before showing any technician as verified.
- Test order, cancellation, refunds, delivery fees, commissions, and seller settlements before public launch.
