import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/start_order_entity.dart';
import 'package:flowery_rider_app/features/orders/domain/repository_contract/orders_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class StartOrderUseCase {
  final OrdersRepositoryContract _repository;

  StartOrderUseCase(this._repository);

  Future<BaseResponse<StartOrderEntity>> call(String orderId) =>
      _repository.startOrder(orderId);
}
