import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../api/request_models/get_orders_request.dart';
import '../entities/orders_page_entity.dart';
import '../repository_contract/home_repository_contract.dart';

@injectable
class GetOrdersUseCase {
  final HomeRepositoryContract repository;

  GetOrdersUseCase(this.repository);

  Future<BaseResponse<OrdersPageEntity>> call({
    required GetOrdersRequest request,
  }) {
    return repository.getOrders(
      request: request,
    );
  }
}
