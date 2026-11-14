# মালিকের লগইন, ভাড়া ও দৈনন্দিন সেবা ডিরেক্টরি

## মালিকের অ্যাকাউন্ট

- Owner email: `elyramartbd@gmail.com`
- Business contact number: `01733814802`
- Firebase Auth login method: Email/Password
- Password: এই প্রকল্পে কোনো মালিকের পাসওয়ার্ড তৈরি, সংরক্ষণ বা source code-এ রাখা হয়নি। মালিক Firebase Authentication-এ নিজে password সেট করবেন অথবা Password reset flow ব্যবহার করবেন।
- অ্যাপের পথ: Home → Account → Email/Password → Login → Email verification → Owner Admin যাচাই করুন।
- Owner Admin claim function `functions/src/index.ts`-এ `claimOwnerAdmin`; এটি শুধু উপরের verified email-কে admin custom claim দেয়।
- গুরুত্বপূর্ণ: Cloud Functions deploy বর্তমানে Blaze billing gate-এর কারণে বন্ধ। তাই callable `claimOwnerAdmin` function live না হওয়া পর্যন্ত Owner Admin button কাজ করবে না। Billing অনুমোদন না করে এটি চালু করা যাবে না।

## ভাড়া বিভাগ — সংশোধিত আচরণ

- শুধু বাড়ি/ফ্ল্যাট/অফিসের মালিক বা অনুমোদিত বিজ্ঞাপনদাতা ভাড়ার বিজ্ঞাপন দিতে পারবেন।
- যারা বাসা/অফিস খুঁজছেন তারা কোনো request/post দেবেন না।
- তারা বিজ্ঞাপন browse করে বিজ্ঞাপনদাতার দেওয়া নম্বরে সরাসরি ফোন করবেন।
- নতুন পোস্টে `listingType: offer`; Firestore Rules অন্য listingType reject করে।
- পুরোনো `wanted` request records browse screen-এ দেখানো হয় না।

## দৈনন্দিন সেবা ডিরেক্টরি

অ্যাপে বর্তমানে দুটি directory tab-এর UI আছে:
1. হাসপাতাল/স্বাস্থ্যসেবা
2. মেয়েদের বিউটি পার্লার

প্রতিটি তালিকায় নাম, ঠিকানা, বিভাগ, জেলা, উপজেলা ও ফোন দেখানোর data model আছে। ফোন icon-এ tap করলে dialer খোলে; address-এ tap করলে Google Maps search খোলে।

### বাংলাদেশের এলাকা ডেটা

`assets/data/bangladesh_locations.json`-এ:
- ৮ বিভাগ
- ৬৪ জেলা
- ৪৯৫ উপজেলা

Source: Open Admin Data, Bangladesh Administrative Divisions, CC BY 4.0
https://github.com/open-admin-data/bangladesh-administrative-divisions
Source data updated 2026-09-08. Dataset attribution must remain with the asset.

**গুরুত্বপূর্ণ গণনা-অমিল:** বাংলাদেশ জাতীয় তথ্য বাতায়ন বর্তমানে ৮ বিভাগ, ৬৪ জেলা ও ৫০০ উপজেলা দেখায়: https://bangladesh.gov.bd/views/upazila-list/ । তাই app asset-এর ৪৯৫ উপজেলার সঙ্গে সরকারি পোর্টালের ৫০০ সংখ্যার ৫টির অমিল আছে; পূর্ণাঙ্গ দাবি করার আগে এই ৫টি নাম ও parent district মিলিয়ে asset হালনাগাদ করতে হবে।

### হাসপাতাল

সরকারি DGHS Facility Registry:
https://hris.mohfw.gov.bd/public/facility-registry/

DGHS registry-তে হাসপাতাল ছাড়াও clinic, diagnostic centre, blood bank, office এবং অন্যান্য health facilities থাকতে পারে। Import করার সময় facility type filter করে hospital/clinic/diagnostic category আলাদা করতে হবে। Directory UI এখনো সম্পূর্ণ DGHS data import করে না; data empty থাকলে সরকারি registry link দেখায়।

### মেয়েদের পার্লার

বাংলাদেশে সব পার্লারের একক, সরকারি, সম্পূর্ণ ও নিয়মিত updated public registry নিশ্চিত করা যায়নি। তাই অনুমান করে নাম/ফোন/ঠিকানা দেওয়া হয়নি। ব্যবসা থেকে তথ্য নিয়ে যাচাই করে `directoryListings` collection-এ যোগ করতে হবে।

### Firestore directory schema

Collection: `directoryListings/{id}`

Required fields:
- `category`: `hospital` অথবা `beauty_parlour`
- `name`: প্রতিষ্ঠানের নাম
- `address`: পূর্ণ ঠিকানা
- `phone`: যাচাইকৃত ফোন নম্বর
- `divisionId`, `districtId`, `districtBn`
- `upazilaId`, `upazilaBn`
- `source`: সরকারি উৎস URL অথবা ব্যবসার কাছ থেকে তথ্য যাচাইয়ের বিবরণ
- `status`: `active` কেবল যাচাইয়ের পর
- `createdAt`, `updatedAt`: Firestore timestamps

শুধু Owner Admin directory listing create/update/delete করতে পারবে। Public user শুধু active records পড়তে পারবে।

## পরবর্তী দৈনন্দিন সেবা বিভাগ

একই ডিরেক্টরি কাঠামোয় পরে ফার্মেসি, ডাক্তার/ক্লিনিক, স্কুল/কলেজ, রেস্টুরেন্ট, মুদি দোকান, পরিবহন, হোটেল, কুরিয়ার, আইনজীবী, ইলেকট্রিশিয়ান/প্লাম্বার, গাড়ি ভাড়া এবং অন্যান্য সেবা যোগ করা যাবে। প্রতিটি বিভাগের বাস্তব তালিকা, ঠিকানা ও ফোন যাচাই করে import করতে হবে।

## Production সতর্কতা

UI বা location dropdown থাকা মানেই প্রতিটি জেলার সব প্রতিষ্ঠান অ্যাপে যুক্ত হয়েছে—এমন নয়। DGHS data import, beauty parlour verification, directory moderation, phone/address freshness, Firebase Functions deployment, real device QA এখনো বাকি। চিকিৎসা-সংক্রান্ত জরুরি প্রয়োজনে এই ডিরেক্টরিকে জরুরি সেবা বা চিকিৎসকের বিকল্প হিসেবে ব্যবহার করা যাবে না।
