# 🎯 WalletRewards – Loyalty Made Simple

A modern Flutter application that enables restaurants to create and manage loyalty programs using digital wallet integration, location-based services, and AI-powered personalization.

## ✨ Features

### 1. Customer Journey

#### Step 1-2: Restaurant Setup & QR Generation
- Restaurants create loyalty campaigns with custom point rules
- Auto-generated unique QR codes for each restaurant

#### Step 3-4: Customer Enrollment
- QR code scanning (via camera)
- One-click Add to Apple Wallet / Google Wallet
- No app download required initially

#### Step 5-6: Points Earning
- Automatic point tracking on visits
- Real-time point updates
- Multiple earning methods (staff scan or customer scan)

#### Step 7-8: Reward Tracking & Redemption
- Live points display on wallet card
- Instant reward redemption
- Unique redemption codes

#### Step 9-10: Smart Notifications
- Location-based welcome messages (within 500m)
- Re-engagement campaigns (30-day idle detection)
- Personalized offers

#### Step 11: Referral Program
- Customer referral links
- Automatic bonus points distribution
- Viral growth mechanics

#### Step 12-13: Analytics & AI
- Restaurant dashboard for customer insights
- Automated offer generation based on:
  - Frequent visitors (10+ visits in 90 days)
  - Idle customers (no visit for 30 days)
  - High spenders (500+ points)

## 🏗️ Architecture

### Tech Stack
- **Frontend**: Flutter (GetX for state management)
- **Backend**: Firebase (Firestore, Auth, Messaging)
- **Location**: Geolocator (real-time tracking)
- **QR Code**: qr_flutter & mobile_scanner
- **Wallet**: walletkit (Apple/Google Wallet integration)
- **Notifications**: Firebase Messaging + Local Notifications

### Project Structure

```
lib/
├── main.dart                 # App initialization
├── firebase_options.dart     # Firebase configuration
├── models/                   # Data models
│   ├── user_model.dart
│   ├── restaurant_model.dart
│   ├── loyalty_card_model.dart
│   ├── referral_notification_model.dart
│   └── index.dart
├── services/                 # Business logic
│   ├── auth_service.dart
│   ├── firebase_service.dart
│   ├── location_service.dart
│   ├── notification_service.dart
│   └── index.dart
├── controllers/              # GetX state management
│   ├── app_controller.dart
│   ├── auth_controller.dart
│   ├── loyalty_card_controller.dart
│   ├── restaurant_controller.dart
│   └── upload_controller.dart (legacy)
├── screens/                  # UI screens
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── restaurants_screen.dart
│   ├── loyalty_cards_screen.dart
│   ├── restaurant_detail_screen.dart
│   └── auth/
│       ├── login_screen.dart
│       └── signup_screen.dart
├── theme/                    # Styling
│   └── app_colors.dart
├── views/                    # Legacy visa checker screens
└── widgets/                  # Reusable components
```

## 🗄️ Database Schema (Firestore)

### Collections

#### `users`
```json
{
  "id": "user_uid",
  "email": "user@example.com",
  "phone": "+44123456789",
  "name": "John Doe",
  "totalPoints": 350,
  "enrolledRestaurants": ["rest_1", "rest_2"],
  "redeemedRewards": ["reward_1"],
  "createdAt": "2026-01-15T10:30:00Z",
  "lastActivity": "2026-06-02T15:45:00Z",
  "referralCode": "JOHN8F2K"
}
```

#### `campaigns`
```json
{
  "id": "campaign_123",
  "restaurantId": "rest_1",
  "restaurantName": "The Burger Place",
  "description": "Loyalty program for burger lovers",
  "latitude": 51.5074,
  "longitude": -0.1278,
  "address": "123 Oxford St, London",
  "pointsPerVisit": 10,
  "rewards": [...],
  "qrCodeUrl": "https://...",
  "createdAt": "2025-12-01T00:00:00Z",
  "isActive": true
}
```

#### `loyalty_cards`
```json
{
  "id": "card_456",
  "customerId": "user_uid",
  "restaurantId": "rest_1",
  "restaurantName": "The Burger Place",
  "currentPoints": 45,
  "transactions": [...],
  "redeemedRewards": [...],
  "enrolledAt": "2026-01-20T14:30:00Z",
  "lastPointsEarned": "2026-06-01T18:00:00Z",
  "barcode": "ABC123DEF456"
}
```

#### `notifications`
```json
{
  "id": "notif_789",
  "userId": "user_uid",
  "type": "location|re-engagement|reward|new_offer",
  "title": "Welcome back!",
  "body": "Get 10% off today",
  "createdAt": "2026-06-02T12:00:00Z",
  "isRead": false
}
```

