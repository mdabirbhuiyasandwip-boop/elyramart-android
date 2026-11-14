# Elyramart launch checklist (বাংলা)

এই checklist-টি source code ও release-এর কাজকে আলাদা milestone-এ ভাগ করে। কোনো checkbox পূরণ হবে কেবল বাস্তব প্রমাণ/পরীক্ষা থাকলে।

## A. Repository ও CI

- [x] Android APK build সফল; artifact তৈরি।
- [x] Android AAB build সফল; artifact তৈরি।
- [x] Flutter Web build সফল; artifact তৈরি।
- [x] Firebase Functions TypeScript compile সফল।
- [ ] সর্বশেষ source/documentation commit-এর পর Android build পুনরায় চালিয়ে যাচাই।
- [ ] সর্বশেষ source/documentation commit-এর পর Web build পুনরায় চালিয়ে যাচাই।

## B. Firebase owner-side setup

- [ ] Project `elyramart`-এ Email/Password Authentication enable।
- [ ] Firestore Database তৈরি/যাচাই।
- [ ] Firebase Storage bucket তৈরি/যাচাই।
- [x] Dedicated Google Cloud service account key JSON তৈরি/যাচাই (GitHub secret-এ আছে)।
- [x] GitHub Actions secret `FIREBASE_SERVICE_ACCOUNT_JSON` যাচাই হয়েছে।
- [x] Firestore Rules deploy সফল (run 43570891759)।
- [ ] Cloud Functions deploy (Firebase billing/plan requirement ও owner approval প্রয়োজন; live deployment এখনো যাচাই হয়নি)।
- [ ] Storage rules deploy (bucket setup ও owner approval প্রয়োজন)।
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
- [ ] Gateway sandbox integration: server-side session/payment create, IPN/callback validation, amount/currency/order matching, idempotency ও refund tests।
- [ ] Production merchant approval, settlement verification ও live payment test (শুধু মালিকের অনুমোদনের পর)।
- [ ] Payment paid status কেবল gateway server validation থেকে update হবে; client redirect দিয়ে নয়।
- [ ] Rider self-service login/app, GPS tracking, proof of delivery ও settlement—পৃথক development scope।

## E.1 Travel, transport ও accommodation

- [ ] Bus operator/aggregator contract ও production API; live route/seat inventory, seat hold, PNR/e-ticket, cancellation/refund।
- [ ] Bangladesh Railway অনুমোদিত ticketing channel/API ও written permission; live berth/seat availability এবং genuine ticket issuance।
- [ ] Launch/ferry operator API, cabin/seat inventory, ticket confirmation ও refund।
- [ ] Hotel supplier API/contract, live room/rate inventory, taxes, cancellation policy ও booking confirmation।
- [ ] Toll operator authorization, secure payment, provider transaction confirmation ও receipt।
- [ ] Unified My Trips / My Bookings: ticket/reference, status, cancellation/refund, support ও notification।
- [ ] Provider API integration না হওয়া পর্যন্ত কোনো seat map, fare, schedule, ticket বা booking confirmed বলে দেখানো যাবে না।

## F. Android/Play Store release

- [ ] Android upload keystore তৈরি এবং নিরাপদ backup।
- [ ] CI-তে `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD` protected secrets configure; কোনো key repository-তে নয়।
- [ ] একই upload keystore-এর নিরাপদ offline backup রাখা; keystore হারালে update প্রকাশে সমস্যা হতে পারে।
- [ ] Signed release AAB তৈরি ও signature verify।
- [ ] App icon, package ID, version, privacy policy URL final।
- [ ] Play Console account ও identity verification।
- [ ] Data safety, app access, content rating, target audience ও permissions declaration।
- [ ] Internal testing track-এ signed AAB upload ও install test।
- [ ] Play review ও production approval।

## Release gate

Public launch কেবল তখনই হবে যখন Firebase deploy, public hosting, security review, real-device QA, signed AAB এবং Play Console review সম্পন্ন। Build artifact তৈরি হওয়াকে public launch বলা যাবে না।


## ১৪ নভেম্বর ২০২৬ — সর্বশেষ release preflight ফলাফল

- [x] Android CI job সফল (run 43581917105)।
- [x] Flutter analyzer-এ Error/Warning নেই; ৪৯টি Info-level lint/style suggestion রয়ে গেছে।
- [x] ৬টি widget test pass।
- [x] Release APK ও AAB build এবং artifact upload সফল।
- [x] APK/AAB archive integrity যাচাই।
- [ ] APK বাস্তব Android ফোনে install/launch এবং smoke test।
- [ ] Firebase login/email verification ও cloud-backed customer flow পরীক্ষা।
- [ ] Cloud Functions deploy; COD order ও Owner Admin claim live করা।
- [ ] Firebase Storage bucket/rules deploy; seller image upload পরীক্ষা।
- [ ] Owner Admin custom claim দিয়ে আলাদা admin login পরীক্ষা।
- [ ] Owner upload keystore দিয়ে signed AAB তৈরি ও signature verify।
- [ ] Privacy/terms, hosting এবং Play Console release requirements সম্পন্ন।

**Release সিদ্ধান্ত:** বর্তমান APK কেবল install-test candidate। উপরের বাস্তব ডিভাইস, backend, security এবং signing gate শেষ না হওয়া পর্যন্ত production launch বা Play Store submission করা যাবে না।


## ১৫ নভেম্বর ২০২৬ — all-in-one booking ও payment scope update

- [x] Bus, train, launch/ferry, toll, hotel এবং rental booking-এর production requirements `docs/PRODUCT_REQUIREMENTS.md`-এ যোগ।
- [x] Provider-authorized API, verified payment callback, ticket/PNR, cancellation/refund এবং unified My Trips requirements যোগ।
- [x] Payment release gates ও Play Store release requirements নথিভুক্ত।
- [ ] bKash/Nagad/card merchant approval ও credentials এখনো পাওয়া/সংযুক্ত নয়।
- [ ] Cloud Function deployment/live COD test এবং payment gateway sandbox-to-production verification বাকি।
- [ ] Bus/train/launch/hotel/toll providers-এর signed integration agreement/API access বাকি।
- [ ] Android workflow run 43632178263: analyzer ও widget tests pass; release APK step in progress ছিল, artifact verification pending।

**বর্তমান সিদ্ধান্ত:** COD checkout source-এ আছে; live online wallet/card payment চালু নয়। Travel hub-এ তথ্য/বাইরের লিংক ও rental listings আছে; live bus/train seat booking বা confirmed travel/hotel booking চালু নয়। এই সীমাবদ্ধতা দূর না হওয়া পর্যন্ত app-কে real-money/complete all-in-one production-ready বলা যাবে না।
