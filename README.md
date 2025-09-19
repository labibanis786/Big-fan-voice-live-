# Fresh Voice App - Ready ZIP

এই ZIP-এ একটি **ফাইনাল-স্টাইল Flutter প্রজেক্ট স্কেলেটন** আছে — ফোন OTP লগইন, Agora voice-room scaffold, multi-room support, এবং একটি সাধারণ gift-send flow (Firestore-ভিত্তিক)। 

**মার্কিং নোট**
- এই পরিবেশে আমি `flutter build` চালাতে পারিনি — তাই আপনি অবশ্যই নিচের স্টেপগুলো অনুসরণ করে `google-services.json` এবং iOS `GoogleService-Info.plist` ফাইল যোগ করবেন, আর AGORA_APP_ID বসাবেন। তারপর Codemagic-এ আপলোড করলে বিল্ড হওয়ার সম্ভাবনা বেশি।
- যদি Codemagic-এ বিল্ডে কোনো এরর দেখায়, আমি আগাতেই ডিবাগ করে দেবো — তুমি আমাকে বিল্ড লগ পাঠিয়ে দাও।

## কী বদলাতে হবে (প্রথম কাজ)
1. `android/app/google-services.json` — আপনার Firebase Android কনফিগ ফাইল এখানে রাখুন।
2. `ios/Runner/GoogleService-Info.plist` — iOS ফাইল এখানে রাখুন।
3. `lib/config.dart` — এখানে `AGORA_APP_ID` ও (যদি চাইলে) `AGORA_TEMP_TOKEN` বসান।

## কিভাবে ব্যবহার করবেন
1. ZIP আনজিপ করুন।
2. টার্মিনালে প্রজেক্ট ফোল্ডারে `flutter pub get` চালান।
3. Android: ensure `android/app/google-services.json` আছে।
4. iOS: ensure `ios/Runner/GoogleService-Info.plist` আছে।
5. Codemagic-এ ZIP আপলোড করুন (প্রজেক্ট টাইপ: Flutter).
6. যদি সাইনিং/keystore প্রয়োজন হয়, Codemagic secrets-এ আপনার keystore তথ্য যোগ করুন।

## ফিচার ও কাঠামো (সংক্ষিপ্ত)
- `lib/main.dart` — App entry, Firebase initialize, auth state handling.
- `lib/screens/login.dart` — ফোন নম্বর ইনপুট ও OTP পাঠানোর লজিক।
- `lib/screens/otp_verify.dart` — কোড ভেরিফিকেশন ও সাইন-ইন।
- `lib/screens/home.dart` — হোম পেজ, রুম এবং গিফট অপশন।
- `lib/screens/rooms.dart` — রুম লিস্ট এবং রুমে জয়েন করার বাটন (Agora scaffold)।
- `lib/services/firebase_service.dart` — ফায়ারবেস ইউজার/গিফট লজিক।
- `lib/services/agora_service.dart` — Agora init/join scaffold।
- `lib/config.dart` — এখানে আপনার AGORA_APP_ID বসাবেন (placeholder already).

## অন্যান্য
- launcher icon বা ডিজাইন আপলোড করতে `assets/icon/` এনগ করে প্রয়োজনীয় আইকনগুলো দিন।
- Codemagic-এর জন্য সাধারণভাবে `flutter pub get` চলবে এবং তারপর `flutter build apk` করা যাবে (credentials ও config সম্পন্ন হলে)।

আবারো বলছি — আমি ZIP তৈরি করেছি কিন্তু এখানে বিল্ড পরীক্ষা করা হয়নি। বিল্ড-লগ দিলে আমি দ্রুত করে ডিবাগ করব। 
