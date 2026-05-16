import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
    );
  }

  static Future<void> scheduleOrderReminder({
    required int orderId,
    required String partyName,
    required double pendingAmount,
    required int days,
    required String lang,
  }) async {
    final scheduledDate = tz.TZDateTime.now(tz.local).add(Duration(days: days));
    
    // Customize message based on language
    String title = 'Payment Reminder';
    String body = 'Payment of ₹$pendingAmount is pending from $partyName.';
    
    if (lang == 'hi') {
      title = 'भुगतान अनुस्मारक';
      body = '₹$pendingAmount का भुगतान $partyName से लंबित है।';
    } else if (lang == 'gu') {
      title = 'ચુકવણી રીમાઇન્ડર';
      body = '₹$pendingAmount ની ચુકવણી $partyName પાસેથી બાકી છે.';
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'order_reminders',
      'Order Reminders',
      channelDescription: 'Notifications for pending payments',
      importance: Importance.max,
      priority: Priority.high,
    );
    
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.zonedSchedule(
      id: orderId,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: orderId.toString(),
    );
  }

  static Future<void> cancelReminder(int orderId) async {
    await _notificationsPlugin.cancel(id: orderId);
  }
}
