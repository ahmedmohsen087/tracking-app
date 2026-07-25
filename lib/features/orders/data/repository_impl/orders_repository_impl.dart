import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/orders/api/request_models/get_my_orders_request.dart';
import 'package:flowery_rider_app/features/orders/data/data_sources_contract/orders_remote_data_source_contract.dart';
import 'package:flowery_rider_app/features/orders/data/models/get_order_response.dart';
import 'package:flowery_rider_app/features/orders/data/models/start_order_response.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/get_order_response_entity.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/start_order_entity.dart';
import 'package:flowery_rider_app/features/orders/domain/mappers/start_order_response_mapper.dart';
import 'package:flowery_rider_app/features/orders/domain/repository_contract/orders_repository_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrdersRepositoryContract)
class OrdersRepositoryImpl implements OrdersRepositoryContract {
  final OrdersRemoteDataSourceContract _dataSource;

  OrdersRepositoryImpl(this._dataSource);

  @override
  Future<BaseResponse<StartOrderEntity>> startOrder(String orderId) async {
    final response = await _dataSource.startOrder(orderId);
    switch (response) {
      case SuccessBaseResponse<StartOrderResponse>():
        return SuccessBaseResponse<StartOrderEntity>(
          data: response.data.orders?.toEntity() ??
              const StartOrderEntity(orderId: '', userId: ''),
        );
      case ErrorBaseResponse<StartOrderResponse>():
        return ErrorBaseResponse<StartOrderEntity>(
          errorMessage: response.errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<void>> updateOrderState(
    String orderId,
    String state,
  ) {
    return _dataSource.updateOrderState(orderId, state);
  }

  @override
  Future<BaseResponse<GetOrderResponseEntity>> getMyOrders({
    required GetMyOrdersRequest request,
  }) async {
    final response = await _dataSource.getMyOrders(
      page: request.page,
      limit: request.limit,
    );
    switch (response) {
      case SuccessBaseResponse<GetOrderResponse>():
        return SuccessBaseResponse<GetOrderResponseEntity>(
          data: response.data.toDomain(),
        );
      case ErrorBaseResponse<GetOrderResponse>():
        return ErrorBaseResponse<GetOrderResponseEntity>(
          errorMessage: response.errorMessage,
        );
    }
  }
}
