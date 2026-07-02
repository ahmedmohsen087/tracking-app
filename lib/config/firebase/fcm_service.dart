import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flowery_rider_app/config/firebase/fcm_config.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@lazySingleton
class FcmService {
  final http.Client _httpClient;

  FcmService() : _httpClient = http.Client();

  @visibleForTesting
  FcmService.withClient(http.Client client) : _httpClient = client;

  @visibleForTesting
  Future<String> getAccessToken() async {
    final jsonString = await rootBundle.loadString(
      FcmConfig.serviceAccountAsset,
    );
    final credentials = ServiceAccountCredentials.fromJson(
      json.decode(jsonString) as Map<String, dynamic>,
    );
    final client = await clientViaServiceAccount(credentials, [
      FcmConfig.fcmScope,
    ]);
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
      Uri.parse(FcmConfig.fcmEndpoint),
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
