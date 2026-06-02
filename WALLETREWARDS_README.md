# WalletRewards - Loyalty Card Management App

A Flutter application for managing loyalty cards and rewards using GetX state management and Firebase backend.

## Features

✨ **Core Features:**
- User Authentication (Email/Password)
- Loyalty Card Management
- Points Tracking and Management
- Rewards System
- QR Code Generation and Scanning
- Transaction History
- User Profile Management
- Favorite Restaurants

🔐 **Security:**
- Firebase Authentication
- Firestore Security Rules
- Null Safety throughout
- Input Validation

📊 **State Management:**
- GetX Controllers for reactive state
- Centralized business logic
- Service layer architecture

## Project Structure

```
lib/
├── main.dart                 # App entry point and theme configuration
├── firebase_options.dart     # Firebase configuration (fill with your credentials)
│
├── models/                   # Data models
│   ├── customer.dart        # User profile model
│   ├── loyalty_card.dart    # Loyalty card model
│   ├── reward.dart          # Reward model
│   ├── loyalty_transaction.dart  # Transaction history model
│   └── restaurant.dart       # Restaurant model
│
├── services/                 # Business logic and API services
│   ├── firebase_service.dart     # Firebase initialization
│   ├── auth_service.dart         # Authentication logic
│   ├── firestore_service.dart    # Firestore database operations
│   ├── qr_service.dart           # QR code handling
│   ├── storage_service.dart      # Local storage (SharedPreferences)
│   └── loyalty_service.dart      # Loyalty points calculation
│
├── controllers/              # GetX Controllers (State Management)
│   ├── auth_controller.dart      # Authentication state
│   ├── loyalty_controller.dart   # Loyalty cards and rewards state
│   ├── qr_controller.dart        # QR scanning state
│   └── user_controller.dart      # User profile state
│
├── screens/                  # UI Screens
│   ├── home_screen.dart          # Dashboard
│   ├── login_screen.dart         # Login/Registration
│   ├── qr_scanner_screen.dart    # QR code scanner
│   ├── rewards_screen.dart       # View rewards
│   └── profile_screen.dart       # User profile
│
└── utils/                    # Utility functions (to be created)
```

## Dependencies

### Core Framework
- **flutter**: ^3.8.1
- **get**: ^4.6.6 - GetX state management

### Firebase
- **firebase_core**: ^2.24.0
- **firebase_auth**: ^4.15.0
- **cloud_firestore**: ^4.14.0
- **firebase_storage**: ^11.6.0

### QR Code
- **qr_flutter**: ^6.1.1
- **mobile_scanner**: ^3.5.0

### UI & UX
- **google_fonts**: ^6.2.1
- **cached_network_image**: ^3.3.1
- **flutter_typeahead**: ^4.8.0
- **fl_chart**: ^0.65.0

### Data & Storage
- **shared_preferences**: ^2.2.2
- **http**: ^1.1.0

### Utilities
- **intl**: ^0.19.0
- **uuid**: ^4.0.0
- **permission_handler**: ^11.4.4
- **geolocator**: ^9.0.2

## Getting Started

### Prerequisites
- Flutter SDK (3.8.1+)
- Dart SDK
- Firebase Account
- Xcode (for iOS) or Android Studio (for Android)

### Setup Instructions

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd wallet_rewards
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase:**
   - Follow [firebase_setup_guide.md](firebase_setup_guide.md) for detailed setup
   - Update `lib/firebase_options.dart` with your Firebase credentials
   - Or use FlutterFire CLI: `flutterfire configure`

4. **Run the app:**
   ```bash
   flutter run
   ```

## Architecture

### GetX State Management

The app uses GetX for reactive state management:

```dart
// Accessing controllers
final authController = Get.find<AuthController>();

// Reactive variables
Obx(() => Text(authController.userName.value))

// Navigation
Get.toNamed('/rewards');
```

### Service Layer

Services handle business logic and Firebase operations:

```dart
// Services are singleton instances
final firestore = FirestoreService();
final loyalty = LoyaltyService();

// Use in controllers
await _firestoreService.createLoyaltyCard(card);
```

### Models

All models include:
- `toJson()` - Serialize to JSON for Firestore
- `fromJson()` - Deserialize from Firestore
- `copyWith()` - Immutable updates

```dart
final card = LoyaltyCard.fromJson(firestoreData);
final updated = card.copyWith(currentPoints: 100);
```

## Key Workflows

### User Registration Flow

1. User enters email, password, name
2. `AuthController.registerWithEmail()` called
3. FirebaseAuth creates user
4. `FirestoreService` creates customer document
5. User redirected to home screen

### Adding Loyalty Card

1. User browses restaurants
2. Selects restaurant to add card
3. `LoyaltyController.createLoyaltyCard()` called
4. Card created in Firestore
5. Card appears in user's card list

### Earning Points

1. QR code scanned at restaurant
2. `QrService.parseQrCode()` extracts card ID
3. Points calculated via `LoyaltyService`
4. `LoyaltyController.updateCardPoints()` updates Firestore
5. Transaction logged in database

### Redeeming Rewards

1. User selects reward from list
2. Checks if sufficient points available
3. `LoyaltyController.updateCardPoints()` deducts points
4. Transaction recorded with reward ID
5. Reward marked as claimed

