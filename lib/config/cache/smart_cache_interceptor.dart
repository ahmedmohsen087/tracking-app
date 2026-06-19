import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

class SmartCacheInterceptor extends Interceptor {
  final CacheOptions homeOptions;

  SmartCacheInterceptor({required this.homeOptions});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // if (options.method.toUpperCase() != 'GET') {
    //   handler.next(options);
    //   return;
    // }

    // final path = options.uri.path;

    // if (path.contains(_homeSegment)) {
    //   options.extra.addAll(homeOptions.toExtra());
    // }

    // handler.next(options);
  }

  // static final _homeSegment = Uri.parse(Endpoints.home).path;
}
