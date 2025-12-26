import 'package:flutter/cupertino.dart';
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
        debugPrint("Bildirim tıklandı veya gösterildi: ${details.id}");
      },
    );

    //Android 13+ izin
    final androidImplementation = _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      final isAllowed = await androidImplementation.areNotificationsEnabled() ?? false;
      if (!isAllowed) {
        debugPrint('Bildirim izni verilmemiş!');
      }
    }

    // Timezone initialization
    tz.initializeTimeZones();

    final deviceTimeZoneName = DateTime.now().timeZoneName;
    debugPrint("Device timezone name: $deviceTimeZoneName");
    debugPrint("Device timezone offset: ${DateTime.now().timeZoneOffset}");
    debugPrint("tz.local before setting: ${tz.local.name}");

    try {
      final istanbul = tz.getLocation('Europe/Istanbul');
      tz.setLocalLocation(istanbul);
      debugPrint("tz.local set to: ${tz.local.name}");
    } catch (e) {
      debugPrint("Failed to set tz.local: $e");
    }
  }

  static Future<void> scheduleTaskNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);
    debugPrint("Scheduled notification (TZ): $tzScheduledTime");

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
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }
}
