# Elyramart production readiness

সর্বশেষ যাচাই: ১৪ নভেম্বর ২০২৬ (সর্বশেষ CI run: commit 5b7ada14)

এই নথিতে repository-তে থাকা code, CI build এবং live production deployment আলাদা করে দেখানো হয়েছে। Build success মানেই Firebase backend live, বাস্তব ফোনে QA সম্পন্ন, অথবা Play Store release-ready নয়।

## সর্বশেষ CI যাচাই

- Android APK/AAB: [run 43587496152](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43587496152) — success; Flutter source verification, dependency resolution, Dart analysis, widget tests, release APK build ও AAB build সব সফল; APK ও AAB artifacts আপলোড হয়েছে। Signing secrets না থাকলে artifact-কে Play Store signed bundle ধরে নেওয়া যাবে না।
- Web build: [run 43587496191](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43587496191) — success; web build artifact তৈরি।
- GitHub Pages: [run 43587496160](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43587496160) — source verification, analysis, widget tests ও web build success; publish/configure steps skipped। তাই public website URL এখনো verified নয়।
- Firebase backend: [run 43586826982](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43586826982) — service-account credential verification ও Firestore Rules deploy success; Cloud Functions এবং Storage deploy skipped।
- Firebase Hosting: [run 43587496147](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43587496147) — required Firebase web/deploy configuration যাচাই ধাপে failure; hosting deploy শুরু হয়নি।
- Source/documentation package: [run 43587496361](https://github.com/mdabirbhuiyasandwip-boop/elyramart-android/actions/runs/43587496361) — success।

## Repository-তে থাকা প্রধান code

- Flutter Android marketplace client; বাংলা/ইংরেজি UI ও short E brand mark।
- Customer email/password authentication এবং email verification flow।
- Seller ও technician application এবং owner/admin approval UI।
- Seller product submission/publication flow।
- Server-side COD order callable; stock validation ও Firestore transaction logic।
- Delivery fee setting; default ৳৮০।
- Product image upload ও FCM notification code।
- Firestore/Storage security rules, Android APK/AAB workflow, Web build/Pages workflow এবং Codemagic YAML।

উপরের feature code থাকা মানে production Firebase project-এ সেগুলো deployed বা বাস্তবে tested—এমন নয়।

## বিনামূল্যে/বর্তমান অনুমতিতে করা সম্ভব এমন পরবর্তী কাজ

1. Firebase Console-এ Email/Password Authentication ও Firestore চালু/যাচাই করা (এগুলো ব্যবহারকারীর project access ও console action চায়)।
2. GitHub Pages settings-এ Actions source enable করে Pages workflow publish পুনরায় চালানো।
3. Web Firebase config secrets পাওয়া গেলে Firebase Hosting build/deploy পুনরায় চালানো।
4. APK বাস্তব Android ফোনে ইনস্টল করে customer login, seller application, search, cart, checkout UI, language এবং admin visibility পরীক্ষা করা।
5. Seller product category, image upload ও product approval workflow বাস্তব account দিয়ে পরীক্ষা করা; Storage bucket প্রস্তুত না থাকলে upload live হবে না।
6. Multi-seller cart/order fulfillment, rider assignment এবং notification-এর end-to-end আচরণ যাচাই ও অসম্পূর্ণ অংশ implement করা।

## মালিকের অনুমতি/কনফিগারেশন ছাড়া চালু করা হবে না

1. Cloud Functions deployment: workflow-তে `ENABLE_CLOUD_FUNCTIONS_DEPLOY=true` দিলে Blaze billing ও প্রয়োজনীয় Google Cloud API লাগবে। মালিকের স্পষ্ট অনুমতি ছাড়া এটি enable করা হবে না। এর মধ্যে `claimOwnerAdmin` এবং server-side `placeOrder` callable live নয়—এ কারণে production owner claim ও online order placement এখনো নিশ্চিত নয়।
2. Firebase Storage deployment: bucket/plan setup ও `ENABLE_FIREBASE_STORAGE_DEPLOY=true` owner opt-in প্রয়োজন।
3. bKash/Nagad/card gateway বা অন্য paid service।
4. Android Play Store signing key/keystore তৈরি, upload signing secrets সেট করা এবং Play Store প্রকাশ।

## Live launch-এর জন্য এখনো প্রয়োজন

1. Firebase Console project `elyramart`-এ Email/Password Authentication, Firestore ও Storage প্রস্তুত/যাচাই।
2. Firestore Rules deploy সফল হয়েছে; তবে Rules deploy মানেই Cloud Functions/Storage deploy নয়।
3. Functions deploy না হওয়া পর্যন্ত Owner Admin custom claim ও server-side order callable ব্যবহারযোগ্য নয়।
4. Owner email `elyramartbd@gmail.com` দিয়ে verified account sign-in করে trusted server-side Owner Admin claim করতে হবে; claim function deploy হওয়ার পরই সম্ভব।
5. Repository Settings → Pages-এ GitHub Actions source enable করে Pages workflow পুনরায় চালাতে হবে; অথবা Firebase Hosting workflow-তে Service Account ও ছয়টি Web config secret যোগ করতে হবে।
6. Android release upload signing key ও password নিরাপদে তৈরি/সংরক্ষণ এবং CI secrets configure করতে হবে। বর্তমান AAB artifact-কে signed Play upload bundle ধরে নেওয়া যাবে না।
7. Real-device QA: customer, seller, technician, admin, order, stock, booking, image upload, notifications এবং security rules।
8. Privacy policy, terms, seller/technician verification, cancellation/refund/support information এবং Play Console declarations সম্পন্ন।
9. Play Console developer account, app-content/data-safety declarations, signed AAB upload, testing track এবং Google review।

## এখনও implement হয়নি / merchant বা product সিদ্ধান্ত প্রয়োজন

- bKash/Nagad/card gateway: বর্তমান checkout Cash on Delivery (COD)।
- Rider self-service app/login, live GPS tracking, proof of delivery এবং rider settlement।
- Production end-to-end QA এবং public website publishing।
- App Store/iOS release-এর জন্য আলাদা Apple signing ও App Store Connect setup।

## Security guardrails

- Service-account JSON, private key, upload keystore/password বা payment credentials কখনো chat, issue, log বা repository-তে commit করবেন না।
- Firebase service-account secret-এ Android `google-services.json` ব্যবহার করবেন না।
- Billing plan বা paid service চালু করার আগে মালিকের অনুমতি নিতে হবে।
- Payment PIN/OTP/card secrets কখনো অ্যাপে সংগ্রহ বা Firestore-এ সংরক্ষণ করবেন না।
- Order total, stock, commission ও payment verification trusted server-এ validate করতে হবে।
