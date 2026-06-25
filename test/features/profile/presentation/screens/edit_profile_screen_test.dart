import 'package:bloc_test/bloc_test.dart';
import 'package:flowery_rider_app/config/base_state/base_state.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/driver_profile_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/edit_profile_response_entity.dart';
import 'package:flowery_rider_app/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/edit_profile_view_model/edit_profile_state.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/edit_profile_view_model/edit_profile_view_model.dart';
import 'package:flowery_rider_app/features/profile/presentation/widgets/edit_profile_form_widget.dart';
import 'package:flowery_rider_app/features/profile/presentation/widgets/profile_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class MockEditProfileViewModel extends MockCubit<EditProfileState>
    implements EditProfileViewModel {}

void main() {
  late MockEditProfileViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockEditProfileViewModel();
    whenListen(
      mockViewModel,
      const Stream<EditProfileState>.empty(),
      initialState: const EditProfileState(),
    );
  });

  Widget buildSubject() {
    return MaterialApp(
      home: BlocProvider<EditProfileViewModel>.value(
        value: mockViewModel,
        child: const EditProfileView(),
      ),
    );
  }

  group('EditProfileScreen Widget Tests', () {
    testWidgets('renders ProfileAvatarWidget', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.byType(ProfileAvatarWidget), findsOneWidget);
    });

    testWidgets('renders EditProfileFormWidget', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.byType(EditProfileFormWidget), findsOneWidget);
    });

    testWidgets('renders at least four text form fields', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.byType(TextFormField), findsAtLeastNWidgets(4));
    });

    testWidgets('shows snackbar when editProfileState emits success', (
      tester,
    ) async {
      final successEntity = EditProfileResponseEntity(
        message: 'success',
        driver: const DriverProfileEntity(firstName: 'ali'),
      );

      whenListen(
        mockViewModel,
        Stream.fromIterable([
          EditProfileState(editProfileState: BaseState.success(successEntity)),
        ]),
        initialState: const EditProfileState(),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('shows snackbar when editProfileState emits error', (
      tester,
    ) async {
      whenListen(
        mockViewModel,
        Stream.fromIterable([
          EditProfileState(editProfileState: BaseState.error('Server Error')),
        ]),
        initialState: const EditProfileState(),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
