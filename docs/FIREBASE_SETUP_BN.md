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
