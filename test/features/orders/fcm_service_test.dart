import 'dart:convert';

import 'package:flowery_rider_app/config/firebase/fcm_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fcm_service_test.mocks.dart';

class _TestFcmService extends FcmService {
  _TestFcmService({required http.Client httpClient})
      : super(httpClient: httpClient);

  @override
  Future<String> getAccessToken() async => 'test-bearer-token';
}

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;
  late _TestFcmService fcmService;

  const fcmUrl =
      'https://fcm.googleapis.com/v1/projects/flowers-app-8f846/messages:send';

  setUp(() {
    mockClient = MockClient();
    fcmService = _TestFcmService(httpClient: mockClient);
  });

  void stubSuccess() {
    when(
      mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      ),
    ).thenAnswer(
      (_) async => http.Response('{"name":"projects/flowers-app-8f846/messages/123"}', 200),
    );
  }

  test('sendNotification sends Arabic title/body when language is "ar"',
      () async {
    stubSuccess();

    await fcmService.sendNotification(
      fcmToken: 'device-token',
      titleEn: 'English Title',
      titleAr: 'عنوان عربي',
      bodyEn: 'English body',
      bodyAr: 'نص عربي',
      language: 'ar',
      data: {'orderId': 'order1'},
    );

    final captured = verify(
      mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: captureAnyNamed('body'),
      ),
    ).captured;

    final body = json.decode(captured.first as String) as Map<String, dynamic>;
    final notification =
        (body['message'] as Map)['notification'] as Map<String, dynamic>;

    expect(notification['title'], 'عنوان عربي');
    expect(notification['body'], 'نص عربي');
  });

  test('sendNotification sends English title/body when language is "en"',
      () async {
    stubSuccess();

    await fcmService.sendNotification(
      fcmToken: 'device-token',
      titleEn: 'English Title',
      titleAr: 'عنوان عربي',
      bodyEn: 'English body',
      bodyAr: 'نص عربي',
      language: 'en',
      data: {'orderId': 'order1'},
    );

    final captured = verify(
      mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: captureAnyNamed('body'),
      ),
    ).captured;

    final body = json.decode(captured.first as String) as Map<String, dynamic>;
    final notification =
        (body['message'] as Map)['notification'] as Map<String, dynamic>;

    expect(notification['title'], 'English Title');
    expect(notification['body'], 'English body');
  });

  test('HTTP POST is called with the correct FCM URL', () async {
    stubSuccess();

    await fcmService.sendNotification(
      fcmToken: 'device-token',
      titleEn: 'T',
      titleAr: 'ت',
      bodyEn: 'B',
      bodyAr: 'ب',
      language: 'en',
      data: {},
    );

    final captured = verify(
      mockClient.post(
        captureAny,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      ),
    ).captured;

    expect((captured.first as Uri).toString(), fcmUrl);
  });

  test('HTTP POST includes Authorization Bearer header', () async {
    stubSuccess();

    await fcmService.sendNotification(
      fcmToken: 'device-token',
      titleEn: 'T',
      titleAr: 'ت',
      bodyEn: 'B',
      bodyAr: 'ب',
      language: 'en',
      data: {},
    );

    final captured = verify(
      mockClient.post(
        any,
        headers: captureAnyNamed('headers'),
        body: anyNamed('body'),
      ),
    ).captured;

    final headers = captured.first as Map<String, String>;
    expect(headers['Authorization'], 'Bearer test-bearer-token');
  });

  test('sendNotification throws when server returns non-200', () async {
    when(
      mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      ),
    ).thenAnswer((_) async => http.Response('Unauthorized', 401));

    expect(
      () => fcmService.sendNotification(
        fcmToken: 'device-token',
        titleEn: 'T',
        titleAr: 'ت',
        bodyEn: 'B',
        bodyAr: 'ب',
        language: 'en',
        data: {},
      ),
      throwsException,
    );
  });
}
