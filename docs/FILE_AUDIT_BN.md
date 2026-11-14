# Elyramart Repository File Audit (বাংলা)

সর্বশেষ audit: ১৪ নভেম্বর ২০২৬  
Source of truth: repository root-এর Flutter source এবং বর্তমান main branch।

এই তালিকা দেখায় কোন ফাইল কী কাজ করে, কোনগুলো build/deploy-এর জন্য, এবং কোনগুলোতে owner-side credential বা manual setup লাগে। কোনো build artifact-কে live service বা Play Store release ধরে নেওয়া যাবে না।

## ১. মূল অ্যাপ ও dependency

| ফাইল | কাজ | অবস্থা |
|---|---|---|
| `lib/main.dart` | Flutter customer, seller, technician, admin ও rental UI; authentication, cart, COD checkout, booking, product/rental browse ও post | নতুন rental feature যোগ; latest APK/Web CI ও device QA যাচাই চলছে |
| `pubspec.yaml` | Flutter ও Firebase package dependency; app version | আছে; release version bump পরে |
| `google-services.json` | Android Firebase client configuration; package `com.elyramartbd.elyramart` | আছে; এটি deploy private key নয় |
| `firebase.json` | Firestore rules, Storage rules ও Functions deployment mapping | আছে |
| `Elyramart_GitHub_Upload.zip` | পুরোনো source upload snapshot | Archive only; root files-ই source of truth |

**Generated files:** `android/` এবং `web/` source folders build workflow-তে Flutter দিয়ে তৈরি হয়; এগুলো repository-তে না থাকা নিজে থেকে build blocker নয়। iOS project/signing এখনো তৈরি/পরীক্ষিত নয়।

## ২. Firebase backend ও security

| ফাইল | কাজ | অবস্থা |
|---|---|---|
| `functions/package.json` | Cloud Functions dependencies ও scripts | আছে |
| `functions/tsconfig.json` | TypeScript compiler configuration | আছে |
| `functions/src/index.ts` | Owner admin claim, COD order/stock transaction, order/booking notification triggers | Compile আগে সফল; deploy credential না থাকায় live deploy হয়নি |
| `firestore.rules` | User, product, order, seller/technician application, booking, rental listing ও settings access rules | rental listing security rules-সহ ১৪ নভেম্বর ২০২৬ run `43571797191`-এ compile ও deploy সফল; Emulator test বাকি |
| `storage.rules` | User ও approved seller image upload access | আছে; Emulator/production verification বাকি |

## ৩. GitHub Actions / CI

| ফাইল | কাজ | অবস্থা |
|---|---|---|
| `.github/workflows/build-apk.yml` | Android APK ও AAB build, analyze, widget tests, artifacts | workflow আছে; সর্বশেষ run যাচাই চলছে |
| `.github/workflows/build-web.yml` | Flutter Web build, analyze, widget tests, artifact | Firebase Web config secrets পেলে online mode; সর্বশেষ run যাচাই চলছে |
| `.github/workflows/deploy-pages.yml` | Web build ও GitHub Pages deployment | workflow আছে; Pages owner enablement প্রয়োজন হতে পারে |
| `.github/workflows/check-functions.yml` | Node 20 dependencies ও TypeScript compile check | আগে সফল |
| `.github/workflows/deploy-firebase.yml` | Firestore Rules বিনা Blaze-এ deploy; Functions/Storage opt-in | ১৪ নভেম্বর ২০২৬ run `43570891759`-এ Firestore Rules deploy success; Functions ও Storage intentionally skipped |
| `.github/workflows/deploy-hosting.yml` | Firebase Hosting-এ Flutter Web প্রকাশ | workflow যোগ করা হয়েছে; Service Account ও ছয়টি Web config secret প্রয়োজন |

## ৪. বিকল্প build ও helper scripts

