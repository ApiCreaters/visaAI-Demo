# Firebase Setup - Step-by-Step Visual Guide

## 🎯 Goal
Connect your Flutter app to Firebase so it can:
- Authenticate users (login/registration)
- Store loyalty cards and points
- Manage rewards
- Save user data

---

## Step 1️⃣: Create Firebase Project

### 1.1 Go to Firebase Console
```
https://console.firebase.google.com
```

### 1.2 Click "Add Project"
```
┌─────────────────────────────┐
│  Google Cloud              │
│                            │
│  [Add Project] ← Click     │
└─────────────────────────────┘
```

### 1.3 Fill in Project Details
```
Project name: WalletRewards
(Uncheck "Enable Google Analytics" for now)
Click "Create Project"
```

### 1.4 Wait for Creation
⏳ This takes ~1 minute

---

## Step 2️⃣: Add Android App

### 2.1 In Firebase Console, Click "Add App"
```
┌────────────────────────────────────────┐
│  WalletRewards                        │
│  [Add App] ← Click                     │
│     ├─ Android                        │
│     ├─ iOS                           │
│     ├─ Web                           │
│     └─ Flutter                       │
└────────────────────────────────────────┘
```

### 2.2 Select Android
```
Click: Android icon
```

### 2.3 Enter Package Name
```
Android package name: com.walletrewards.app
Click: Register app
```

### 2.4 Download google-services.json
```
┌──────────────────────────────┐
│  google-services.json        │
│  [Download] ← Click & Save   │
└──────────────────────────────┘
```

### 2.5 Place File in Project
**In your computer:**
```
Move the file to:
YOUR_PROJECT/android/app/google-services.json

Example:
/tmp/workspace/ApiCreaters/visaAI-Demo/android/app/google-services.json
```

### 2.6 Complete Android Setup
```
Click: "Next"
Click: "Next" again
Click: "Done"
```

---

## Step 3️⃣: Add iOS App

### 3.1 In Firebase Console, Click "Add App" Again
```
[Add App] → iOS
```

### 3.2 Enter Bundle ID
```
iOS bundle ID: com.walletrewards.app
Click: Register app
```

### 3.3 Download GoogleService-Info.plist
```
┌──────────────────────────────┐
│  GoogleService-Info.plist    │
│  [Download] ← Click & Save   │
└──────────────────────────────┘
```

### 3.4 Add to Xcode Project
**On your computer:**

1. Open Xcode:
```bash
open ios/Runner.xcworkspace
```

2. In Xcode:
```
Right-click "Runner" folder (left sidebar)
  ↓
Select "Add Files to Runner"
  ↓
Select GoogleService-Info.plist
  ↓
✓ Check "Copy items if needed"
  ↓
Click "Add"
```

3. Complete setup in Firebase Console:
```
Click: "Next"
Click: "Next" again
Click: "Done"
```

---

## Step 4️⃣: Enable Authentication

### 4.1 In Firebase Console
```
Left sidebar:
  Build
    ├─ Authentication ← Click
```

### 4.2 Go to Sign-in Method
```
┌──────────────────────────────┐
│  Authentication              │
│  [Sign-in method] ← Click    │
└──────────────────────────────┘
```

### 4.3 Enable Email/Password
```
┌──────────────────────────────┐
│  Email/Password              │
│  [OFF] → [ON] ← Toggle       │
│  Click: "Enable"             │
└──────────────────────────────┘

Click: "Save"
```

### 4.4 Check Status
```
✅ Email/Password authentication enabled
```

---

## Step 5️⃣: Create Firestore Database

### 5.1 Go to Firestore
```
Left sidebar:
  Build
    ├─ Firestore Database ← Click
```

### 5.2 Click "Create Database"
```
┌──────────────────────────────┐
│  Cloud Firestore             │
│  [Create Database] ← Click   │
└──────────────────────────────┘
```

### 5.3 Select Region
```
Choose region: us-central1 (or closest to you)
Click: "Next"
```

### 5.4 Set Security Rules
```
Rule: Start in test mode
      (allows everyone to read/write for 30 days)

✓ This is fine for development

Click: "Create"
```

### 5.5 Check Status
```
✅ Firestore Database created
   Status: Test Mode
   Expires in: 30 days
```

