import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    var androidInitialize =
        const AndroidInitializationSettings("@mipmap/ic_launcher");

/// iOS: Request notification permissions
    DarwinInitializationSettings initializationSettingsIOS =
        const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
    AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }

  static Future showTextNotification({
    int id = 0,
    required String title,
    required String body,
    bool playSound = false,
    bool enableVibration = false,
    var payload,
    int progress=0,
  }) async {
await _checkAndAskNotification();
    AndroidNotificationDetails androidNotificationDetails =
         AndroidNotificationDetails(
      "default_value",
      "channel_id_5",
      playSound: playSound,
      importance: Importance.max,
      priority: Priority.max,
      showWhen: true,onlyAlertOnce: true,
      showProgress: true,
      enableVibration: enableVibration,
      progress: progress,
   
      maxProgress: 100,
    );

    DarwinNotificationDetails darwinInitializationDetails =
        const DarwinNotificationDetails(presentSound: false, presentAlert: false);

    var not = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinInitializationDetails,
    );
    await flutterLocalNotificationsPlugin.show(id, title, body, not);

  }
  static void cancleNotification(int id)async{
    await flutterLocalNotificationsPlugin.cancel(id);
  }

 static Future<void>_checkAndAskNotification()async{
    final isNotificationEnabled=await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
    AndroidFlutterLocalNotificationsPlugin>()?.areNotificationsEnabled();
    if(!(isNotificationEnabled??true)){
      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
    AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    }
  }
}