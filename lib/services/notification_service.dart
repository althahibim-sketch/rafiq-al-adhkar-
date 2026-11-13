import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String channelId = 'adhkar_daily_channel';
  static const String channelName = 'تذكير الأذكار اليومية';
  static const String channelDescription =
      'إشعارات وتنبيهات أذكار الصباح والمساء والورد اليومي';

  Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (details) {
        // يمكن فتح شاشة محددة عند النقر على الإشعار
      },
    );

    // إنشاء قناة الإشعارات بنغمة واهتزاز وأولوية قصوى
    const androidChannel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // طلب صلاحية الإشعارات لنظام أندرويد 13+
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  /// إرسال إشعار تجريبي فوري لسماع النغمة والتأكد من ظهور التنبيه
  Future<void> showTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      ticker: 'تذكير أذكار اليوم',
    );

    const details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      id: 999,
      title: 'رفيق الأذكار • حان وقت ذكر الله',
      body: '﴿أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ﴾ • ابدأ وردك الآن.',
      notificationDetails: details,
    );
  }

  /// إشعار أذكار الصباح
  Future<void> showMorningNotification() async {
    const androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      id: 1001,
      title: 'أذكار الصباح ☀️',
      body: 'أصبحنا وأصبح الملك لله • ابدأ يومك بذكر الله وحفظه.',
      notificationDetails: details,
    );
  }

  /// إشعار أذكار المساء
  Future<void> showEveningNotification() async {
    const androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      id: 1002,
      title: 'أذكار المساء 🌙',
      body: 'أمسينا وأمسى الملك لله • حصّن نفسك بأذكار المساء.',
      notificationDetails: details,
    );
  }
}
