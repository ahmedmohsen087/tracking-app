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

import '../../features/auth/api/auth_api_client/auth_api_client.dart' as _i474;
import '../../features/auth/api/data_sources_impl/auth_remote_data_source_impl.dart'
    as _i691;
import '../../features/auth/data/data_sources_contract/auth_remote_data_source_contract.dart'
    as _i95;
import '../../features/auth/data/repository_impl/auth_repository_impl.dart'
    as _i954;
import '../../features/auth/domain/repository_contract/auth_repository_contract.dart'
    as _i148;
import '../../features/auth/domain/use_cases/apply_use_case.dart' as _i743;
import '../../features/auth/domain/use_cases/login_use_case.dart' as _i1038;
import '../../features/auth/domain/use_cases/logout_use_case.dart' as _i698;
import '../../features/auth/presentation/view_models/apply_view_model/apply_view_model.dart'
    as _i993;
import '../../features/auth/presentation/view_models/login_view_model/login_view_model.dart'
    as _i580;
import '../../features/auth/presentation/view_models/logout_view_model/logout_view_model.dart'
    as _i310;
import '../../features/profile/api/data_sources_impl/profile_remote_data_source_impl.dart'
    as _i1028;
import '../../features/profile/api/profile_api_client/profile_api_client.dart'
    as _i1000;
import '../../features/profile/data/data_sources_contract/profile_remote_data_source_contract.dart'
    as _i1040;
import '../../features/profile/data/repository_impl/profile_repository_impl.dart'
    as _i187;
import '../../features/profile/domain/repository_contract/profile_repository_contract.dart'
    as _i193;
import '../../features/profile/domain/use_cases/edit_profile_use_case.dart'
    as _i199;
import '../../features/profile/domain/use_cases/upload_photo_use_case.dart'
    as _i967;
import '../../features/profile/presentation/view_models/edit_profile_view_model/edit_profile_view_model.dart'
    as _i87;
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
    gh.lazySingleton<_i474.AuthApiClient>(
      () => _i474.AuthApiClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i1000.ProfileApiClient>(
      () => _i1000.ProfileApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i95.AuthRemoteDataSourceContract>(
      () => _i691.AuthRemoteDataSourceImpl(gh<_i474.AuthApiClient>()),
    );
    gh.factory<_i1040.ProfileRemoteDataSourceContract>(
      () => _i1028.ProfileRemoteDataSourceImpl(gh<_i1000.ProfileApiClient>()),
    );
    gh.factory<_i148.AuthRepositoryContract>(
      () => _i954.AuthRepositoryImpl(
        gh<_i95.AuthRemoteDataSourceContract>(),
        gh<_i692.AuthManager>(),
      ),
    );
    gh.factory<_i193.ProfileRepositoryContract>(
      () => _i187.ProfileRepositoryImpl(
        gh<_i1040.ProfileRemoteDataSourceContract>(),
      ),
    );
    gh.factory<_i1038.LoginUseCase>(
      () => _i1038.LoginUseCase(gh<_i148.AuthRepositoryContract>()),
    );
    gh.factory<_i580.LoginViewModel>(
      () => _i580.LoginViewModel(
        gh<_i1038.LoginUseCase>(),
        gh<_i692.AuthManager>(),
      ),
    );
    gh.factory<_i698.LogoutUseCase>(
      () => _i698.LogoutUseCase(gh<_i148.AuthRepositoryContract>()),
    );
    gh.factory<_i199.EditProfileUseCase>(
      () => _i199.EditProfileUseCase(gh<_i193.ProfileRepositoryContract>()),
    );
    gh.factory<_i967.UploadPhotoUseCase>(
      () => _i967.UploadPhotoUseCase(gh<_i193.ProfileRepositoryContract>()),
    );
    gh.factory<_i743.ApplyUseCase>(
      () => _i743.ApplyUseCase(gh<_i148.AuthRepositoryContract>()),
    );
    gh.factory<_i310.LogoutViewModel>(
      () => _i310.LogoutViewModel(gh<_i698.LogoutUseCase>()),
    );
    gh.factory<_i993.ApplyViewModel>(
      () => _i993.ApplyViewModel(gh<_i743.ApplyUseCase>()),
    );
    gh.factory<_i87.EditProfileViewModel>(
      () => _i87.EditProfileViewModel(
        gh<_i199.EditProfileUseCase>(),
        gh<_i967.UploadPhotoUseCase>(),
      ),
    );
    return this;
  }
}

class _$CacheModule extends _i953.CacheModule {}

class _$SecureStorageModule extends _i590.SecureStorageModule {}

class _$DioModule extends _i983.DioModule {}
