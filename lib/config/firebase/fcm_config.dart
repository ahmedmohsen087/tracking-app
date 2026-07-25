import 'package:flowery_rider_app/core/values/order_status.dart';

abstract class FcmConfig {
  static const String projectId = 'flowers-app-8f846';
  static const String fcmEndpoint =
      'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';
  static const String serviceAccountAsset =
      'assets/files/firebase_service_account.json';
  static const String fcmScope =
      'https://www.googleapis.com/auth/firebase.messaging';

  static const Map<String, Map<String, String>> orderStatusMessages = {
    OrderStatus.accepted: {
      'title_en': 'Order Received!',
      'title_ar': 'تم استلام طلبك!',
      'body_en': 'Your order has been accepted by the driver.',
      'body_ar': 'تم قبول طلبك من قِبل السائق.',
    },
    OrderStatus.arrivedPickup: {
      'title_en': 'Preparing Your Order',
      'title_ar': 'جارٍ تجهيز طلبك',
      'body_en': 'Driver arrived at the store.',
      'body_ar': 'وصل السائق إلى المتجر.',
    },
    OrderStatus.outForDelivery: {
      'title_en': 'Out for Delivery',
      'title_ar': 'طلبك في الطريق إليك',
      'body_en': 'Your order is on the way!',
      'body_ar': 'طلبك في الطريق إليك!',
    },
    OrderStatus.arrivedUser: {
      'title_en': 'Driver Has Arrived!',
      'title_ar': 'وصل السائق!',
      'body_en': 'Your driver is at your location.',
      'body_ar': 'السائق وصل إلى موقعك.',
    },
    OrderStatus.delivered: {
      'title_en': 'Order Delivered ✓',
      'title_ar': 'تم توصيل طلبك ✓',
      'body_en': 'Your order has been delivered successfully.',
      'body_ar': 'تم توصيل طلبك بنجاح.',
    },
  };
}
