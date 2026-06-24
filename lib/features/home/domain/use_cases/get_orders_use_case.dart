import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../entities/order_entity.dart';
import '../repository_contract/home_repository_contract.dart';

@injectable
class GetOrdersUseCase {
  final HomeRepositoryContract repository;

  GetOrdersUseCase(this.repository);

  Future<BaseResponse<List<OrderEntity>>> call() {
    return repository.getOrders();
  }
}