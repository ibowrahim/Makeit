import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // Bildirim sistemini başlatır.
  Future<void> init() async {
    // Saat dilimi veritabanını yükle.
    tz.initializeTimeZones();

    // Telefonun gerçek saat dilimini al.
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));

    // Android bildirim simgesi olarak uygulama simgesini kullan.
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(settings: settings);
  }

  // Bildirim iznini kullanıcıdan ister.
  Future<void> requestPermissions() async {
    final android = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final notificationsEnabled =
        await android?.areNotificationsEnabled() ?? false;

    if (!notificationsEnabled) {
      await android?.requestNotificationsPermission();
    }

    final canScheduleExact =
        await android?.canScheduleExactNotifications() ?? false;

    if (!canScheduleExact) {
      await android?.requestExactAlarmsPermission();
    }
  }

  // Belirli tarih ve saatte bildirim planlar.
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    // Geçmişteki bir zamana bildirim planlanmasın.
    if (!scheduledDate.isAfter(DateTime.now())) {
      return;
    }

    final scheduledTime = tz.TZDateTime.from(scheduledDate, tz.local);

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'makeit_task_reminders',
        'Görev Hatırlatıcıları',
        channelDescription: 'MakeIt görevleri için zamanlanmış hatırlatıcılar',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    await _notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledTime,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // Belirli bir görevin bildirimini iptal eder.
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id: id);
  }
}
