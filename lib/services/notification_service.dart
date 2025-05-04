import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> alRecibirNotificacion(
    NotificationResponse notificationResponse,
  ) async {}

  static Future<void> init() async {
    tz_data.initializeTimeZones();

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    const DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidInitializationSettings,
          iOS: iOSInitializationSettings,
        );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: alRecibirNotificacion,
      onDidReceiveBackgroundNotificationResponse: alRecibirNotificacion,
    );

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();

      await androidImplementation.createNotificationChannel(
        const AndroidNotificationChannel(
          'alerta_channel',
          'Alerta',
          description: 'Canal para notificaciones de alertas',
          importance: Importance.high,
        ),
      );
    }
  }

  static Future<void> mostrarNotificacionInstantanea(
    String titulo,
    String cuerpo, {
    int id = 0,
  }) async {
    const NotificationDetails detallesPlataforma = NotificationDetails(
      android: AndroidNotificationDetails(
        "alerta_channel",
        "Alerta",
        channelDescription: 'Canal para notificaciones de alertas',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      titulo,
      cuerpo,
      detallesPlataforma,
    );
  }

  static Future<void> mostrarNotificacionAlertaMeteorologica(
    String nombreCiudad,
    String tipoAlerta,
    String descripcion, {
    int id = 0,
  }) async {
    await mostrarNotificacionInstantanea(
      '$tipoAlerta en $nombreCiudad',
      descripcion,
      id: id,
    );
  }
}
