import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../entities/orders_page_entity.dart';
import '../repository_contract/home_repository_contract.dart';

@injectable
class GetOrdersUseCase {
  final HomeRepositoryContract repository;

  GetOrdersUseCase(this.repository);

  Future<BaseResponse<OrdersPageEntity>> call({
    required int page,
    required int limit,
  }) {
    return repository.getOrders(page: page, limit: limit);
  }
}
