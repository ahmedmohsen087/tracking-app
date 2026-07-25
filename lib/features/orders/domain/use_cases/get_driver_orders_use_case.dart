import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../api/request_models/get_driver_orders_request.dart';
import '../entities/get_order_response_entity.dart';
import '../repository_contract/orders_repository_contract.dart';

@injectable
class GetDriverOrdersUseCase {
  final OrdersRepositoryContract repository;
  GetDriverOrdersUseCase(this.repository);
  Future<BaseResponse<GetOrderResponseEntity>> call({
    required GetDriverOrdersRequest request,
  }) {
    return repository.getDriverOrders(
      request: request,
    );
  }
}
