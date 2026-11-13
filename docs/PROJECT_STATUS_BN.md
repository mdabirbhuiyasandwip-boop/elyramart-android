# Elyramart প্রকল্পের বর্তমান অবস্থা

সর্বশেষ যাচাই: ১৩ নভেম্বর ২০২৬

## যা তৈরি আছে
- Flutter অ্যাপের Android এবং Web build workflow।
- E-only সবুজ ব্র্যান্ড মার্ক; customer home, product catalog placeholder, cart, checkout demo।
- seller portal, technician portal, admin overview এবং owner settings-এর প্রাথমিক UI।
- electrician, plumber/sanitary, AC, fridge/washing machine, computer/laptop, mobile, IPS/generator, TV/appliance service request UI।
- পণ্যের তালিকা খালি রাখা হয়েছে; Admin/Seller পরে পণ্য যোগ করবে।
- Firestore ও Storage-এর প্রাথমিক security rules।
- প্রথম মালিক Admin claim করার জন্য callable Cloud Function-এর source।
- Developer handoff ও Firebase setup guide।

## যেগুলো এখনো demo/local-only
বর্তমান Flutter app-এ Firebase SDK/config যুক্ত নেই। তাই নিচের তথ্য SharedPreferences-এ শুধু যে ফোনে ব্যবহার করা হয় সেখানেই থাকে:
- customer profile এবং login screen (আসল authentication নয়)
- cart, checkout/order history
- seller registration ও products
- technician profile ও booking
- admin order/service status
- owner settings

এই তথ্য অন্য ফোন, iPhone, laptop বা web browser-এ sync হয় না। অর্ডার বা booking বাস্তবে Elyramart-এর সার্ভারে/দোকানে/technician-এর কাছে পাঠানো হয় না।

## প্রকৃত launch-এর আগে বাধ্যতামূলক কাজ
1. মালিকের নিজের Google account-এ Firebase project তৈরি ও Android app `com.elyramartbd.elyramart` register করা।
2. Authentication, Firestore ও Storage চালু করা; generated `google-services.json` এবং FlutterFire options secure setup-এ যোগ করা।
3. Flutter app-এ Firebase Auth, Firestore, Storage SDK এবং cloud repositories সংযোগ করা; local demo storage-কে cloud data দিয়ে প্রতিস্থাপন করা।
4. Cloud Function deploy করে verified owner email `elyramartbd@gmail.com`-কে প্রথম Admin claim দেওয়া।
5. Seller/technician application review, product approval, order assignment, booking dispatch ও status notifications server-side implement করা।
6. Payment gateway merchant account ও server-side payment verification যোগ করা। bKash/Nagad PIN বা OTP কখনো অ্যাপে সংগ্রহ/সংরক্ষণ করা যাবে না।
7. Firestore/Storage rules Emulator-এ পরীক্ষা, privacy policy, terms, refund/cancellation policy এবং support process প্রস্তুত করা।
8. Android real-device QA ও release signing; iOS build-এর জন্য macOS/Xcode এবং Apple Developer account; website-এর জন্য hosting/domain deployment।

## মালিকের নিরাপত্তা ও প্রয়োজনীয় একবারের কাজ
Firebase project মালিকের Google account-এর অধীনে থাকতে হবে, যাতে project ও billing-এর নিয়ন্ত্রণ মালিকের হাতেই থাকে। Google password, OTP, service-account private key বা payment secret ChatGPT-তে পাঠাবেন না। শুধু Firebase Console থেকে generated Android app config নিরাপদে project-এ যুক্ত করতে হবে।

Cloud Functions deploy করতে Firebase billing plan লাগতে পারে। কোনো paid plan বা billing চালু করার আগে খরচ ও অনুমতি নিশ্চিত করতে হবে।

## Build ও deployment status
- Android APK build workflow: সর্বশেষ যাচাইকৃত run সফল।
- Web build artifact workflow: সর্বশেষ যাচাইকৃত run সফল।
- GitHub Pages deployment workflow: সর্বশেষ যাচাইকৃত deployment run ব্যর্থ; তাই live website URL সফলভাবে প্রকাশিত হয়েছে বলা যাচ্ছে না।
- APK/Web build artifact তৈরি হওয়া মানেই backend বা live service চালু হওয়া নয়।

## ভবিষ্যৎ IT developer-এর জন্য
এই repository এবং `docs/DEVELOPER_HANDOFF_BN.md`-কে source of truth ধরুন। Existing demo UI সরাবেন না যতক্ষণ না cloud replacement test pass করে। একই Flutter codebase Android/iOS/Web-এ ব্যবহার করুন; business rules এবং money calculation trusted server-এ রাখুন।
