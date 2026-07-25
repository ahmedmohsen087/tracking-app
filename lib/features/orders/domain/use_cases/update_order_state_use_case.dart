import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/orders/domain/repository_contract/orders_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateOrderStateUseCase {
  final OrdersRepositoryContract _repository;

  UpdateOrderStateUseCase(this._repository);

  Future<BaseResponse<void>> call(String orderId, String state) =>
      _repository.updateOrderState(orderId, state);
}
