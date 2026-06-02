# Firebase Setup Guide for WalletRewards App

This guide will walk you through setting up Firebase for the WalletRewards Flutter application on both iOS and Android platforms.

## Prerequisites

- Flutter SDK installed (version 3.8.1 or higher)
- Firebase project created at [Firebase Console](https://console.firebase.google.com)
- Xcode (for iOS) or Android Studio (for Android)
- CocoaPods (for iOS)

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click **Create a project**
3. Enter project name: `WalletRewards`
4. Accept the Firebase terms and click **Continue**
5. Enable Google Analytics (optional) and click **Create project**
6. Wait for the project to be created

## Step 2: Add Android App

### 2.1 Register Android App

1. In Firebase Console, click the **Android** icon
2. Enter package name: `com.walletrewards.app`
3. Enter app nickname: `WalletRewards Android`
4. Click **Register app**

### 2.2 Download google-services.json

1. Download the `google-services.json` file
2. Move it to `android/app/` directory in your Flutter project
3. Verify the file is at: `android/app/google-services.json`

### 2.3 Configure Android Gradle Files

1. In `android/build.gradle`, add Google services dependency:
```gradle
buildscript {
  dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
  }
}
```

2. In `android/app/build.gradle`, apply the plugin:
```gradle
apply plugin: 'com.google.gms.google-services'
```

3. Update minSdkVersion to 21 in `android/app/build.gradle`:
```gradle
minSdkVersion 21
```

### 2.4 Enable Android APIs

1. In Firebase Console, go to **Authentication**
2. Click **Get started**
3. Enable **Email/Password** sign-in method
4. Go to **Firestore Database**
5. Click **Create database** and start in test mode
6. Choose region and click **Create**
7. Go to **Storage**
8. Click **Get started** and start in test mode

## Step 3: Add iOS App

### 3.1 Register iOS App

1. In Firebase Console, click the **iOS** icon
2. Enter bundle ID: `com.walletrewards.app`
3. Enter app nickname: `WalletRewards iOS`
4. Click **Register app**

### 3.2 Download GoogleService-Info.plist

1. Download the `GoogleService-Info.plist` file
2. Open Xcode: `open ios/Runner.xcworkspace`
3. In Xcode, right-click **Runner** and select **Add Files to "Runner"**
4. Select the downloaded `GoogleService-Info.plist` file
5. Make sure **Copy items if needed** is checked
6. Click **Add**

### 3.3 Update iOS Minimum Version

1. In `ios/Podfile`, set platform minimum version:
```ruby
platform :ios, '12.0'
```

2. In Xcode, select **Runner** project
3. Select **Runner** target
4. Go to **Build Settings**
5. Search for "Minimum Deployments" and set to **12.0**

### 3.4 Update iOS Build Settings

1. In `ios/Podfile`, add after `post_install` hook:
```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'PERMISSION_CAMERA=1',
        'PERMISSION_LOCATION=1',
      ]
    end
  end
end
```

2. Add camera and location permissions to `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to scan QR codes</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to find nearby restaurants</string>
```

## Step 4: Configure Firestore Security Rules

1. In Firebase Console, go to **Firestore Database**
2. Click **Rules** tab
3. Replace with the following rules:

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own documents
    match /customers/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    
    // Loyalty cards - users can read their own
    match /loyalty_cards/{cardId} {
      allow read: if request.auth.uid == resource.data.userId;
      allow write: if request.auth.uid == resource.data.userId;
    }
    
    // Transactions - read only for user's own
    match /transactions/{transactionId} {
      allow read: if request.auth.uid == resource.data.userId;
    }
    
    // Rewards - anyone can read active rewards
    match /rewards/{rewardId} {
      allow read: if resource.data.isAvailable == true;
    }
    
    // Restaurants - anyone can read active restaurants
    match /restaurants/{restaurantId} {
      allow read: if resource.data.isActive == true;
    }
  }
}
```

4. Click **Publish**

## Step 5: Configure Firebase Authentication

1. Go to **Authentication** > **Sign-in method**
2. Enable the following providers:
   - **Email/Password**: Enable email enumeration protection
   - (Optional) **Google**: Download SHA-1 and SHA-256 from Android Studio

### For Google Sign-in on Android:

1. In Android Studio, go to **Tools** > **Android** > **Generate Signed Bundle / APK**
2. Create a new keystore or use existing
3. Click **Finish** to get SHA-1 and SHA-256
4. Add these fingerprints to Firebase Console under Android app settings

## Step 6: Configure Cloud Storage

1. Go to **Storage** > **Rules**
2. Replace with the following rules:

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Profile images - users can read/write their own
    match /profile_images/{userId}/{allPaths=**} {
      allow read: if request.auth.uid == userId || true;
      allow write: if request.auth.uid == userId;
    }
    
    // Restaurant images - admins only
    match /restaurant_images/{allPaths=**} {
      allow read: if true;
      allow write: if false;
    }
  }
}
```

3. Click **Publish**

## Step 7: Enable Required Firebase Services

1. Go to **APIs & Services** in Google Cloud Console
2. Enable these APIs:
   - Cloud Firestore API
   - Cloud Storage API
   - Firebase Authentication API
   - Firebase Realtime Database API (optional)

## Step 8: Test Firebase Connection

1. Run the app: `flutter run`
2. Try creating an account
3. Verify data appears in Firebase Console:
   - Check **Firestore Database** for new customer documents
   - Check **Authentication** for new users

## Troubleshooting

### iOS Issues

- **Pod install errors**: Run `cd ios && pod repo update && pod install && cd ..`
- **Build errors**: Clean build folder (Shift + Cmd + K) and rebuild
- **Permission issues**: Check `Info.plist` has required permissions

### Android Issues

- **google-services.json not found**: Verify file is in `android/app/` directory
- **Gradle sync errors**: Invalidate caches and restart Android Studio
- **minSdkVersion error**: Update to 21 or higher in `android/app/build.gradle`

### Firebase Connection Issues

- **Authentication errors**: Check security rules in Firestore Console
- **Data not saving**: Verify Firestore database is in test mode or rules allow write
- **Cold start issues**: Clear app cache: `flutter clean && flutter pub get`

## Next Steps

1. Set up Cloud Functions for backend logic (optional)
2. Configure push notifications (optional)
3. Set up Analytics tracking (optional)
4. Create backend admin panel for managing restaurants and rewards

## Additional Resources

- [Firebase Flutter Setup](https://firebase.flutter.dev/docs/overview)
- [Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Firebase Authentication](https://firebase.google.com/docs/auth)
- [Cloud Storage Guide](https://firebase.google.com/docs/storage)

## Support

For issues or questions:
1. Check [Firebase Status Page](https://status.firebase.google.com/)
2. Review [Firebase Console Logs](https://console.firebase.google.com)
3. Check [Flutter Firebase Issues](https://github.com/FirebaseExtended/flutterfire/issues)
