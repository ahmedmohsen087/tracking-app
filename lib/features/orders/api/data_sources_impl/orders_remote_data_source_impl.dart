import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/core/utils/error/error_handler.dart';
import 'package:flowery_rider_app/features/orders/api/orders_api_client/orders_api_client.dart';
import 'package:flowery_rider_app/features/orders/data/data_sources_contract/orders_remote_data_source_contract.dart';
import 'package:flowery_rider_app/features/orders/data/models/start_order_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrdersRemoteDataSourceContract)
class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSourceContract {
  final OrdersApiClient _apiClient;

  OrdersRemoteDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponse<StartOrderResponse>> startOrder(String orderId) async {
    try {
      final response = await _apiClient.startOrder(orderId);
      return SuccessBaseResponse<StartOrderResponse>(data: response);
    } catch (e) {
      final String message = ErrorHandler.handle(e);
      return ErrorBaseResponse<StartOrderResponse>(errorMessage: message);
    }
  }
}
