import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../api/request_models/get_orders_request.dart';
import '../../domain/entities/orders_page_entity.dart';
import '../../domain/repository_contract/home_repository_contract.dart';
import '../data_sources_contract/home_remote_data_source_contract.dart';
import '../models/home_response.dart';

@Injectable(as: HomeRepositoryContract)
class HomeRepositoryImpl implements HomeRepositoryContract {
  final HomeRemoteDataSourceContract remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<BaseResponse<OrdersPageEntity>> getOrders({
    required GetOrdersRequest request,
  }) async {
    final response = await remoteDataSource.getOrders(
        request: request
        );

    switch (response) {
      case SuccessBaseResponse<HomeResponse>():
        return SuccessBaseResponse(
          data: OrdersPageEntity(
            orders:
                response.data.orders?.map((e) => e.toDomain()).toList() ?? [],
            currentPage: response.data.metadata?.currentPage ?? request.page,
            totalPages: response.data.metadata?.totalPages ?? request.page,
            totalItems: response.data.metadata?.totalItems ?? 0,
            limit: response.data.metadata?.limit ?? request.limit,
          ),
        );

      case ErrorBaseResponse<HomeResponse>():
        return ErrorBaseResponse(errorMessage: response.errorMessage);
    }
  }
}
