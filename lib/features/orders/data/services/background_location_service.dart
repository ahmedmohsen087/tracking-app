import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';

class BackgroundLocationService {
  static Future<void> initialize() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      const channel = AndroidNotificationChannel(
        'flowery_location_channel',
        'Location Tracking',
        description: 'Used for live delivery location tracking',
        importance: Importance.low,
      );
      await FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: _onStart,
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: 'flowery_location_channel',
        initialNotificationTitle: 'Flowery Rider',
        initialNotificationContent: 'Tracking your delivery location',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: _onStart,
        onBackground: _onIosBackground,
      ),
    );
  }

  @pragma('vm:entry-point')
  static Future<bool> _onIosBackground(ServiceInstance service) async {
    return true;
  }

  @pragma('vm:entry-point')
  static void _onStart(ServiceInstance service) {
    const settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    Geolocator.getPositionStream(locationSettings: settings).listen((position) {
      service.invoke('location', {
        'lat': position.latitude,
        'lng': position.longitude,
      });
    });
    service.on('stop').listen((_) => service.stopSelf());
  }

  static Future<void> start() async {
    await FlutterBackgroundService().startService();
  }

  static Future<void> stop() async {
    FlutterBackgroundService().invoke('stop');
  }
}