| ফাইল | কাজ | অবস্থা |
|---|---|---|
| `codemagic.yaml` | Codemagic দিয়ে Android APK/AAB build | আছে; signing key/credentials configure করা নেই |
| `tools/generate_brand_assets.py` | Android/Web-এর E-only brand icon তৈরি | আছে |
| `tools/configure_web_pwa.py` | Web manifest, title ও PWA metadata | আছে |
| `tools/configure_android_signing.py` | Protected CI secrets থেকে upload keystore validate করে Android release sign setup | যোগ করা হয়েছে; চারটি signing secret না দেওয়া পর্যন্ত unsigned artifact তৈরি হবে |

## ৫. Test

| ফাইল | কাজ | অবস্থা |
|---|---|---|
| `test/widget_test.dart` | phone normalization, main pages/profile, out-of-stock action ও cached-profile account isolation test | নতুন test যোগ; সর্বশেষ Android/Web CI-তে pass হওয়া যাচাই বাকি |

## ৬. Documentation

| ফাইল | কাজ | অবস্থা |
|---|---|---|
| `README.md` | project overview, CI status, developer links | আপডেট |
| `docs/APK_BUILD_REQUEST.md` | Android build trigger note | রাখা হয়েছে |
| `docs/DEVELOPER_HANDOFF_BN.md` | ভবিষ্যৎ developer-এর architecture ও handoff | আপডেট |
| `docs/FIREBASE_SETUP_BN.md` | Firebase Android/Web, secrets ও deploy setup | Web config secrets যোগ করে আপডেট |
| `docs/LAUNCH_CHECKLIST_BN.md` | end-to-end release checklist | তৈরি/আপডেট |
| `docs/OWNER_ACTIONS_BN.md` | Firebase, Web Hosting, Pages ও Play signing-এর owner-only setup steps | যোগ করা হয়েছে |
| `docs/PRIVACY_POLICY_DRAFT_BN.md` | Privacy policy-এর বাংলা খসড়া | মালিক/আইনজীবীর যাচাই ও public URL বাকি |
| `docs/PRODUCTION_READINESS.md` | production readiness ও verified blockers | আপডেট |
| `docs/PROJECT_STATUS_BN.md` | বর্তমান project status | আপডেট |
| `docs/SERVICE_MARKETPLACE.md` | customer/provider/admin service scope | আছে |
| `docs/TERMS_DRAFT_BN.md` | Marketplace terms-এর বাংলা খসড়া | মালিক/আইনজীবীর যাচাই বাকি |

## ৭. পরিষ্কার করা হয়েছে

- Duplicate `google-services (3).json` সরানো হয়েছে; একটিমাত্র `google-services.json` রাখা হয়েছে।
- পুরোনো nested `github/workflows/.../build-apk.yml` সরানো হয়েছে; সক্রিয় workflow শুধু `.github/workflows/`-এ।
- Android, Web ও Pages workflows-এ test file পরিবর্তন হলেও checks চালানোর path filter যোগ হয়েছে।
- Web Firebase initialization-এর compile-time config path যোগ হয়েছে।
- Seller stock zero হলে add-to-cart বন্ধ; multi-seller order-এর status একক seller পরিবর্তন করতে পারে না।

## ৮. এখনও external access/decision প্রয়োজন

1. Firebase deploy: valid Google Cloud service-account key JSON-কে GitHub Actions secret `FIREBASE_SERVICE_ACCOUNT_JSON` হিসেবে owner-কে যোগ করতে হবে।
2. Web online mode: Firebase Console-এর Web App config থেকে ৬টি `ELYRAMART_FIREBASE_*` secret যোগ করতে হবে।
3. Public website: repository Settings → Pages-এ GitHub Actions source enable করতে হতে পারে।
4. Play Store: upload keystore/password, Play Console account, policy declarations, privacy policy public URL ও Google review।
5. Firebase Hosting: নতুন deploy workflow-তে Service Account এবং ছয়টি Web config secret যোগ করতে হবে।
5. Live marketplace: Firebase services deploy, verified owner account, real seller/technician accounts, end-to-end QA এবং প্রয়োজনীয় legal/business permissions।

**এই audit-এর উদ্দেশ্য:** কোনো ফাইলকে অকারণে “বাকি” বলা নয়; code, CI, deployment এবং owner-side setup আলাদা করে পরিষ্কার রাখা।
