import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../models/index.dart';

class NotificationService extends GetxService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Request notification permission
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carryForward: true,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      _initLocalNotifications();
      _setupMessageHandlers();
    }
  }

  void _initLocalNotifications() {
    const InitializationSettings initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    _localNotifications.initialize(initSettings);
  }

  void _setupMessageHandlers() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessageClick(message);
    });
  }

  void _handleMessage(RemoteMessage message) {
    _showLocalNotification(
      title: message.notification?.title ?? 'Notification',
      body: message.notification?.body ?? '',
      data: message.data,
    );
  }

  void _handleMessageClick(RemoteMessage message) {
    // Handle notification click
    print('Notification clicked: ${message.data}');
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'wallet_rewards_channel',
      'WalletRewards Notifications',
      channelDescription: 'Notifications for WalletRewards app',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      DateTime.now().millisecond,
      title,
      body,
      notificationDetails,
      payload: data.toString(),
    );
  }

  /// Send location-based notification
  Future<void> sendLocationNotification({
    required String userId,
    required String restaurantName,
    required String message,
  }) async {
    Notification notification = Notification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      type: 'location',
      title: 'Welcome to $restaurantName',
      body: message,
      createdAt: DateTime.now(),
      imageUrl: null,
    );

    _showLocalNotification(
      title: notification.title,
      body: notification.body,
      data: {'type': 'location', 'restaurantName': restaurantName},
    );
  }

  /// Send re-engagement notification
  Future<void> sendReEngagementNotification({
    required String userId,
    required String restaurantName,
  }) async {
    Notification notification = Notification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      type: 're-engagement',
      title: 'We miss you at $restaurantName!',
      body: 'Visit soon and enjoy special offer.',
      createdAt: DateTime.now(),
      imageUrl: null,
    );

    _showLocalNotification(
      title: notification.title,
      body: notification.body,
      data: {'type': 're-engagement', 'restaurantName': restaurantName},
    );
  }

  /// Send reward notification
  Future<void> sendRewardNotification({
    required String userId,
    required String rewardTitle,
    required String message,
  }) async {
    Notification notification = Notification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      type: 'reward',
      title: 'Reward Ready!',
      body: message,
      createdAt: DateTime.now(),
      imageUrl: null,
    );

    _showLocalNotification(
      title: notification.title,
      body: notification.body,
      data: {'type': 'reward', 'rewardTitle': rewardTitle},
    );
  }

  /// Send offer notification
  Future<void> sendOfferNotification({
    required String userId,
    required String offerTitle,
    required String message,
  }) async {
    Notification notification = Notification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      type: 'new_offer',
      title: offerTitle,
      body: message,
      createdAt: DateTime.now(),
      imageUrl: null,
    );

    _showLocalNotification(
      title: notification.title,
      body: notification.body,
      data: {'type': 'new_offer', 'offerTitle': offerTitle},
    );
  }
}
