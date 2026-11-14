# Elyramart — Developer Handoff (বাংলা)

## লক্ষ্য
Elyramart হবে একটি cross-platform marketplace ও home-service platform। একই Flutter codebase থেকে Android, iOS এবং Web build হবে। ব্যবহারকারী একই account দিয়ে একাধিক device-এ sign in করে নিজের profile, cart/order এবং service booking cloud থেকে দেখতে পারবেন।

## বর্তমান অবস্থা
- Flutter source: `lib/main.dart`
- Android release build workflow: `.github/workflows/build-apk.yml`
- Android Firebase client config (`google-services.json`) repository-তে আছে; APK workflow সেটি Android build-এ বসায়।
- Customer Email/Password authentication UI ও প্রাথমিক Firestore profile sync যুক্ত আছে; Firebase Console services enable/deploy ও real-device test ছাড়া live-ready বলা যাবে না।
- Customer checkout ও service booking: signed-in, email-verified customer হলে Firestore-এ যায়; লগইন ছাড়া demo তথ্য শুধু ফোনে থাকে।
- Seller/technician application Firestore-এ pending হিসেবে জমা হয়; Owner Admin panel থেকে approval করা যায়।
- Approved seller পণ্য pending হিসেবে জমা দিতে পারে; Owner Admin প্রকাশ করলে customer catalogue-এ আসে।
- Seller নিজের পণ্য ও তার সঙ্গে যুক্ত অর্ডার দেখতে পারে; Admin technician approval ও booking assignment করতে পারে।
- Customer নিজের cloud order ও booking history দেখতে পারে; cart seller ownership সহ local cache-এ থাকে।
- Rental marketplace: verified user বাসা/অফিস ভাড়া দিতে অথবা বাসা/অফিস খুঁজতে active listing post করতে পারে; সবাই active listing browse করতে পারে। Data collection `rentalListings`; security rule `firestore.rules`-এ।
- Web build তৈরি হয়। Web Firebase initialization code যোগ হয়েছে; Web App config GitHub Actions secrets-এ না থাকলে demo mode, থাকলে Firebase online login/data চালু হতে পারে। Hosting enablement ও live test এখনও বাকি।
- COD order callable, FCM notification triggers, product image upload এবং admin-এর manual rider assignment-এর source code আছে; Firebase deploy ও real-device tests ছাড়া এগুলো live বলে গণ্য নয়. bKash/Nagad/card gateway, rider self-service/live GPS/settlement এবং full production verification এখনও বাকি.
- বর্তমান APK-কে production marketplace হিসেবে প্রকাশ করা যাবে না।

## Platform strategy
1. **Android:** Flutter Android build; internal testing APK/AAB, পরে Play Console release।
2. **iPhone/iPad:** একই Flutter app-এর iOS target; Xcode/macOS build runner এবং Apple Developer account/App Store signing প্রয়োজন। APK iPhone-এ install হয় না।
3. **Laptop/mobile browser:** Flutter Web build; responsive layout, HTTPS hosting এবং custom domain প্রয়োজন। Browser থেকে installable PWA সুবিধা পরে যোগ করা যেতে পারে।
4. **Desktop app:** Windows/macOS/Linux native build আলাদা release target; প্রথম public version-এ responsive web-ই laptop support দেবে।

## Cloud backend architecture
Firebase ব্যবহার করলে:
- Firebase Authentication: phone OTP এবং email/password sign-in; এক user-এর এক UID সব device-এ।
- Cloud Firestore: users, products, sellerApplications, orders, serviceBookings, technicianApplications, categories, settings।
- Firebase Storage: product, profile এবং service issue photos।
- Cloud Functions / trusted server: admin role claims, seller/technician approval, order totals/commission validation, payment verification, notifications।
- FCM: order status এবং technician assignment notification।

### Role and access
- customer: browse, cart, checkout, own orders, service booking।
- seller: application, admin approval, own products/stock, assigned orders এবং allowed status changes।
- technician: application, admin approval, skills/coverage, assigned bookings এবং allowed status changes।
- admin: secure server-granted admin claim; approve sellers/technicians, manage categories/products/orders/bookings।
- কোনো client app-কে নিজের role admin বানাতে দেওয়া যাবে না।

## Core data model (suggested)
- `users/{uid}`: name, phone, email, role, createdAt, updatedAt
- `sellerApplications/{id}`: userId, shopName, contact, address, status, reviewedAt
- `technicianApplications/{id}`: userId, skills, serviceAreas, documents, status, reviewedAt
- `products/{id}`: sellerId, title, categoryId, price, stock, imageUrls, status, updatedAt
- `orders/{id}`: customerId, sellerIds, items, address, subtotal, deliveryFee, commission, total, paymentStatus, status, createdAt
- `serviceBookings/{id}`: customerId, categoryId, description, photoUrls, address, preferredAt, technicianId, status, createdAt
- `rentalListings/{id}`: ownerId, ownerName, propertyType, listingType, title, rentAmount, location, phone, details, status, createdAt

All money values should use integer BDT poisha or validated integer BDT; never trust client-calculated totals. Recalculate prices, delivery fees, discounts and commissions on a trusted server.

## Developer workflow
- Keep business logic out of large UI widgets; split into feature folders (auth, catalog, cart, orders, seller, technician, admin, services).
- Use repositories/services for data access; separate local demo adapter from Firebase implementation.
- Add model validation and automated tests for phone normalization, order totals, role permissions and booking status transitions.
- Use environment-specific Firebase projects (development/staging/production); never commit private service account keys or payment secrets.
- Keep Firestore/Storage rules least-privilege and test them with Firebase Emulator before launch.
- Document every schema migration and operational setup step.

## Launch blockers
1. Verify the existing Firebase project and Android app config; register separate Web/iOS app configurations before enabling those platforms. Never share private admin/service-account keys in chat or commit them.
2. Enable and test Authentication, Firestore, Storage, Cloud Functions and FCM.
3. Implement cloud repositories and replace local-only order/product/booking flows.
4. Implement server-side payment gateway integration after merchant account approval; never collect bKash/Nagad PIN or store card secrets.
5. Add privacy policy, terms, seller agreement, technician verification, cancellation/refund policy and support contact.
6. Security review, emulator tests, real-device QA, backup/monitoring and staged release.
7. For iOS, configure Apple signing and App Store Connect; for web, configure HTTPS hosting/domain.

## Important note for future IT developer
Do not delete existing demo flows until their cloud equivalents pass tests. Keep Android, iOS and Web on the same supported Flutter codebase where possible. Any major schema or auth change must include migration notes and tests.
