# Elyramart backend setup (বাংলা)

এই repository-তে Flutter Android client-এর প্রাথমিক UI আছে। Firebase project credentials এখনো যোগ করা হয়নি, তাই login, cloud order, seller approval, technician assignment এবং live payment এখনো চালু নয়।

## Firebase project প্রস্তুত
1. Firebase Console-এ নতুন project তৈরি করুন: https://console.firebase.google.com/
2. Android app register করুন package name: `com.elyramartbd.elyramart`
3. Authentication-এ Phone এবং Email/Password provider চালু করুন।
4. Firestore Database তৈরি করুন (production mode)।
5. Storage চালু করুন।
6. Firebase CLI দিয়ে repository root-এ:
   `firebase init firestore storage`
7. এই repository-র `firestore.rules` এবং `storage.rules` deploy করুন:
   `firebase deploy --only firestore:rules,storage`
8. FlutterFire CLI দিয়ে `flutterfire configure` চালিয়ে generated `lib/firebase_options.dart` তৈরি করতে হবে। এই generated file project-specific; কখনো অন্যের config ব্যবহার করবেন না।

## নিরাপত্তা ও অনুমোদন নিয়ম

- নতুন অ্যাকাউন্ট নিজে থেকে শুধু `customer` role পাবে। অ্যাপ থেকে নিজেকে seller, technician বা admin বানানো যাবে না।
- সেলার আবেদন `sellerApplications`-এ pending হিসেবে জমা হবে। যাচাই শেষে বিশ্বস্ত Admin SDK/server থেকে সংশ্লিষ্ট `users/{uid}` ডকুমেন্টে `sellerApproved: true` সেট করতে হবে।
- অনুমোদিত সেলারই `products`-এ pending পণ্য তৈরি/সম্পাদনা এবং `products/{sellerId}/...` Storage path-এ ছবি আপলোড করতে পারবে।
- পণ্যের public status `active` কেবল admin/server অনুমোদনের পর হবে। Admin claim কখনো Flutter client থেকে সেট করা যাবে না।
- Firestore/Storage rules পরিবর্তনের পর Emulator-এ customer, pending seller, approved seller ও admin—এই চারটি role দিয়ে read/write পরীক্ষা করে তারপর deploy করুন।

## প্রথম Owner Admin claim (বিশ্বস্ত Cloud Function)

এই repository-তে `functions/src/index.ts`-এ `claimOwnerAdmin` callable function যোগ করা হয়েছে। এটি কেবল Firebase Authentication-এ লগইন করা এবং email-verified অ্যাকাউন্টকে অনুমতি দেবে, যার ইমেইল Firebase Functions parameter `ELYRAMART_OWNER_EMAIL`-এর সঙ্গে হুবহু মেলে। Flutter client নিজে admin claim লিখতে পারবে না।

প্রস্তুতির ধাপ:
1. Firebase Console → Authentication → Sign-in method থেকে Email/Password চালু করুন।
2. মালিকের ইমেইল `elyramartbd@gmail.com` দিয়ে অ্যাকাউন্ট তৈরি করে verification email নিশ্চিত করুন।
3. স্থানীয় নিরাপদ কম্পিউটারে Firebase CLI দিয়ে project select করুন: `firebase use --add`।
4. Functions parameter সেট করুন: `firebase functions:params:set ELYRAMART_OWNER_EMAIL` এবং prompt-এ `elyramartbd@gmail.com` দিন।
5. `cd functions && npm install && npm run build && cd ..`
6. `firebase deploy --only functions,firestore:rules,storage`
7. অ্যাপ/পরবর্তী Auth UI থেকে লগইন করা মালিক `claimOwnerAdmin` function call করবেন। সফল হলে sign-out/sign-in বা ID token refresh করে নতুন admin claim নিতে হবে।

নিরাপত্তা:
- Google/Firebase password, OTP, service-account JSON বা private key কাউকে দেবেন না এবং GitHub-এ commit করবেন না।
- মালিকের ইমেইল inbox-এর নিয়ন্ত্রণ ও email verification আবশ্যক। ওই ইমেইলের অ্যাক্সেস হারালে admin claim পুনরুদ্ধারে project owner-এর trusted server access লাগবে।
- Function deploy না হওয়া পর্যন্ত admin claim তৈরি হবে না। এই commit একা live login চালু করে না।
- App Check enforcement production launch-এর আগে configure ও enable করতে হবে; এখন callable function-এ App Check enforcement বন্ধ রাখা হয়েছে যাতে client integration না থাকা অবস্থায় owner bootstrap আটকে না যায়।

## Proposed collections
- `users/{uid}`: customer/seller/technician profile; admin role must be custom claim, never client-editable.
- `products/{productId}`: sellerId, title, category, price, stock, imageUrls, status.
- `orders/{orderId}`: customerId, sellerIds, items, deliveryAddress, totals, status.
- `serviceBookings/{bookingId}`: customerId, category, problem, photoUrls, address, preferredAt, technicianId, status.
- `sellerApplications/{id}` and `technicianApplications/{id}`: pending approval requests.

## Important launch requirements
- Admin custom claims must be set by a trusted server (Cloud Functions/Admin SDK), not by the mobile app.
- Never store bKash/Nagad PIN, card PIN, passwords, or payment secrets in Firestore.
- Payment gateway integration needs merchant credentials and server-side verification.
- Review Firestore rules against your final data model before launch. The current rules are a starting security baseline, not a substitute for a security review.
- Add real provider verification before showing any technician as verified.
- Test order, cancellation, refunds, delivery fees, commissions, and seller settlements before public launch.
