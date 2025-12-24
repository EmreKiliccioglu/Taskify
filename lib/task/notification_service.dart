/*import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    // Android 13+ izin
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('🔔 Notification permission: ${settings.authorizationStatus}');

    // TOKEN AL
    final token = await _messaging.getToken();

    if (token == null) {
      debugPrint('❌ FCM TOKEN NULL');
    } else {
      debugPrint('🔥 FCM TOKEN => $token');
    }

    // Token yenilenirse
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      debugPrint('♻️ FCM TOKEN REFRESH => $newToken');
    });
  }
}*/
