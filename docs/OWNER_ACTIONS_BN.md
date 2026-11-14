# Elyramart: মালিকের হাতে থাকা শেষ সেটআপ (বাংলা)

এই গাইডে শুধু সেই কাজগুলো আছে যেগুলো repository code দিয়ে করা যায় না, কারণ সেগুলোর জন্য project owner-এর Firebase/GitHub/Play Console access বা private key দরকার। কোনো password, OTP, service-account JSON বা keystore ChatGPT-তে পাঠাবেন না।

## ১. Firebase backend চালু করা

1. https://console.firebase.google.com/ খুলে `elyramart` project নির্বাচন করুন।
2. Project settings → Service accounts → Firebase Admin SDK → Generate new private key।
3. JSON ফাইলটি নিজের নিরাপদ ডিভাইসে রাখুন। এটি `google-services.json` নয়।
4. GitHub repository → Settings → Secrets and variables → Actions → New repository secret।
5. Name: `FIREBASE_SERVICE_ACCOUNT_JSON`
6. Secret value: ডাউনলোড করা service-account JSON ফাইলের সম্পূর্ণ contents।
7. Save করার পর GitHub Actions → **Deploy Elyramart Firebase backend** → Run workflow।
8. Workflow সফল না হলে billing/API permission লাগতে পারে। Firebase/Google Cloud-এ কোনো paid plan বা billing চালু করার আগে খরচ যাচাই করে মালিকের অনুমোদন নিন।

এই deploy Firestore Rules, Storage Rules ও Cloud Functions প্রকাশ করে।

## ২. ওয়েবসাইটের Firebase config যোগ করা

Firebase Console → Project settings → Your apps → Web app থেকে config values নিন। GitHub Actions secrets-এ নিচের ছয়টি নাম হুবহু তৈরি করুন:

- `ELYRAMART_FIREBASE_WEB_API_KEY`
- `ELYRAMART_FIREBASE_WEB_APP_ID`
- `ELYRAMART_FIREBASE_MESSAGING_SENDER_ID`
- `ELYRAMART_FIREBASE_PROJECT_ID` — value হবে `elyramart`
- `ELYRAMART_FIREBASE_AUTH_DOMAIN`
- `ELYRAMART_FIREBASE_STORAGE_BUCKET`

তারপর GitHub Actions → **Deploy Elyramart Web to Firebase Hosting** → Run workflow। এই workflow-তে ১ নম্বরের `FIREBASE_SERVICE_ACCOUNT_JSON` secret-ও থাকতে হবে। Deploy সফল হলেই Firebase Hosting URL তৈরি/আপডেট হবে।

## ৩. বিকল্প: GitHub Pages দিয়ে website প্রকাশ

Repository → Settings → Pages → Build and deployment → Source → **GitHub Actions** নির্বাচন করে Save করুন। তারপর Actions → **Deploy Elyramart Web to GitHub Pages** → Run workflow। Pages deploy সফল হলে Actions deployment summary-তে public URL দেখাবে।

## ৪. Play Store-এর জন্য signed AAB

আগে একটি Android upload keystore তৈরি করুন এবং নিরাপদ offline backup রাখুন। keystore হারাবেন না; পরের app update একই upload key দিয়ে sign করতে হবে।

বিশ্বস্ত কম্পিউটারে Java keytool দিয়ে উদাহরণস্বরূপ তৈরি করা যায়:

```bash
keytool -genkeypair -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias elyramart-upload
```

তারপর keystore-টি Base64-এ encode করে GitHub Actions secrets-এ নিচের চারটি নাম হুবহু যোগ করুন:

- `ANDROID_KEYSTORE_BASE64` — keystore file-এর Base64 text
- `ANDROID_KEYSTORE_PASSWORD` — keystore password
- `ANDROID_KEY_ALIAS` — key alias
- `ANDROID_KEY_PASSWORD` — key password

পরবর্তী Android workflow এগুলো validate করে release AAB sign করবে। Keystore বা password repository-তে commit করবেন না। ChatGPT-তে পাঠাবেন না।

## ৫. Play Console-এ শেষ ধাপ

- Google Play Console account ও identity verification সম্পন্ন করুন।
- Signed AAB internal testing track-এ upload করে বাস্তব Android device-এ পরীক্ষা করুন।
- Final Privacy Policy ও Terms-এর public HTTPS URL দিন; draft policy সরাসরি publish করবেন না।
- Data Safety, app access, content rating, target audience ও permission declarations পূরণ করুন।
- Play review/approval না পাওয়া পর্যন্ত app-কে Play Store-এ live বলা যাবে না।

## বর্তমানে code-এ যা নেই

- Checkout বর্তমানে Cash on Delivery (COD) সমর্থন করে; bKash/Nagad/card gateway এখনো implement হয়নি।
- Rider self-service app, live GPS tracking, proof of delivery ও settlement আলাদা development scope।
- Live Firebase/real seller/technician account দিয়ে end-to-end QA ও security rules emulator test এখনো প্রয়োজন।
- কোনো build artifact তৈরি হওয়া মানেই backend live, public website live বা Play Store approved নয়.
