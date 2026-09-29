import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import '../data/repositories/water_repository.dart';

class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _plugin.initialize(settings);

    final androidImpl = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.requestNotificationsPermission();
    await androidImpl?.requestExactAlarmsPermission();

    _initialized = true;
  }

  Future<void> showTestNotification() async {
    await _plugin.show(
      9999,
      'تذكير شرب الماء 💧',
      'حان وقت شرب كوب من الماء!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'water_reminder_channel',
          'Water Reminders',
          channelDescription: 'تذكيرات دورية لشرب الماء',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  Future<void> scheduleReminders(ReminderSettings settings) async {
    await cancelAll();
    if (!settings.enabled) return;

    final now = tz.TZDateTime.now(tz.local);
    final startMinutes = settings.startHour * 60 + settings.startMinute;
    final endMinutes = settings.endHour * 60 + settings.endMinute;

    if (endMinutes <= startMinutes) return;

    int id = 0;
    for (int m = startMinutes; m <= endMinutes; m += settings.intervalMinutes) {
      final hour = m ~/ 60;
      final minute = m % 60;

      var scheduled = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, hour, minute,
      );
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      await _plugin.zonedSchedule(
        id,
        'تذكير شرب الماء 💧',
        'حان وقت شرب كوب من الماء!',
        scheduled,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'water_reminder_channel',
            'Water Reminders',
            channelDescription: 'تذكيرات دورية لشرب الماء',
            importance: Importance.max,
            priority: Priority.high,
            playSound: settings.soundEnabled,
            enableVibration: settings.vibrationEnabled,
          ),
          iOS: DarwinNotificationDetails(
            presentSound: settings.soundEnabled,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );

      id++;
    }
  }
}
