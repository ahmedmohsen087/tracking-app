import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/auth/api/request_models/apply_request_model.dart';
import 'package:flowery_rider_app/features/auth/domain/entities/auth_response_entity.dart';
import 'package:flowery_rider_app/features/auth/domain/repository_contract/auth_repository_contract.dart';
import 'package:flowery_rider_app/features/auth/domain/use_cases/apply_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'apply_use_case_test.mocks.dart';

@GenerateMocks([AuthRepositoryContract])
void main() {
  late ApplyUseCase useCase;
  late MockAuthRepositoryContract mockRepository;

  setUpAll(() {
    provideDummy<BaseResponse<AuthResponseEntity>>(
      SuccessBaseResponse(data: const AuthResponseEntity()),
    );
  });

  setUp(() {
    mockRepository = MockAuthRepositoryContract();
    useCase = ApplyUseCase(mockRepository);
  });

  final requestModel = ApplyRequestModel(
    country: 'Egypt',
    firstName: 'John',
    lastName: 'Doe',
    vehicleTypeId: '123',
    vehicleNumber: '1234',
    vehicleLicensePath: 'path/to/license.jpg',
    email: 'john@example.com',
    phone: '01000000000',
    nid: '12345678901234',
    nidImgPath: 'path/to/nid.jpg',
    password: 'password',
    confirmPassword: 'password',
    gender: 'male',
  );

  test('should return SuccessBaseResponse from repository', () async {
    final responseEntity = AuthResponseEntity(message: 'Success');
    when(
      mockRepository.apply(requestModel: anyNamed('requestModel')),
    ).thenAnswer((_) async => SuccessBaseResponse(data: responseEntity));

    final result = await useCase.execute(requestModel: requestModel);

    expect(result, isA<SuccessBaseResponse<AuthResponseEntity>>());
    verify(
      mockRepository.apply(requestModel: anyNamed('requestModel')),
    ).called(1);
  });

  test('should return ErrorBaseResponse from repository', () async {
    when(
      mockRepository.apply(requestModel: anyNamed('requestModel')),
    ).thenAnswer((_) async => ErrorBaseResponse(errorMessage: 'Error'));

    final result = await useCase.execute(requestModel: requestModel);

    expect(result, isA<ErrorBaseResponse<AuthResponseEntity>>());
    expect((result as ErrorBaseResponse).errorMessage, 'Error');
  });
}
