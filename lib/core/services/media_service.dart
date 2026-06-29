import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class MediaService {
  Future<MultipartFile> createMultipartFile(String filePath);
}

@Injectable(as: MediaService)
class MediaServiceImpl implements MediaService {
  @override
  Future<MultipartFile> createMultipartFile(String filePath) async {
    return await MultipartFile.fromFile(
      filePath,
      filename: filePath.split('/').last,
    );
  }
}
