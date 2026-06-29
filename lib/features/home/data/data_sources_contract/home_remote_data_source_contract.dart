import '../../../../config/base_response/base_response.dart';
import '../../api/request_models/get_orders_request.dart';
import '../models/home_response.dart';

abstract interface class HomeRemoteDataSourceContract {
  Future<BaseResponse<HomeResponse>> getOrders({
    required GetOrdersRequest request,
  });
}