#### `referral_programs`
```json
{
  "id": "ref_123",
  "referrerId": "user_uid",
  "referrerName": "John Doe",
  "referralCode": "JOHN8F2K",
  "redemptions": [...],
  "bonusPointsEarned": 300,
  "totalReferrals": 3,
  "createdAt": "2026-01-15T10:30:00Z"
}
```

#### `ai_generated_offers`
```json
{
  "id": "offer_456",
  "customerId": "user_uid",
  "restaurantId": "rest_1",
  "offerTitle": "Loyalty Reward",
  "offerDescription": "20% off on next visit",
  "reason": "frequently visits",
  "discountPercentage": 20,
  "pointsOffer": 0,
  "expiryDate": "2026-06-09T23:59:59Z",
  "createdAt": "2026-06-02T10:00:00Z",
  "isApplied": false
}
```

## 🚀 Getting Started

### Prerequisites
- Flutter 3.8.1+
- Dart 3.0+
- Firebase project setup
- iOS 12+ / Android 5.0+

### Installation

1. **Clone Repository**
```bash
git clone <repository-url>
cd wallet-rewards
```

2. **Install Dependencies**
```bash
flutter pub get
```

3. **Configure Firebase**
- Add your `google-services.json` (Android) to `android/app/`
- Add your `GoogleService-Info.plist` (iOS) to `ios/Runner/`
- Update `lib/firebase_options.dart` with your Firebase credentials

4. **Run the App**
```bash
flutter run
```

## 📱 Usage Guide

### For Customers

1. **Sign Up**
   - Register with email/phone
   - Auto-generated referral code

2. **Find Restaurants**
   - Browse nearby restaurants
   - Search by name/location
   - View loyalty program details

3. **Enroll in Programs**
   - Tap "Enroll Now"
   - Digital card auto-generated
   - Add to Apple/Google Wallet

4. **Earn Points**
   - Staff scans QR code or barcode
   - Points appear instantly
   - Real-time updates

5. **Redeem Rewards**
   - View available rewards
   - Tap "Redeem"
   - Get unique redemption code

### For Restaurants

1. **Create Campaign**
   - Set up loyalty program
   - Define rewards
   - Configure point values

2. **Promote**
   - Display QR code on tables/receipts
   - Share on social media
   - Link from website

3. **Manage**
   - View customer analytics
   - Track visit frequency
   - Send personalized offers

## 🔑 Key Implementation Details

### Location-Based Notifications
```dart
// Triggered when customer is within 500m
if (locationService.isNearRestaurant(restaurant)) {
  notificationService.sendLocationNotification(...);
}
```

### Re-engagement Campaigns
```dart
// Auto-triggered for customers with no visits in 30 days
List<LoyaltyCard> idle = appController.getReEngagementCandidates();
appController.triggerReEngagementCampaign();
```

### AI Offer Generation
```dart
// Automatically generates personalized offers based on:
// 1. Frequent visitor detection (10+ visits/90 days) → 20% off
// 2. Idle detection (30+ days no visit) → £5 off
// 3. High spender detection (500+ points) → Free appetizer
appController.generatePersonalizedOffers();
```

### Referral System
```dart
// When referred user joins:
// - Referrer gets 100 bonus points
// - New user gets 50 bonus points
// - Status changes from pending → completed
```

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Build for release
flutter build apk  # Android
flutter build ios  # iOS
```

## 📊 Analytics Events

- `user_signup` - New customer registration
- `restaurant_enrollment` - Customer joins loyalty program
- `points_earned` - Points added to card
- `reward_redeemed` - Reward claimed
- `referral_completed` - Referral bonus awarded
- `notification_sent` - Notification delivered
- `location_triggered` - Location notification sent

## 🔒 Security

- **Authentication**: Firebase Auth with email verification
- **Data**: Firestore security rules (users can only access their own data)
- **Transactions**: Atomic Firestore transactions for point operations
- **Location**: On-device GPS, no tracking after user opt-out

## 📈 Performance Optimizations

- Real-time listeners (instead of polling)
- Indexed Firestore queries
- Local caching with shared_preferences
- Lazy loading for large lists
- Image optimization and caching

## 🤝 Contributing

See CONTRIBUTING.md for contribution guidelines.

## 📄 License

This project is licensed under the MIT License - see LICENSE file for details.

## 👨‍💻 Author

**Avi Vaishnav**
- Flutter Developer | AI Product Builder
- Open to collaboration

## 📬 Support

For issues, feature requests, or questions, please open an issue on GitHub.

---

**Status**: MVP Development (Core features implemented)

**Next Phase**: QR scanning, Wallet integration, Restaurant dashboard
