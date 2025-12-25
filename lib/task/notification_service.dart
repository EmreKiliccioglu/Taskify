import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Android bildirim ayarları
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    //await _notifications.initialize(settings);

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        print("Bildirim tıklandı veya gösterildi: ${details.id}");
        // Burada UI güncellemesi veya navigasyon yapılabilir
      },
    );

    // Android 13+ izin kontrolü
    final androidImplementation = _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      final isAllowed = await androidImplementation.areNotificationsEnabled() ?? false;
      if (!isAllowed) {
        print('Bildirim izni verilmemiş!');
      }
    }

    // Timezone initialization
    tz.initializeTimeZones();

    // Device timezone logları
    final deviceTimeZoneName = DateTime.now().timeZoneName;
    print("Device timezone name: $deviceTimeZoneName");
    print("Device timezone offset: ${DateTime.now().timeZoneOffset}");
    print("tz.local before setting: ${tz.local.name}");

    try {
      // Türkiye saat dilimi (Europe/Istanbul) olarak zorla
      final istanbul = tz.getLocation('Europe/Istanbul');
      tz.setLocalLocation(istanbul);
      print("tz.local set to: ${tz.local.name}");
    } catch (e) {
      print("Failed to set tz.local: $e");
    }
  }

  /// Planlı bildirimflutter build apk --release
  static Future<void> scheduleTaskNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);
    print("Scheduled notification (TZ): $tzScheduledTime");

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tzScheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel',
          'Task Notifications',
          channelDescription: 'Reminder for your tasks',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }
}
