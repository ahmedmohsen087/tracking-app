import 'package:bloc_test/bloc_test.dart';
import 'package:flowery_rider_app/config/base_state/base_state.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flowery_rider_app/features/profile/presentation/screens/change_password_screen.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/change_password_view_model/change_password_events.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/change_password_view_model/change_password_state.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/change_password_view_model/change_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockChangePasswordViewModel extends MockCubit<ChangePasswordState>
    implements ChangePasswordViewModel {}

class _CapturingViewModel extends MockChangePasswordViewModel {
  final List<ChangePasswordEvent> capturedEvents = [];

  @override
  void doEvent(ChangePasswordEvent event) {
    capturedEvents.add(event);
  }
}

void main() {
  late _CapturingViewModel mockViewModel;
  late ChangePasswordState initialState;

  setUp(() {
    mockViewModel = _CapturingViewModel();
    initialState = const ChangePasswordState(
      changePasswordState: BaseState(),
      autoValidate: false,
    );
    when(mockViewModel.state).thenReturn(initialState);
    when(mockViewModel.stream).thenAnswer((_) => Stream.value(initialState));
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<ChangePasswordViewModel>.value(
        value: mockViewModel,
        child: const ChangePasswordScreen(),
      ),
    );
  }

  group('ChangePasswordView — initial render', () {
    testWidgets(
      'Should render AppBar title, 3 TextFormFields, and a disabled ElevatedButton',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.text(AppStrings.changePassword), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(3));
        final btn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(btn.onPressed, isNull);
      },
    );

    testWidgets('Should render all 3 password fields as obscured by default', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      for (int i = 0; i < 3; i++) {
        final tf = tester.widget<TextField>(
          find.descendant(
            of: find.byType(TextFormField).at(i),
            matching: find.byType(TextField),
          ),
        );
        expect(tf.obscureText, isTrue);
      }
    });
  });

  group('ChangePasswordView — password visibility toggle', () {
    testWidgets(
      'Should toggle obscureText on suffix icon tap for current password field',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        final fieldFinder = find.byType(TextFormField).at(0);
        final tfFinder = find.descendant(
          of: fieldFinder,
          matching: find.byType(TextField),
        );
        final iconBtnFinder = find.descendant(
          of: fieldFinder,
          matching: find.byType(IconButton),
        );

        expect(tester.widget<TextField>(tfFinder).obscureText, isTrue);
        await tester.tap(iconBtnFinder);
        await tester.pump();
        expect(tester.widget<TextField>(tfFinder).obscureText, isFalse);
      },
    );

    testWidgets(
      'Should toggle obscureText on suffix icon tap for new password field',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        final fieldFinder = find.byType(TextFormField).at(1);
        final tfFinder = find.descendant(
          of: fieldFinder,
          matching: find.byType(TextField),
        );
        final iconBtnFinder = find.descendant(
          of: fieldFinder,
          matching: find.byType(IconButton),
        );

        expect(tester.widget<TextField>(tfFinder).obscureText, isTrue);
        await tester.tap(iconBtnFinder);
        await tester.pump();
        expect(tester.widget<TextField>(tfFinder).obscureText, isFalse);
      },
    );

    testWidgets(
      'Should toggle obscureText on suffix icon tap for confirm password field',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        final fieldFinder = find.byType(TextFormField).at(2);
        final tfFinder = find.descendant(
          of: fieldFinder,
          matching: find.byType(TextField),
        );
        final iconBtnFinder = find.descendant(
          of: fieldFinder,
          matching: find.byType(IconButton),
        );

        expect(tester.widget<TextField>(tfFinder).obscureText, isTrue);
        await tester.tap(iconBtnFinder);
        await tester.pump();
        expect(tester.widget<TextField>(tfFinder).obscureText, isFalse);
      },
    );
  });

  group('ChangePasswordView — Update button enable/disable', () {
    testWidgets(
      'Should keep button disabled when only current password is filled',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.enterText(find.byType(TextFormField).at(0), 'Current123*');
        await tester.pumpAndSettle();

        final btn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(btn.onPressed, isNull);
      },
    );

    testWidgets('Should keep button disabled when two fields are filled', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.enterText(find.byType(TextFormField).at(0), 'Current123*');
      await tester.enterText(find.byType(TextFormField).at(1), 'NewPass123*');
      await tester.pumpAndSettle();

      final btn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(btn.onPressed, isNull);
    });

    testWidgets('Should enable button when all three fields are filled', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.enterText(find.byType(TextFormField).at(0), 'Current123*');
      await tester.enterText(find.byType(TextFormField).at(1), 'NewPass123*');
      await tester.enterText(find.byType(TextFormField).at(2), 'NewPass123*');
      await tester.pumpAndSettle();

      final btn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(btn.onPressed, isNotNull);
    });

    testWidgets(
      'Should disable button again when a field is cleared after being filled',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.enterText(find.byType(TextFormField).at(0), 'Current123*');
        await tester.enterText(find.byType(TextFormField).at(1), 'NewPass123*');
        await tester.enterText(find.byType(TextFormField).at(2), 'NewPass123*');
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextFormField).at(2), '');
        await tester.pumpAndSettle();

        final btn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(btn.onPressed, isNull);
      },
    );
  });

  group('ChangePasswordView — form submission', () {
    testWidgets(
      'Should dispatch EnableAutoValidateEvent then ChangePasswordRequestEvent on valid submit',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.enterText(
          find.byType(TextFormField).at(0),
          'ValidCurrent123*',
        );
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'ValidNew123*',
        );
        await tester.enterText(
          find.byType(TextFormField).at(2),
          'ValidNew123*',
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        expect(mockViewModel.capturedEvents.length, 2);
        expect(mockViewModel.capturedEvents[0], isA<EnableAutoValidateEvent>());
        expect(
          mockViewModel.capturedEvents[1],
          isA<ChangePasswordRequestEvent>(),
        );

        final reqEvent =
            mockViewModel.capturedEvents[1] as ChangePasswordRequestEvent;
        expect(reqEvent.password, 'ValidCurrent123*');
        expect(reqEvent.newPassword, 'ValidNew123*');
      },
    );

    testWidgets(
      'Should dispatch only EnableAutoValidateEvent when form is invalid',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        await tester.enterText(find.byType(TextFormField).at(0), 'weak');
        await tester.enterText(find.byType(TextFormField).at(1), 'weak');
        await tester.enterText(find.byType(TextFormField).at(2), 'weak');
        await tester.pumpAndSettle();

        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        expect(mockViewModel.capturedEvents.length, 1);
        expect(mockViewModel.capturedEvents[0], isA<EnableAutoValidateEvent>());
      },
    );
  });

  group('ChangePasswordView — loading state', () {
    testWidgets(
      'Should show CircularProgressIndicator and hide Update text when loading',
      (tester) async {
        final loadingState = ChangePasswordState(
          changePasswordState: BaseState.loading(),
          autoValidate: false,
        );
        when(mockViewModel.state).thenReturn(loadingState);
        when(
          mockViewModel.stream,
        ).thenAnswer((_) => Stream.value(loadingState));

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text(AppStrings.update), findsNothing);
      },
    );

    testWidgets(
      'Should disable button while loading even if all fields are filled',
      (tester) async {
        final loadingState = ChangePasswordState(
          changePasswordState: BaseState.loading(),
          autoValidate: false,
        );
        when(mockViewModel.state).thenReturn(loadingState);
        when(
          mockViewModel.stream,
        ).thenAnswer((_) => Stream.value(loadingState));

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.enterText(find.byType(TextFormField).at(0), 'Current123*');
        await tester.enterText(find.byType(TextFormField).at(1), 'NewPass123*');
        await tester.enterText(find.byType(TextFormField).at(2), 'NewPass123*');
        await tester.pumpAndSettle();

        final btn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(btn.onPressed, isNull);
      },
    );
  });

  group('ChangePasswordView — success state', () {
    testWidgets(
      'Should show success SnackBar with passwordUpdated message on success',
      (tester) async {
        const successData = ProfileResponseEntity(token: 'new_token');
        final successState = ChangePasswordState(
          changePasswordState: BaseState.success(successData),
          autoValidate: false,
        );

        when(mockViewModel.state).thenReturn(initialState);
        when(
          mockViewModel.stream,
        ).thenAnswer((_) => Stream.fromIterable([initialState, successState]));

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text(AppStrings.passwordUpdated), findsOneWidget);
      },
    );
  });

  group('ChangePasswordView — error state', () {
    testWidgets('Should show error SnackBar with error message on failure', (
      tester,
    ) async {
      final errorState = ChangePasswordState(
        changePasswordState: BaseState.error('Wrong password'),
        autoValidate: false,
      );

      when(mockViewModel.state).thenReturn(initialState);
      when(
        mockViewModel.stream,
      ).thenAnswer((_) => Stream.fromIterable([initialState, errorState]));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Wrong password'), findsOneWidget);
    });
  });
}
