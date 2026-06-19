import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/apply/api/request_models/apply_request_model.dart';
import 'package:flowery_rider_app/features/apply/domain/entities/apply_response_entity.dart';
import 'package:flowery_rider_app/features/apply/domain/repository/apply_repository.dart';
import 'package:flowery_rider_app/features/apply/domain/use_cases/apply_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'apply_use_case_test.mocks.dart';

@GenerateMocks([ApplyRepository])
void main() {
  late ApplyUseCase useCase;
  late MockApplyRepository mockRepository;

  setUpAll(() {
    provideDummy<BaseResponse<ApplyResponseEntity>>(
      SuccessBaseResponse(data: const ApplyResponseEntity()),
    );
  });

  setUp(() {
    mockRepository = MockApplyRepository();
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
    final responseEntity = ApplyResponseEntity(message: 'Success');
    when(
      mockRepository.apply(requestModel: anyNamed('requestModel')),
    ).thenAnswer((_) async => SuccessBaseResponse(data: responseEntity));

    final result = await useCase.execute(requestModel: requestModel);

    expect(result, isA<SuccessBaseResponse<ApplyResponseEntity>>());
    verify(
      mockRepository.apply(requestModel: anyNamed('requestModel')),
    ).called(1);
  });

  test('should return ErrorBaseResponse from repository', () async {
    when(
      mockRepository.apply(requestModel: anyNamed('requestModel')),
    ).thenAnswer((_) async => ErrorBaseResponse(errorMessage: 'Error'));

    final result = await useCase.execute(requestModel: requestModel);

    expect(result, isA<ErrorBaseResponse<ApplyResponseEntity>>());
    expect((result as ErrorBaseResponse).errorMessage, 'Error');
  });
}
