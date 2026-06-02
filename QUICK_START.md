# WalletRewards - Quick Start Guide

## 🚀 30-Minute Setup

### Prerequisites Check
```bash
# Verify Flutter is installed
flutter --version  # Should be 3.8.1+

# Verify Dart
dart --version

# Clone or navigate to project
cd wallet_rewards
```

### Step 1: Install Dependencies (5 min)
```bash
flutter pub get
```

### Step 2: Firebase Setup (15 min)

1. **Go to [Firebase Console](https://console.firebase.google.com)**
2. **Create a new project** named "WalletRewards"
3. **For Android:**
   - Add Android app, package: `com.walletrewards.app`
   - Download `google-services.json`
   - Place in `android/app/google-services.json`

4. **For iOS:**
   - Add iOS app, bundle ID: `com.walletrewards.app`
   - Download `GoogleService-Info.plist`
   - Add to Xcode Runner project

5. **Enable Services:**
   - Authentication → Email/Password
   - Firestore Database → Test Mode
   - Cloud Storage → Test Mode

### Step 3: Update Firebase Config (5 min)

**Option A: Using FlutterFire CLI (Recommended)**
```bash
# Install FlutterFire CLI if not already installed
dart pub global activate flutterfire_cli

# Run configuration
flutterfire configure

# This automatically updates lib/firebase_options.dart
```

**Option B: Manual Configuration**
- Open `lib/firebase_options.dart`
- Fill in your Firebase credentials from Firebase Console
- Get values from Project Settings

### Step 4: Run the App (5 min)
```bash
# For iOS
flutter run -d ios

# For Android
flutter run -d android

# For web (optional)
flutter run -d chrome
```

---

## 📱 Testing the App

### 1. Create Account
- Open app
- Go to Register tab
- Enter: email, password, first name, last name
- Click Register

### 2. Verify Setup
- Check [Firebase Console](https://console.firebase.google.com) → Authentication
- Should see your new user

### 3. Add Loyalty Card
- Go to Home screen
- Click "Add New Card"
- Browse and select a restaurant
- Card created successfully

### 4. Check Firestore
- Go to [Firebase Console](https://console.firebase.google.com) → Firestore
- Check `/customers/{userId}` document
- Check `/loyalty_cards` collection

---

## 🔧 Project Structure Map

```
lib/
├── main.dart                          # App entry point
├── firebase_options.dart              # Firebase config (FILL THIS IN)
│
├── models/                            # Data models
│   ├── customer.dart                 # ✅ User profile
│   ├── loyalty_card.dart             # ✅ Loyalty cards
│   ├── reward.dart                   # ✅ Rewards
│   ├── loyalty_transaction.dart      # ✅ Transactions
│   └── restaurant.dart               # ✅ Restaurants
│
├── services/                          # Business logic
│   ├── firebase_service.dart         # ✅ Firebase init
│   ├── auth_service.dart             # ✅ Authentication
│   ├── firestore_service.dart        # ✅ Database ops
│   ├── qr_service.dart               # ✅ QR handling
│   ├── storage_service.dart          # ✅ Local storage
│   └── loyalty_service.dart          # ✅ Business logic
│
├── controllers/                       # GetX state
│   ├── auth_controller.dart          # ✅ Auth state
│   ├── loyalty_controller.dart       # ✅ Loyalty state
│   ├── qr_controller.dart            # ✅ QR state
│   └── user_controller.dart          # ✅ User state
│
├── screens/                           # UI Screens
│   ├── home_screen.dart              # ✅ Dashboard
│   ├── login_screen.dart             # ✅ Auth
│   ├── qr_scanner_screen.dart        # ✅ QR scanner
│   ├── rewards_screen.dart           # ✅ Rewards
│   └── profile_screen.dart           # ✅ Profile
│
└── widgets/                           # 📋 Reusable widgets
    └── (To be created as needed)
```

---

## 🔑 Key Code Examples

### Initialize App
```dart
// Already done in main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  await StorageService().init();
  // ... controllers registered
}
```

### Use Auth Controller
```dart
final authController = Get.find<AuthController>();

// Check authentication
if (authController.isAuthenticated) {
  print('User logged in');
}

// Sign in
await authController.signInWithEmail(
  email: 'user@example.com',
  password: 'password',
);

// Sign out
await authController.signOut();
```

### Use Loyalty Controller
```dart
final loyaltyController = Get.find<LoyaltyController>();

// Get user's cards
await loyaltyController.getUserLoyaltyCards(userId);

// Create card
await loyaltyController.createLoyaltyCard(
  userId: userId,
  restaurantId: restaurantId,
  restaurantName: 'Restaurant Name',
);

// Update points
await loyaltyController.updateCardPoints(
  card: card,
  pointsChange: 50,
);

// Watch reactive state
Obx(() {
  final cards = loyaltyController.loyaltyCards;
  final totalPoints = loyaltyController.getTotalPoints();
});
```

### Access Services
```dart
// Firebase
final firebase = FirebaseService();
final user = firebase.currentUser;

// Firestore
final firestore = FirestoreService();
final customer = await firestore.getCustomer(userId);

// Loyalty business logic
final loyalty = LoyaltyService();
final tier = loyalty.getPointsTier(totalEarned);
final formatted = loyalty.formatPoints(100);

// Local storage
final storage = StorageService();
await storage.setString('key', 'value');
final value = storage.getString('key');

// QR codes
final qr = QrService();
final qrCode = qr.generateQrCode(
  cardId: cardId,
  restaurantId: restaurantId,
  userId: userId,
);
```

---

## 🐛 Common Issues & Solutions

### Issue: "Firebase not initialized"
**Solution:**
- Ensure `firebase_setup_guide.md` steps are completed
- Check `firebase_options.dart` is filled with credentials
- Run: `flutter clean && flutter pub get`

### Issue: "google-services.json not found (Android)"
**Solution:**
- Download from Firebase Console
- Place in: `android/app/google-services.json`
- Run: `flutter clean`

### Issue: "GoogleService-Info.plist not found (iOS)"
**Solution:**
- Download from Firebase Console
- Add to Xcode (Runner project)
- Select "Copy items if needed"
- Re-run app

### Issue: "Firestore permission denied"
**Solution:**
- Check Firestore is in test mode
- Or update rules in `firebase_setup_guide.md`
- Check user is authenticated

### Issue: "App won't compile"
**Solution:**
```bash
flutter clean
rm -rf pubspec.lock
flutter pub get
flutter run
```

---

## 📊 Database Schema at a Glance

### Collections

**customers**
```
/customers/{userId}
  - email: string
  - firstName, lastName: string
  - profileImageUrl: string
  - favoriteRestaurants: array
  - createdAt: timestamp
```

**loyalty_cards**
```
/loyalty_cards/{cardId}
  - userId, restaurantId: string
  - cardNumber: string
  - currentPoints, totalPointsEarned: int
  - isActive: boolean
  - createdAt: timestamp
```

**rewards**
```
/rewards/{rewardId}
  - restaurantId: string
  - title, description: string
  - pointsRequired: int
  - isAvailable: boolean
```

**transactions**
```
/transactions/{transactionId}
  - cardId, userId, restaurantId: string
  - type: string (earn|redeem|expire|adjust)
  - pointsAmount: int
  - timestamp: timestamp
  - description: string
```

**restaurants**
```
/restaurants/{restaurantId}
  - name, category: string
  - location: geopoint
  - rating: double
  - isActive: boolean
```

---

## 🎯 Next Steps After Setup

1. **Test Core Features:**
   - ✅ Create account
   - ✅ Add loyalty card
   - ✅ View dashboard
   - ✅ Update profile

2. **Test Integration:**
   - ✅ Verify Firestore saves data
   - ✅ Check Firebase Console
   - ✅ Test on physical device

3. **Customize & Extend:**
   - Add more screens
   - Implement notifications
   - Add restaurant management
   - Enhance UI with animations

4. **Deploy:**
   - Configure app signing
   - Build release APK/IPA
   - Upload to stores

---

## 📚 Detailed Documentation

- **WALLETREWARDS_README.md** - Complete architecture & API docs
- **firebase_setup_guide.md** - Detailed Firebase configuration
- **IMPLEMENTATION_SUMMARY.md** - What's been built overview

---

## 💡 Tips & Tricks

### Debug Firebase Issues
```dart
// Enable Firestore logging
FirebaseFirestore.instance.settings = 
  Settings(loggingEnabled: true);
```

### Check GetX State
```dart
// Print controller info
print(Get.find<AuthController>().isAuthenticated);
```

### Clear Local Data
```dart
// Clear SharedPreferences
await StorageService().clear();
```

### View Console Logs
```bash
flutter logs
```

---

## 🚨 Important Checklist Before Release

- [ ] Fill `firebase_options.dart` with real credentials
- [ ] Update app icons in `android/` and `ios/`
- [ ] Test on physical devices
- [ ] Review Firestore security rules
- [ ] Set up app signing for release
- [ ] Test all authentication flows
- [ ] Verify notifications work
- [ ] Performance test with real data
- [ ] Security audit
- [ ] Privacy policy prepared

---

## 📞 Need Help?

1. **Firebase Issues** → See `firebase_setup_guide.md`
2. **Architecture Questions** → See `WALLETREWARDS_README.md`
3. **Code Examples** → Check inline comments in files
4. **GetX Issues** → [GetX Documentation](https://github.com/jonataslaw/getx)
5. **Firebase Issues** → [Firebase Docs](https://firebase.flutter.dev)

---

## ✨ You're All Set! 🎉

You now have a fully functional WalletRewards app foundation with:
- ✅ Complete project structure
- ✅ All core services and models
- ✅ GetX state management
- ✅ Firebase integration ready
- ✅ Beautiful UI screens
- ✅ Comprehensive documentation

**Next: Configure Firebase and run the app!**

---

**Questions?** Check the documentation files or Firebase Console help center.

**Ready to build?** `flutter run` 🚀
