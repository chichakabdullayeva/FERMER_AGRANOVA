import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    final service = NotificationService();
    await service._requestPermissions();
    service._configureForegroundMessages();
  }

  Future<void> _requestPermissions() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _configureForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        // This listener keeps the app ready for incoming push notifications.
        // TODO: Show a local alert or in-app banner for production.
        // ignore: avoid_print
        print('Received foreground notification: ${message.notification!.title} - ${message.notification!.body}');
      }
    });
  }
}
