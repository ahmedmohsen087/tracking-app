import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/home/data/data_sources_contract/home_remote_data_source_contract.dart';
import 'package:flowery_rider_app/features/home/data/models/home_response.dart';
import 'package:injectable/injectable.dart';
import '../home_api_client/home_api_client.dart';

@Injectable(as: HomeRemoteDataSourceContract)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSourceContract {
  final HomeApiClient homeApiClient;
  HomeRemoteDataSourceImpl(this.homeApiClient);
  @override
  Future<BaseResponse<HomeResponse>> getOrders({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await homeApiClient.getOrders(page: page, limit: limit);
      return SuccessBaseResponse<HomeResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<HomeResponse>(errorMessage: e.toString());
    }
  }
}
