

import '../../../../config/base_response/base_response.dart';
import '../models/home_response.dart';


abstract interface class HomeRemoteDataSourceContract {
  Future<BaseResponse<HomeResponse>> getOrders();

 }