import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/core/utils/error/error_handler.dart';
import 'package:flowery_rider_app/features/orders/api/orders_api_client/orders_api_client.dart';
import 'package:flowery_rider_app/features/orders/api/request_models/update_order_state_request.dart';
import 'package:flowery_rider_app/features/orders/data/data_sources_contract/orders_remote_data_source_contract.dart';
import 'package:flowery_rider_app/features/orders/data/models/get_order_response.dart';
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

  @override
  Future<BaseResponse<void>> updateOrderState(
    String orderId,
    String state,
  ) async {
    try {
      await _apiClient.updateOrderState(
        orderId,
        UpdateOrderStateRequest(state: state).toJson(),
      );
      return SuccessBaseResponse<void>(data: null);
    } catch (e) {
      final String message = ErrorHandler.handle(e);
      return ErrorBaseResponse<void>(errorMessage: message);
    }
  }

  @override
  Future<BaseResponse<GetOrderResponse>> getMyOrders({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _apiClient.getMyOrders(page, limit);
      return SuccessBaseResponse<GetOrderResponse>(data: response);
    } catch (e) {
      final String message = ErrorHandler.handle(e);
      return ErrorBaseResponse<GetOrderResponse>(errorMessage: message);
    }
  }
}
