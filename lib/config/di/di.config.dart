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
import '../../features/forget_password/api/forget_password_api.dart' as _i688;
import '../../features/forget_password/data/repositories/auth_repository_impl.dart'
    as _i467;
import '../../features/forget_password/domain/repositories/auth_repository.dart'
    as _i634;
import '../../features/forget_password/domain/use_cases/forget_password_use_case.dart'
    as _i437;
import '../../features/forget_password/domain/use_cases/reset_password_use_case.dart'
    as _i56;
import '../../features/forget_password/domain/use_cases/verify_otp_use_case.dart'
    as _i222;
import '../../features/forget_password/presentation/view_model/auth_view_model.dart'
    as _i1009;
import '../../features/login/api/data_sources/login_remote_data_source_impl.dart'
    as _i851;
import '../../features/login/api/login_api_client/login_api_client.dart'
    as _i315;
import '../../features/login/data/data_sources/login_remote_data_source.dart'
    as _i522;
import '../../features/login/data/repository/login_repository_impl.dart'
    as _i738;
import '../../features/login/domain/repository/login_repository.dart' as _i312;
import '../../features/login/domain/use_cases/login_use_case.dart' as _i191;
import '../../features/login/presentation/view_model/login_view_model.dart'
    as _i225;
import '../../features/logout/api/data_sources/logout_remote_data_source_impl.dart'
    as _i752;
import '../../features/logout/api/logout_api_client/logout_api_client.dart'
    as _i289;
import '../../features/logout/data/data_sources/logout_remote_data_source.dart'
    as _i415;
import '../../features/logout/data/repository/logout_repository_impl.dart'
    as _i1002;
import '../../features/logout/domain/repository/logout_repository.dart'
    as _i573;
import '../../features/logout/domain/use_cases/logout_use_case.dart' as _i677;
import '../../features/logout/presentation/view_model/logout_view_model.dart'
    as _i237;
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
    gh.lazySingleton<_i315.LoginApiClient>(
      () => _i315.LoginApiClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i289.LogoutApiClient>(
      () => _i289.LogoutApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i688.ForgetPasswordApi>(
      () => _i688.ForgetPasswordApi(gh<_i361.Dio>()),
    );
    gh.factory<_i634.AuthRepository>(
      () => _i467.AuthRepositoryImpl(gh<_i688.ForgetPasswordApi>()),
    );
    gh.factory<_i437.ForgetPasswordUseCase>(
      () => _i437.ForgetPasswordUseCase(gh<_i634.AuthRepository>()),
    );
    gh.factory<_i56.ResetPasswordUseCase>(
      () => _i56.ResetPasswordUseCase(gh<_i634.AuthRepository>()),
    );
    gh.factory<_i222.VerifyOtpUseCase>(
      () => _i222.VerifyOtpUseCase(gh<_i634.AuthRepository>()),
    );
    gh.factory<_i1009.AuthCubit>(
      () => _i1009.AuthCubit(
        forgetPasswordUseCase: gh<_i437.ForgetPasswordUseCase>(),
        verifyOtpUseCase: gh<_i222.VerifyOtpUseCase>(),
        resetPasswordUseCase: gh<_i56.ResetPasswordUseCase>(),
      ),
    );
    gh.factory<_i125.ApplyRemoteDataSource>(
      () => _i911.ApplyRemoteDataSourceImpl(gh<_i564.ApplyApiClient>()),
    );
    gh.factory<_i415.LogoutRemoteDataSource>(
      () => _i752.LogoutRemoteDataSourceImpl(gh<_i289.LogoutApiClient>()),
    );
    gh.factory<_i522.LoginRemoteDataSource>(
      () => _i851.LoginRemoteDataSourceImpl(gh<_i315.LoginApiClient>()),
    );
    gh.factory<_i871.ApplyRepository>(
      () => _i946.ApplyRepositoryImpl(gh<_i125.ApplyRemoteDataSource>()),
    );
    gh.factory<_i573.LogoutRepository>(
      () => _i1002.LogoutRepositoryImpl(
        gh<_i415.LogoutRemoteDataSource>(),
        gh<_i692.AuthManager>(),
      ),
    );
    gh.factory<_i677.LogoutUseCase>(
      () => _i677.LogoutUseCase(gh<_i573.LogoutRepository>()),
    );
    gh.factory<_i312.LoginRepository>(
      () => _i738.LoginRepositoryImpl(
        gh<_i522.LoginRemoteDataSource>(),
        gh<_i692.AuthManager>(),
      ),
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
    gh.factory<_i191.LoginUseCase>(
      () => _i191.LoginUseCase(gh<_i312.LoginRepository>()),
    );
    gh.factory<_i237.LogoutViewModel>(
      () => _i237.LogoutViewModel(gh<_i677.LogoutUseCase>()),
    );
    gh.factory<_i225.LoginViewModel>(
      () => _i225.LoginViewModel(
        gh<_i191.LoginUseCase>(),
        gh<_i692.AuthManager>(),
      ),
    );
    return this;
  }
}

class _$CacheModule extends _i953.CacheModule {}

class _$SecureStorageModule extends _i590.SecureStorageModule {}

class _$DioModule extends _i983.DioModule {}
