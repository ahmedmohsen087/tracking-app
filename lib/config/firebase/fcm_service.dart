import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@lazySingleton
class FcmService {
  static const _projectId = 'flowers-app-8f846';
  static const _fcmEndpoint =
      'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send';
  static const _serviceAccountAsset =
      'assets/files/firebase_service_account.json';
  static const _fcmScope = 'https://www.googleapis.com/auth/firebase.messaging';

  final http.Client _httpClient;

  FcmService() : _httpClient = http.Client();
  
  @visibleForTesting
  FcmService.withClient(http.Client client) : _httpClient = client;

  static const Map<String, Map<String, String>> orderStatusMessages = {
    'accepted': {
      'title_en': 'Order Received!',
      'title_ar': 'تم استلام طلبك!',
      'body_en': 'Your order has been accepted by the driver.',
      'body_ar': 'تم قبول طلبك من قِبل السائق.',
    },
    'arrived_pickup': {
      'title_en': 'Preparing Your Order',
      'title_ar': 'جارٍ تجهيز طلبك',
      'body_en': 'Driver arrived at the store.',
      'body_ar': 'وصل السائق إلى المتجر.',
    },
    'out_for_delivery': {
      'title_en': 'Out for Delivery',
      'title_ar': 'طلبك في الطريق إليك',
      'body_en': 'Your order is on the way!',
      'body_ar': 'طلبك في الطريق إليك!',
    },
    'arrived_user': {
      'title_en': 'Driver Has Arrived!',
      'title_ar': 'وصل السائق!',
      'body_en': 'Your driver is at your location.',
      'body_ar': 'السائق وصل إلى موقعك.',
    },
    'delivered': {
      'title_en': 'Order Delivered ✓',
      'title_ar': 'تم توصيل طلبك ✓',
      'body_en': 'Your order has been delivered successfully.',
      'body_ar': 'تم توصيل طلبك بنجاح.',
    },
  };

  @visibleForTesting
  Future<String> getAccessToken() async {
    final jsonString = await rootBundle.loadString(_serviceAccountAsset);
    final credentials = ServiceAccountCredentials.fromJson(
      json.decode(jsonString) as Map<String, dynamic>,
    );
    final client = await clientViaServiceAccount(credentials, [_fcmScope]);
    final token = client.credentials.accessToken.data;
    client.close();
    return token;
  }

  Future<void> sendNotification({
    required String fcmToken,
    required String titleEn,
    required String titleAr,
    required String bodyEn,
    required String bodyAr,
    required String language,
    required Map<String, String> data,
  }) async {
    final accessToken = await getAccessToken();
    final title = language == 'ar' ? titleAr : titleEn;
    final body = language == 'ar' ? bodyAr : bodyEn;

    final payload = {
      'message': {
        'token': fcmToken,
        'notification': {'title': title, 'body': body},
        'data': data,
      },
    };

    final response = await _httpClient.post(
      Uri.parse(_fcmEndpoint),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(payload),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'FCM send failed [${response.statusCode}]: ${response.body}',
      );
    }
  }
}
