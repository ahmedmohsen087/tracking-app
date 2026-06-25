import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/profile/domain/repository_contract/profile_repository_contract.dart';
import 'package:flowery_rider_app/features/profile/domain/use_cases/upload_photo_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'upload_photo_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepositoryContract])
void main() {
  provideDummy<BaseResponse<String>>(
    SuccessBaseResponse<String>(data: 'success'),
  );

  late MockProfileRepositoryContract mockRepository;
  late UploadPhotoUseCase useCase;

  const tFilePath = '/path/to/photo.jpg';

  setUp(() {
    mockRepository = MockProfileRepositoryContract();
    useCase = UploadPhotoUseCase(mockRepository);
  });

  group('UploadPhotoUseCase', () {
    test(
      'should forward filePath to repository and return SuccessBaseResponse on success',
      () async {
        final expectedResponse = SuccessBaseResponse<String>(data: 'success');
        when(
          mockRepository.uploadPhoto(filePath: anyNamed('filePath')),
        ).thenAnswer((_) async => expectedResponse);

        final result = await useCase.execute(filePath: tFilePath);

        expect(result, expectedResponse);
        verify(
          mockRepository.uploadPhoto(filePath: anyNamed('filePath')),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should forward filePath to repository and return ErrorBaseResponse on failure',
      () async {
        final expectedResponse = ErrorBaseResponse<String>(
          errorMessage: 'Upload failed',
        );
        when(
          mockRepository.uploadPhoto(filePath: anyNamed('filePath')),
        ).thenAnswer((_) async => expectedResponse);

        final result = await useCase.execute(filePath: tFilePath);

        expect(result, expectedResponse);
        verify(
          mockRepository.uploadPhoto(filePath: anyNamed('filePath')),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
