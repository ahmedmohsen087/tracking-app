import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../api/request_models/get_my_orders_request.dart';
import '../entities/get_order_response_entity.dart';
import '../repository_contract/orders_repository_contract.dart';

@injectable
class GetMyOrdersUseCase {
  final OrdersRepositoryContract repository;
  GetMyOrdersUseCase(this.repository);
  Future<BaseResponse<GetOrderResponseEntity>> call({
    required GetMyOrdersRequest request,
  }) {
    return repository.getMyOrders(
      request: request,
    );
  }
}

