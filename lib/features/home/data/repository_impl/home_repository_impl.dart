import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repository_contract/home_repository_contract.dart';
import '../data_sources_contract/home_remote_data_source_contract.dart';
import '../models/home_response.dart';

@Injectable(as: HomeRepositoryContract)
class HomeRepositoryImpl implements HomeRepositoryContract {
  final HomeRemoteDataSourceContract remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<BaseResponse<List<OrderEntity>>> getOrders() async {
    final response = await remoteDataSource.getOrders();

    switch (response) {
      case SuccessBaseResponse<HomeResponse>():
        return SuccessBaseResponse(
          data: response.data.orders
              ?.map((e) => e.toDomain())
              .toList() ??
              [],
        );

      case ErrorBaseResponse<HomeResponse>():
        return ErrorBaseResponse(
          errorMessage: response.errorMessage,
        );
    }
  }
}