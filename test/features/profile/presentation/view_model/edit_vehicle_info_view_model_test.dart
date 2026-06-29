import 'package:bloc_test/bloc_test.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/edit_vehicle_info_request_model.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/vehicle_info_updated_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/vehicle_types_response_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/use_cases/edit_vehicle_info_use_case.dart';
import 'package:flowery_rider_app/features/profile/domain/use_cases/get_vehicle_types_use_case.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/edit_vehicle_info_view_model/edit_vehicle_info_events.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/edit_vehicle_info_view_model/edit_vehicle_info_state.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/edit_vehicle_info_view_model/edit_vehicle_info_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'edit_vehicle_info_view_model_test.mocks.dart';

@GenerateMocks([GetVehicleTypesUseCase, EditVehicleInfoUseCase])
void main() {
  setUpAll(() {
    provideDummy<BaseResponse<VehicleTypesResponseEntity>>(
      SuccessBaseResponse<VehicleTypesResponseEntity>(
        data: const VehicleTypesResponseEntity(
          message: 'success',
          vehicles: [],
        ),
      ),
    );
    provideDummy<BaseResponse<VehicleInfoUpdatedEntity>>(
      SuccessBaseResponse<VehicleInfoUpdatedEntity>(
        data: const VehicleInfoUpdatedEntity(
          vehicleTypeId: 'v123',
          vehicleNumber: 'NUM123',
          vehicleLicenseFileName: 'license.jpg',
        ),
      ),
    );
  });

  late MockGetVehicleTypesUseCase mockGetVehicleTypesUseCase;
  late MockEditVehicleInfoUseCase mockEditVehicleInfoUseCase;
  late EditVehicleInfoViewModel sut;

  final tRequestModel = EditVehicleInfoRequestModel(
    vehicleTypeId: 'v123',
    vehicleNumber: 'NUM123',
    vehicleLicenseFilePath: '/path/license.jpg',
  );

  final tVehicleTypesResponseEntity = const VehicleTypesResponseEntity(
    message: 'success',
    vehicles: [],
  );

  final tVehicleInfoUpdatedEntity = const VehicleInfoUpdatedEntity(
    vehicleTypeId: 'v123',
    vehicleNumber: 'NUM123',
    vehicleLicenseFileName: 'license.jpg',
  );

  void stubGetVehicleTypesSuccess() {
    when(
      mockGetVehicleTypesUseCase.execute(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      ),
    ).thenAnswer(
      (_) async => SuccessBaseResponse<VehicleTypesResponseEntity>(
        data: tVehicleTypesResponseEntity,
      ),
    );
  }

  void stubGetVehicleTypesError(String message) {
    when(
      mockGetVehicleTypesUseCase.execute(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      ),
    ).thenAnswer(
      (_) async =>
          ErrorBaseResponse<VehicleTypesResponseEntity>(errorMessage: message),
    );
  }

  void stubEditVehicleInfoSuccess() {
    when(
      mockEditVehicleInfoUseCase.execute(
        requestModel: anyNamed('requestModel'),
      ),
    ).thenAnswer(
      (_) async => SuccessBaseResponse<VehicleInfoUpdatedEntity>(
        data: tVehicleInfoUpdatedEntity,
      ),
    );
  }

  void stubEditVehicleInfoError(String message) {
    when(
      mockEditVehicleInfoUseCase.execute(
        requestModel: anyNamed('requestModel'),
      ),
    ).thenAnswer(
      (_) async =>
          ErrorBaseResponse<VehicleInfoUpdatedEntity>(errorMessage: message),
    );
  }

  setUp(() {
    mockGetVehicleTypesUseCase = MockGetVehicleTypesUseCase();
    mockEditVehicleInfoUseCase = MockEditVehicleInfoUseCase();
    sut = EditVehicleInfoViewModel(
      mockGetVehicleTypesUseCase,
      mockEditVehicleInfoUseCase,
    );
  });

  tearDown(() => sut.close());

  group('Initial State', () {
    test('emits correct initial state on creation', () {
      expect(sut.state, const EditVehicleInfoState());
    });
  });

  group('GetVehicleTypesEvent', () {
    blocTest<EditVehicleInfoViewModel, EditVehicleInfoState>(
      'emits [loading, success] when get vehicle types use case succeeds',
      build: () {
        stubGetVehicleTypesSuccess();
        return sut;
      },
      act: (vm) => vm.doEvent(GetVehicleTypesEvent()),
      expect: () => [
        predicate<EditVehicleInfoState>(
          (s) => s.getVehicleTypesState.isLoading,
        ),
        predicate<EditVehicleInfoState>(
          (s) => s.getVehicleTypesState.data == tVehicleTypesResponseEntity,
        ),
      ],
      verify: (_) {
        verify(
          mockGetVehicleTypesUseCase.execute(
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockGetVehicleTypesUseCase);
      },
    );

    blocTest<EditVehicleInfoViewModel, EditVehicleInfoState>(
      'emits [loading, error] when get vehicle types use case fails',
      build: () {
        stubGetVehicleTypesError('Server Error');
        return sut;
      },
      act: (vm) => vm.doEvent(GetVehicleTypesEvent()),
      expect: () => [
        predicate<EditVehicleInfoState>(
          (s) => s.getVehicleTypesState.isLoading,
        ),
        predicate<EditVehicleInfoState>(
          (s) => s.getVehicleTypesState.msg == 'Server Error',
        ),
      ],
      verify: (_) {
        verify(
          mockGetVehicleTypesUseCase.execute(
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockGetVehicleTypesUseCase);
      },
    );
  });

  group('EditVehicleInfoSubmitEvent', () {
    blocTest<EditVehicleInfoViewModel, EditVehicleInfoState>(
      'emits [loading, success] when edit vehicle info use case succeeds',
      build: () {
        stubEditVehicleInfoSuccess();
        return sut;
      },
      act: (vm) =>
          vm.doEvent(EditVehicleInfoSubmitEvent(requestModel: tRequestModel)),
      expect: () => [
        predicate<EditVehicleInfoState>(
          (s) => s.editVehicleInfoState.isLoading,
        ),
        predicate<EditVehicleInfoState>(
          (s) => s.editVehicleInfoState.data == tVehicleInfoUpdatedEntity,
        ),
      ],
      verify: (_) {
        verify(
          mockEditVehicleInfoUseCase.execute(
            requestModel: anyNamed('requestModel'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockEditVehicleInfoUseCase);
      },
    );

    blocTest<EditVehicleInfoViewModel, EditVehicleInfoState>(
      'emits [loading, error] when edit vehicle info use case fails',
      build: () {
        stubEditVehicleInfoError('Update failed');
        return sut;
      },
      act: (vm) =>
          vm.doEvent(EditVehicleInfoSubmitEvent(requestModel: tRequestModel)),
      expect: () => [
        predicate<EditVehicleInfoState>(
          (s) => s.editVehicleInfoState.isLoading,
        ),
        predicate<EditVehicleInfoState>(
          (s) => s.editVehicleInfoState.msg == 'Update failed',
        ),
      ],
      verify: (_) {
        verify(
          mockEditVehicleInfoUseCase.execute(
            requestModel: anyNamed('requestModel'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockEditVehicleInfoUseCase);
      },
    );
  });
}
