import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flowery_rider_app/config/base_state/base_state.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/profile_driver_entity.dart';
import 'package:flowery_rider_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/get_profile_view_model/get_profile_state.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/get_profile_view_model/get_profile_view_model.dart';
import 'package:flowery_rider_app/features/profile/presentation/widgets/personal_information_card.dart';
import 'package:flowery_rider_app/features/profile/presentation/widgets/vehicle_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetProfileViewModel extends MockCubit<GetProfileState>
    implements GetProfileViewModel {}

void main() {
  late MockGetProfileViewModel mockGetProfileViewModel;

  setUpAll(() {
    HttpOverrides.global = MyHttpOverrides();
  });

  setUp(() {
    mockGetProfileViewModel = MockGetProfileViewModel();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<GetProfileViewModel>.value(
        value: mockGetProfileViewModel,
        child: const ProfileScreen(),
      ),
    );
  }

  testWidgets(
    'displays CircularProgressIndicator when loading',
        (WidgetTester tester) async {
      const loadingState = GetProfileState(
        getProfileState: BaseState(
          isLoading: true,
        ),
      );

      whenListen(
        mockGetProfileViewModel,
        Stream.value(loadingState),
        initialState: loadingState,
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );



  testWidgets(
    'displays profile cards when data is loaded successfully',
        (WidgetTester tester) async {
      final driver = ProfileDriverEntity(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        phone: '1234567890',
        photo: 'https://placeholder.com/photo.jpg',
        vehicleType: 'Car',
        vehicleNumber: '123-ABC',
        vehicleLicense: 'XYZ-789',
        nid: '123456789',
        nidImg: 'https://placeholder.com/nid.jpg',
        gender: 'Male',
        country: 'USA',
        role: 'Driver',
        createdAt: DateTime.now(),
        id: '1',
      );

      final successState = GetProfileState(
        getProfileState: BaseState(
          isLoading: false,
          data: driver,
        ),
      );

      whenListen(
        mockGetProfileViewModel,
        Stream.value(successState),
        initialState: successState,
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(PersonalInformationCard), findsOneWidget);
      expect(find.byType(VehicleInfoCard), findsOneWidget);

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john.doe@example.com'), findsOneWidget);
      expect(find.text('1234567890'), findsOneWidget);
    },
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return MyHttpClient();
  }
}

class MyHttpClient implements HttpClient {
  @override
  bool autoUncompress = false;

  @override
  String? userAgent;

  @override
  Duration? connectionTimeout;

  @override
  int? maxConnectionsPerHost;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return MyHttpClientRequest();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      super.noSuchMethod(invocation);
}

class MyHttpClientRequest implements HttpClientRequest {
  @override
  Future<HttpClientResponse> close() async {
    return MyHttpClientResponse();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      super.noSuchMethod(invocation);
}

class MyHttpClientResponse implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  int get contentLength => 1;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
      void Function(List<int> event)? onData, {
        Function? onError,
        void Function()? onDone,
        bool? cancelOnError,
      }) {
    final transparentPng = Uint8List.fromList([
      137,
      80,
      78,
      71,
      13,
      10,
      26,
      10,
      0,
      0,
      0,
      13,
      73,
      72,
      68,
      82,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      1,
      8,
      6,
      0,
      0,
      0,
      31,
      21,
      196,
      137,
      0,
      0,
      0,
      10,
      73,
      68,
      65,
      84,
      120,
      156,
      99,
      248,
      15,
      0,
      1,
      1,
      1,
      0,
      24,
      221,
      141,
      176,
      0,
      0,
      0,
      0,
      73,
      69,
      78,
      68,
      174,
      66,
      96,
      130,
    ]);

    return Stream<List<int>>.fromIterable([transparentPng]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      super.noSuchMethod(invocation);
}