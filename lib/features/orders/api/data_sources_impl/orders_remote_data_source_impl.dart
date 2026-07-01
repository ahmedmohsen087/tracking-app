import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../data/data_sources_contract/orders_remote_data_source_contract.dart';
import '../../data/models/my_order_response.dart';
import '../orders_api_client/orders_api_client.dart';
import '../request_models/get_my_orders_request.dart';
@Injectable(as: OrdersRemoteDataSourceContract)
class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSourceContract {
  final OrdersApiClient _ordersApiClient;
  OrdersRemoteDataSourceImpl(this._ordersApiClient);
  @override
  Future<BaseResponse<MyOrderResponse>> getMyOrders({
    required GetMyOrdersRequest request,
  }) async {
    try {
      final response = await _ordersApiClient.getMyOrders(
        page: request.page,
        limit: request.limit,
      );
      return SuccessBaseResponse<MyOrderResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<MyOrderResponse>(errorMessage: e.toString());
    }
  }
}