## Firestore Database Schema

```
/customers/{userId}
  - email: string
  - firstName: string
  - lastName: string
  - phoneNumber: string
  - createdAt: timestamp
  - profileImageUrl: string
  - preferences: map
  - favoriteRestaurants: array

/loyalty_cards/{cardId}
  - userId: string
  - restaurantId: string
  - restaurantName: string
  - cardNumber: string
  - currentPoints: int
  - totalPointsEarned: int
  - createdAt: timestamp
  - isActive: boolean
  - qrCode: string

/rewards/{rewardId}
  - restaurantId: string
  - title: string
  - description: string
  - pointsRequired: int
  - isAvailable: boolean
  - createdAt: timestamp

/transactions/{transactionId}
  - cardId: string
  - userId: string
  - type: string (earn|redeem|expire|adjust)
  - pointsAmount: int
  - timestamp: timestamp
  - description: string

/restaurants/{restaurantId}
  - name: string
  - description: string
  - category: string
  - address: string
  - location: geopoint
  - isActive: boolean
```

## API Reference

### AuthController

```dart
// Authentication
Future<bool> registerWithEmail({...})
Future<bool> signInWithEmail({...})
Future<void> signOut()
Future<bool> sendPasswordResetEmail(String email)
Future<bool> updatePassword(String newPassword)
```

### LoyaltyController

```dart
// Card management
Future<void> getUserLoyaltyCards(String userId)
Future<bool> createLoyaltyCard({...})
Future<bool> updateCardPoints({...})

// Rewards
Future<void> getRestaurantRewards(String restaurantId)
Future<void> loadCardTransactions(String cardId)

// Utilities
int getTotalPoints()
String? getSelectedCardTier()
double? getSelectedCardTierProgress()
```

### QrController

```dart
// QR operations
String generateQrCode({...})
Future<void> processScannedCode(String code)
bool isValidQrCode(String code)
Map<String, String>? parseQrCode(String code)
void toggleTorch()
```

### LoyaltyService

```dart
// Points calculation
int calculatePointsFromAmount(double amount, ...)
String generateCardNumber(String restaurantPrefix)

// Tiers
String getPointsTier(int totalPointsEarned)
double getTierProgressPercentage(int totalPointsEarned)
int getNextTierThreshold(int totalPointsEarned)

// Utilities
DateTime calculateExpiryDate({...})
String formatPoints(int points)
String getExpiryStatusText(DateTime? expiryDate)
```

## Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test
flutter test test/loyalty_service_test.dart
```

## Build & Deployment

### iOS Build

```bash
flutter build ios
open build/ios/workspace/Runner.xcworkspace
```

### Android Build

```bash
# Debug
flutter build apk

# Release
flutter build appbundle
```

## Environment Variables

Create `.env` file in project root (optional):

```
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_API_KEY=your_api_key
```

## Troubleshooting

### Common Issues

1. **Firebase initialization fails**
   - Check `firebase_options.dart` is properly configured
   - Verify internet connectivity
   - Check Firebase credentials

2. **Firestore rules rejection**
   - Review Firestore rules in firebase_setup_guide.md
   - Ensure user is authenticated
   - Check request has proper auth uid

3. **QR code scanning not working**
   - Verify camera permission granted
   - Check mobile_scanner version compatibility
   - Test with different QR codes

4. **Points not updating**
   - Verify Firestore write operations succeed
   - Check currentPoints is not negative
   - Verify user has valid card

### Debug Mode

Enable debug logging:

```dart
// In main.dart
if (kDebugMode) {
  FirebaseFirestore.instance.settings = 
    Settings(
      persistenceEnabled: true,
      experimentalForceLongPolling: true,
    );
}
```

## Performance Optimization

- **Lazy loading**: Load loyalty cards on demand
- **Caching**: Use SharedPreferences for user preferences
- **Pagination**: Fetch transactions in batches
- **Image caching**: Use cached_network_image package

## Security Best Practices

✅ **Implemented:**
- Firebase Security Rules
- Email verification
- Password hashing (Firebase handles)
- Null safety throughout
- Input validation

📋 **Recommended:**
- Implement rate limiting
- Add two-factor authentication
- Encrypt sensitive local data
- Regular security audits
- Use app signing certificates

## Contributing

1. Create feature branch: `git checkout -b feature/name`
2. Commit changes: `git commit -am 'Add feature'`
3. Push to branch: `git push origin feature/name`
4. Submit pull request

## Code Style

- Follow Dart style guide
- Use meaningful variable names
- Add documentation comments
- Keep methods focused and small
- Use const constructors where possible

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [GetX Documentation](https://github.com/jonataslaw/getx)
- [Firebase Flutter Setup](https://firebase.flutter.dev)
- [Material Design 3](https://m3.material.io)

## Support & Issues

- Create issues on GitHub
- Include reproducible example
- Provide environment details
- Attach relevant error logs

## License

This project is licensed under the MIT License - see LICENSE file for details.

## Changelog

### Version 1.0.0 (Initial Release)
- User authentication
- Loyalty card management
- QR code scanning
- Rewards system
- Transaction history
- Profile management

---

**Built with ❤️ using Flutter, GetX, and Firebase**
