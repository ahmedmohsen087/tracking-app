import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

class SmartCacheInterceptor extends Interceptor {
  final CacheOptions homeOptions;

  static const _pendingOrdersPath = '/orders/pending-orders';

  SmartCacheInterceptor({required this.homeOptions});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path.contains(_pendingOrdersPath)) {
      options.extra.addAll(homeOptions.toExtra());
    }
    handler.next(options);
  }
}
