import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../api/request_models/get_my_orders_request.dart';
import '../../domain/entities/my_order_response_entity.dart';
import '../../domain/repository_contract/orders_repository_contract.dart';
import '../data_sources_contract/orders_remote_data_source_contract.dart';
import '../models/my_order_response.dart';


@Injectable(as: OrdersRepositoryContract)
class OrdersRepositoryImpl implements OrdersRepositoryContract {
  final OrdersRemoteDataSourceContract remoteDataSource;
  OrdersRepositoryImpl(this.remoteDataSource);

  @override
  Future<BaseResponse<MyOrderResponseEntity>> getMyOrders({
    required GetMyOrdersRequest request,
  }) async {
    final response = await remoteDataSource.getMyOrders(
      request: request,
    );
    switch (response) {
      case SuccessBaseResponse<MyOrderResponse>():
        return SuccessBaseResponse(
          data: response.data.toDomain(),
        );

      case ErrorBaseResponse<MyOrderResponse>():
        return ErrorBaseResponse(errorMessage: response.errorMessage);
    }
  }
}