---

## Step 6️⃣: Enable Cloud Storage

### 6.1 Go to Storage
```
Left sidebar:
  Build
    ├─ Storage ← Click
```

### 6.2 Click "Get Started"
```
┌──────────────────────────────┐
│  Cloud Storage               │
│  [Get Started] ← Click       │
└──────────────────────────────┘
```

### 6.3 Set Security Rules
```
✓ Use default rules (test mode)
Click: "Next"
```

### 6.4 Select Location
```
Select default location: us-central1 (same as Firestore)
Click: "Done"
```

### 6.5 Check Status
```
✅ Cloud Storage enabled
   Bucket: gs://walletrewards.appspot.com
```

---

## Step 7️⃣: Configure Flutter App

### 7.1 Option A: Automatic (Recommended)

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Run from project root
flutterfire configure

# Follow prompts:
# - Select project: wallet-rewards (or your project)
# - Select platforms: Android, iOS
# - Agree to changes

# This updates lib/firebase_options.dart automatically ✅
```

### 7.2 Option B: Manual Configuration

Edit `lib/firebase_options.dart`:

```dart
// Get values from Firebase Console → Project Settings

// Android (google-services.json values):
const String androidApiKey = 'YOUR_ANDROID_API_KEY';
const String androidAppId = 'YOUR_ANDROID_APP_ID';

// iOS (GoogleService-Info.plist values):
const String iosApiKey = 'YOUR_IOS_API_KEY';
const String iosBundleId = 'com.walletrewards.app';
```

Find these values:
1. Go to Firebase Console
2. Click ⚙️ (Settings) → Project Settings
3. Copy your API key and other values

---

## Step 8️⃣: Verify Setup

### 8.1 In Firebase Console, Check All Services

```
✅ Authentication → Email/Password enabled
✅ Firestore Database → Test Mode active
✅ Cloud Storage → Enabled
✅ android/app/google-services.json → Present
✅ ios/Runner/GoogleService-Info.plist → In Xcode
✅ lib/firebase_options.dart → Filled with credentials
```

### 8.2 In Your Project, Run

```bash
# Navigate to project
cd /tmp/workspace/ApiCreaters/visaAI-Demo

# Get dependencies
flutter pub get

# Run app
flutter run -d android  # or -d ios
```

### 8.3 Test in App

```
1. Register new account
   - Email: test@example.com
   - Password: Test123!

2. Check Firebase Console → Authentication
   - Should see your new user ✅

3. Add loyalty card in app

4. Check Firebase Console → Firestore
   - Collections should appear:
     ✅ customers
     ✅ loyalty_cards
     ✅ restaurants
     ✅ rewards
     ✅ transactions
```

---

## 🎯 You're Done! 🎉

### Summary
```
✅ Firebase Project created
✅ Android app configured
✅ iOS app configured
✅ Authentication enabled
✅ Firestore Database created
✅ Cloud Storage enabled
✅ Flutter app configured
✅ All files placed correctly
```

### Next Steps
1. Run: `flutter run`
2. Create an account
3. Test the app
4. Check Firebase Console to verify data is saving

---

## 🐛 Troubleshooting

### Problem: "Firebase initialization failed"
```
Solution:
1. Verify firebase_options.dart has credentials
2. Run: flutter clean && flutter pub get
3. Check google-services.json is in android/app/
4. Check GoogleService-Info.plist is in Xcode
```

### Problem: "Permission denied on Firestore"
```
Solution:
1. Go to Firestore → Rules
2. Ensure Test Mode is enabled (or update rules)
3. Verify user is authenticated
```

### Problem: "App crashes on startup"
```
Solution:
1. Run: flutter logs
2. Look for Firebase initialization errors
3. Verify all config files are in place
4. Check console.firebase.google.com for status
```

---

## 📞 Need Help?

1. **Firebase Console Help** → Click ? icon
2. **Flutter Firebase Docs** → https://firebase.flutter.dev
3. **Firebase Auth Docs** → https://firebase.google.com/docs/auth
4. **Firestore Docs** → https://firebase.google.com/docs/firestore

---

**You now have a production-ready Firebase backend!** 🚀
