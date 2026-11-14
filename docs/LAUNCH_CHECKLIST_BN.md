# Elyramart launch checklist (বাংলা)

এই checklist-টি source code ও release-এর কাজকে আলাদা milestone-এ ভাগ করে। কোনো checkbox পূরণ হবে কেবল বাস্তব প্রমাণ/পরীক্ষা থাকলে।

## A. Repository ও CI

- [x] Android APK build সফল; artifact তৈরি।
- [x] Android AAB build সফল; artifact তৈরি।
- [x] Flutter Web build সফল; artifact তৈরি।
- [x] Firebase Functions TypeScript compile সফল।
- [ ] নতুন documentation commit-এর পর Android build আবার সফল হয়েছে—যাচাই করতে হবে।
- [ ] নতুন documentation commit-এর পর Web build আবার সফল হয়েছে—যাচাই করতে হবে।

## B. Firebase owner-side setup

- [ ] Project `elyramart`-এ Email/Password Authentication enable।
- [ ] Firestore Database তৈরি/যাচাই।
- [ ] Firebase Storage bucket তৈরি/যাচাই।
- [ ] Dedicated Google Cloud service account key JSON তৈরি।
- [ ] GitHub Actions secret `FIREBASE_SERVICE_ACCOUNT_JSON`-এ সম্পূর্ণ service-account JSON সংরক্ষণ।
- [ ] Deploy workflow-তে Firestore rules, Storage rules ও Functions সফলভাবে deploy।
- [ ] প্রয়োজনীয় billing/API enablement owner অনুমোদনসহ সম্পন্ন।
- [ ] Owner account `elyramartbd@gmail.com` email verify করে Owner Admin claim সফল।

**গুরুত্বপূর্ণ:** Android `google-services.json` deploy secret নয়। Service-account JSON, private key বা password chat/repository-তে দেবেন না।

## C. Website

- [ ] Firebase Hosting deploy workflow-তে সঠিক Service Account ও ৬টি Web config secret যোগ করে public hosting deploy সফল।
- [ ] বিকল্প হিসেবে GitHub repository Settings → Pages → Build and deployment → Source = GitHub Actions।
- [ ] Pages workflow সফল।
- [ ] Public URL HTTPS-এ খোলে।
- [ ] Web Firebase configuration যোগ/যাচাই; login ও cloud data বাস্তবে test।
- [ ] Mobile screen ও desktop browser layout test।

## D. Real-device QA

- [ ] Customer registration/login/email verification।
- [ ] Product list, search/category, product details।
- [ ] Cart, checkout, COD order creation।
- [ ] Server-side price/stock validation; duplicate/invalid order reject।
- [ ] Default delivery fee ৳৮০ এবং admin setting override।
- [ ] Customer নিজের order history/status দেখতে পারে।
- [ ] Seller application, admin approval, product submission ও product publication।
- [ ] Seller কেবল নিজের product/order দেখতে ও অনুমোদিত status update করতে পারে।
- [ ] Technician application, admin approval, booking ও assignment।
- [ ] Product/service image upload permission।
- [ ] FCM notification delivery।
- [ ] Firestore/Storage rules customer, pending seller, approved seller, technician ও admin role দিয়ে test।
- [ ] Offline/error/loading states এবং app restart/session persistence।

## E. Payments ও delivery

- [x] বর্তমান checkout method: Cash on Delivery (COD)।
- [ ] bKash/Nagad/card gateway: merchant account ও server-side integration না হওয়া পর্যন্ত unavailable হিসেবে দেখাতে হবে।
- [ ] Rider self-service login/app, GPS tracking, proof of delivery ও settlement—পৃথক development scope।

## F. Android/Play Store release

- [ ] Android upload keystore তৈরি এবং নিরাপদ backup।
- [ ] CI-তে protected signing secrets configure; কোনো key repository-তে নয়।
- [ ] Signed release AAB তৈরি ও signature verify।
- [ ] App icon, package ID, version, privacy policy URL final।
- [ ] Play Console account ও identity verification।
- [ ] Data safety, app access, content rating, target audience ও permissions declaration।
- [ ] Internal testing track-এ signed AAB upload ও install test।
- [ ] Play review ও production approval।

## Release gate

Public launch কেবল তখনই হবে যখন Firebase deploy, public hosting, security review, real-device QA, signed AAB এবং Play Console review সম্পন্ন। Build artifact তৈরি হওয়াকে public launch বলা যাবে না।
