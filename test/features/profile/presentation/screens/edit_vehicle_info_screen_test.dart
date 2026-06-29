import 'package:bloc_test/bloc_test.dart';
import 'package:flowery_rider_app/config/base_state/base_state.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/vehicle_info_updated_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/vehicle_types_response_entity.dart';
import 'package:flowery_rider_app/features/profile/presentation/screens/edit_vehicle_info_screen.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/edit_vehicle_info_view_model/edit_vehicle_info_state.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/edit_vehicle_info_view_model/edit_vehicle_info_view_model.dart';
import 'package:flowery_rider_app/features/profile/presentation/widgets/edit_vehicle_info_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class MockEditVehicleInfoViewModel extends MockCubit<EditVehicleInfoState>
    implements EditVehicleInfoViewModel {}

void main() {
  late MockEditVehicleInfoViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockEditVehicleInfoViewModel();
    whenListen(
      mockViewModel,
      const Stream<EditVehicleInfoState>.empty(),
      initialState: const EditVehicleInfoState(),
    );
  });

  Widget buildSubject() {
    return MaterialApp(
      home: BlocProvider<EditVehicleInfoViewModel>.value(
        value: mockViewModel,
        child: const EditVehicleInfoView(),
      ),
    );
  }

  group('EditVehicleInfoScreen Widget Tests', () {
    testWidgets('renders EditVehicleInfoFormWidget when types loaded', (
      tester,
    ) async {
      whenListen(
        mockViewModel,
        const Stream<EditVehicleInfoState>.empty(),
        initialState: EditVehicleInfoState(
          getVehicleTypesState: BaseState.success(
            const VehicleTypesResponseEntity(message: 'success', vehicles: []),
          ),
        ),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.byType(EditVehicleInfoFormWidget), findsOneWidget);
    });

    testWidgets(
      'shows loading indicator when getVehicleTypesState is loading',
      (tester) async {
        whenListen(
          mockViewModel,
          const Stream<EditVehicleInfoState>.empty(),
          initialState: EditVehicleInfoState(
            getVehicleTypesState: BaseState.loading(),
          ),
        );

        await tester.pumpWidget(buildSubject());

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('shows snackbar when editVehicleInfoState emits success', (
      tester,
    ) async {
      final successEntity = VehicleInfoUpdatedEntity(
        vehicleTypeId: 'v123',
        vehicleNumber: 'NUM123',
        vehicleLicenseFileName: 'license.jpg',
      );

      whenListen(
        mockViewModel,
        Stream.fromIterable([
          EditVehicleInfoState(
            editVehicleInfoState: BaseState.success(successEntity),
            getVehicleTypesState: BaseState.success(
              const VehicleTypesResponseEntity(
                message: 'success',
                vehicles: [],
              ),
            ),
          ),
        ]),
        initialState: EditVehicleInfoState(
          getVehicleTypesState: BaseState.success(
            const VehicleTypesResponseEntity(message: 'success', vehicles: []),
          ),
        ),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('shows snackbar when editVehicleInfoState emits error', (
      tester,
    ) async {
      whenListen(
        mockViewModel,
        Stream.fromIterable([
          EditVehicleInfoState(
            editVehicleInfoState: BaseState.error('Server Error'),
            getVehicleTypesState: BaseState.success(
              const VehicleTypesResponseEntity(
                message: 'success',
                vehicles: [],
              ),
            ),
          ),
        ]),
        initialState: EditVehicleInfoState(
          getVehicleTypesState: BaseState.success(
            const VehicleTypesResponseEntity(message: 'success', vehicles: []),
          ),
        ),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
