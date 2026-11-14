# Elyramart — বাসা ও অফিস ভাড়া বিভাগ

## কী আছে
হোম স্ক্রিনে **বাসা ও অফিস ভাড়া** নামে একটি বিভাগ যোগ হয়েছে। ব্যবহারকারী সেখানে:
- **ভাড়া দেব** বেছে বাসা বা অফিসের বিজ্ঞাপন দিতে পারবেন।
- **ভাড়া প্রয়োজন** বেছে নিজের বাসা/অফিস খোঁজার চাহিদা প্রকাশ করতে পারবেন।
- বাসা ও অফিস আলাদা করে বিজ্ঞাপন দেখতে পারবেন।
- বিজ্ঞাপনে শিরোনাম, মাসিক ভাড়া/বাজেট, এলাকা, ফোন ও বিস্তারিত দেখতে পারবেন।

## পোস্ট দেওয়ার নিয়ম
1. Elyramart অ্যাপে ইমেইল দিয়ে লগইন করতে হবে।
2. ইমেইল verification সম্পন্ন থাকতে হবে।
3. বিজ্ঞাপনের ধরন, বাসা/অফিস, শিরোনাম, মাসিক টাকা, এলাকা এবং বাংলাদেশি মোবাইল নম্বর দিতে হবে।
4. প্রকাশ করলে বিজ্ঞাপন Firebase Firestore-এর `rentalListings` collection-এ যাবে।
5. সর্বোচ্চ ১০০টি active listing browse screen-এ দেখানো হয়।

## Data fields
- `ownerId`: পোস্টদাতার Firebase UID
- `ownerName`: প্রদর্শনের নাম
- `propertyType`: `বাসা` অথবা `অফিস`
- `listingType`: `offer` (ভাড়া দেব) অথবা `wanted` (ভাড়া প্রয়োজন)
- `title`: বিজ্ঞাপনের শিরোনাম
- `rentAmount`: মাসিক ভাড়া অথবা বাজেট, পূর্ণসংখ্যা BDT
- `location`: এলাকা/ঠিকানা
- `phone`: যাচাইকৃত ফরম্যাটের বাংলাদেশি মোবাইল নম্বর
- `details`: অতিরিক্ত বিবরণ
- `status`: নতুন পোস্টে `active`
- `createdAt`: Firestore server timestamp

## Security
`firestore.rules`-এ:
- সবাই শুধু active listing পড়তে পারে।
- verified user নিজের UID দিয়ে পোস্ট করতে পারে।
- ভাড়া/বাজেট, ফোন, শিরোনাম ও অন্যান্য field server rules-এ যাচাই হয়।
- নিজের পোস্ট owner মুছতে পারে; update/delete admin নিয়ন্ত্রণে।
- app client অন্য কারও ownerId দিয়ে পোস্ট করতে পারে না।

## গুরুত্বপূর্ণ সীমাবদ্ধতা
- এই সংস্করণে listing post/read এবং নিজের listing delete করার নিরাপত্তা rule আছে; app UI-তে edit/delete management screen এখনো নেই।
- ছবি upload, map pin, filters (জেলা/উপজেলা), chat, saved/favourite listing, report/scam moderation এবং admin approval workflow এখনো যোগ হয়নি।
- বিজ্ঞাপন active হয়ে সঙ্গে সঙ্গে দেখা যায়। তাই যোগাযোগের আগে জায়গা সরেজমিনে দেখা ও মালিকানা/ভাড়ার কাগজ যাচাই করা জরুরি।
- Elyramart ভাড়া, অগ্রিম বা জামানত সংগ্রহ করে না।
- Firestore Rules deployment সফল না হলে বা Firebase config না থাকলে online rental listing কাজ করবে না।
