// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart' as _i695;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/apply/api/apply_api_client/apply_api_client.dart'
    as _i564;
import '../../features/apply/api/data_sources/apply_remote_data_source_impl.dart'
    as _i911;
import '../../features/apply/data/data_sources/apply_remote_data_source.dart'
    as _i125;
import '../../features/apply/data/repository/apply_repository_impl.dart'
    as _i946;
import '../../features/apply/domain/repository/apply_repository.dart' as _i871;
import '../../features/apply/domain/use_cases/apply_use_case.dart' as _i1023;
import '../../features/apply/presentation/view_model/apply_view_model.dart'
    as _i446;
import '../auth/auth_interceptor.dart' as _i53;
import '../auth/auth_manager.dart' as _i692;
import '../cache/smart_cache_interceptor.dart' as _i276;
import '../secure_storage/secure_storage_service.dart' as _i611;
import 'modules/cache_module.dart' as _i953;
import 'modules/dio_module.dart' as _i983;
import 'modules/secure_storage_module.dart' as _i590;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final cacheModule = _$CacheModule();
    final secureStorageModule = _$SecureStorageModule();
    final dioModule = _$DioModule();
    gh.lazySingleton<_i695.CacheStore>(() => cacheModule.cacheStore);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => secureStorageModule.secureStorage,
    );
    gh.lazySingleton<_i611.SecureStorageService>(
      () => _i611.SecureStorageService(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i276.SmartCacheInterceptor>(
      () => cacheModule.smartCacheInterceptor(gh<_i695.CacheStore>()),
    );
    gh.lazySingleton<_i695.DioCacheInterceptor>(
      () => cacheModule.dioCacheInterceptor(gh<_i695.CacheStore>()),
    );
    gh.lazySingleton<_i692.AuthManager>(
      () => _i692.AuthManager(
        gh<_i611.SecureStorageService>(),
        gh<_i695.CacheStore>(),
      ),
    );
    gh.factory<_i53.AuthInterceptor>(
      () => _i53.AuthInterceptor(gh<_i692.AuthManager>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => dioModule.dio(
        gh<_i53.AuthInterceptor>(),
        gh<_i276.SmartCacheInterceptor>(),
        gh<_i695.DioCacheInterceptor>(),
      ),
    );
    gh.lazySingleton<_i564.ApplyApiClient>(
      () => _i564.ApplyApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i125.ApplyRemoteDataSource>(
      () => _i911.ApplyRemoteDataSourceImpl(gh<_i564.ApplyApiClient>()),
    );
    gh.factory<_i871.ApplyRepository>(
      () => _i946.ApplyRepositoryImpl(gh<_i125.ApplyRemoteDataSource>()),
    );
    gh.factory<_i1023.ApplyUseCase>(
      () => _i1023.ApplyUseCase(gh<_i871.ApplyRepository>()),
    );
    gh.factory<_i446.ApplyViewModel>(
      () => _i446.ApplyViewModel(
        gh<_i1023.ApplyUseCase>(),
        gh<_i692.AuthManager>(),
      ),
    );
    return this;
  }
}

class _$CacheModule extends _i953.CacheModule {}

class _$SecureStorageModule extends _i590.SecureStorageModule {}

class _$DioModule extends _i983.DioModule {}
