// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:dio/dio.dart' as _i361;
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart' as _i695;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;

import '../../core/services/media_service.dart' as _i902;
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
import '../../features/auth/domain/use_cases/forget_password_use_case.dart'
    as _i483;
import '../../features/auth/domain/use_cases/login_use_case.dart' as _i1038;
import '../../features/auth/domain/use_cases/logout_use_case.dart' as _i698;
import '../../features/auth/presentation/view_models/apply_view_model/apply_view_model.dart'
    as _i993;
import '../../features/auth/presentation/view_models/forget_password_view_model/forget_password_view_model.dart'
    as _i628;
import '../../features/auth/presentation/view_models/login_view_model/login_view_model.dart'
    as _i580;
import '../../features/auth/presentation/view_models/logout_view_model/logout_view_model.dart'
    as _i310;
import '../../features/home/api/data_sources_imp/home_remote_data_source_impl.dart'
    as _i938;
import '../../features/home/api/home_api_client/home_api_client.dart' as _i866;
import '../../features/home/data/data_sources_contract/home_remote_data_source_contract.dart'
    as _i830;
import '../../features/home/data/repository_impl/home_repository_impl.dart'
    as _i60;
import '../../features/home/domain/repository_contract/home_repository_contract.dart'
    as _i845;
import '../../features/home/domain/use_cases/get_orders_use_case.dart'
    as _i1006;
import '../../features/home/presentation/view_model/home_view_model.dart'
    as _i77;
import '../../features/orders/api/data_sources_impl/orders_remote_data_source_impl.dart'
    as _i116;
import '../../features/orders/api/orders_api_client/orders_api_client.dart'
    as _i84;
import '../../features/orders/data/data_sources_contract/orders_remote_data_source_contract.dart'
    as _i341;
import '../../features/orders/data/repository_impl/orders_repository_impl.dart'
    as _i822;
import '../../features/orders/domain/repository_contract/orders_repository_contract.dart'
    as _i440;
import '../../features/orders/domain/use_cases/start_order_use_case.dart'
    as _i810;
import '../../features/orders/presentation/view_models/order_details_view_model/order_details_view_model.dart'
    as _i994;
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
import '../../features/profile/domain/use_cases/change_password_usecase.dart'
    as _i963;
import '../../features/profile/domain/use_cases/edit_profile_use_case.dart'
    as _i199;
import '../../features/profile/domain/use_cases/edit_vehicle_info_use_case.dart'
    as _i133;
import '../../features/profile/domain/use_cases/get_profile_use_case.dart'
    as _i110;
import '../../features/profile/domain/use_cases/get_vehicle_types_use_case.dart'
    as _i191;
import '../../features/profile/domain/use_cases/upload_photo_use_case.dart'
    as _i967;
import '../../features/profile/presentation/view_models/change_password_view_model/change_password_view_model.dart'
    as _i548;
import '../../features/profile/presentation/view_models/edit_profile_view_model/edit_profile_view_model.dart'
    as _i87;
import '../../features/profile/presentation/view_models/edit_vehicle_info_view_model/edit_vehicle_info_view_model.dart'
    as _i227;
import '../../features/profile/presentation/view_models/get_profile_view_model/get_profile_view_model.dart'
    as _i530;
import '../auth/auth_interceptor.dart' as _i53;
import '../auth/auth_manager.dart' as _i692;
import '../cache/smart_cache_interceptor.dart' as _i276;
import '../firebase/fcm_service.dart' as _i92;
import '../secure_storage/secure_storage_service.dart' as _i611;
import 'modules/cache_module.dart' as _i953;
import 'modules/dio_module.dart' as _i983;
import 'modules/firebase_module.dart' as _i398;
import 'modules/http_module.dart' as _i799;
import 'modules/secure_storage_module.dart' as _i590;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final cacheModule = _$CacheModule();
    final firebaseModule = _$FirebaseModule();
    final httpModule = _$HttpModule();
    final secureStorageModule = _$SecureStorageModule();
    final dioModule = _$DioModule();
    gh.lazySingleton<_i695.CacheStore>(() => cacheModule.cacheStore);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => firebaseModule.firestore);
    gh.lazySingleton<_i519.Client>(() => httpModule.httpClient);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => secureStorageModule.secureStorage,
    );
    gh.lazySingleton<_i92.FcmService>(() => _i92.FcmService());
    gh.factory<_i902.MediaService>(() => _i902.MediaServiceImpl());
    gh.factory<_i994.OrderDetailsViewModel>(
      () => _i994.OrderDetailsViewModel(
        gh<_i92.FcmService>(),
        gh<_i974.FirebaseFirestore>(),
      ),
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
    gh.lazySingleton<_i866.HomeApiClient>(
      () => _i866.HomeApiClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i84.OrdersApiClient>(
      () => _i84.OrdersApiClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i1000.ProfileApiClient>(
      () => _i1000.ProfileApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i1040.ProfileRemoteDataSourceContract>(
      () => _i1028.ProfileRemoteDataSourceImpl(
        gh<_i1000.ProfileApiClient>(),
        gh<_i902.MediaService>(),
      ),
    );
    gh.factory<_i193.ProfileRepositoryContract>(
      () => _i187.ProfileRepositoryImpl(
        gh<_i1040.ProfileRemoteDataSourceContract>(),
        gh<_i692.AuthManager>(),
      ),
    );
    gh.factory<_i95.AuthRemoteDataSourceContract>(
      () => _i691.AuthRemoteDataSourceImpl(gh<_i474.AuthApiClient>()),
    );
    gh.factory<_i830.HomeRemoteDataSourceContract>(
      () => _i938.HomeRemoteDataSourceImpl(gh<_i866.HomeApiClient>()),
    );
    gh.factory<_i341.OrdersRemoteDataSourceContract>(
      () => _i116.OrdersRemoteDataSourceImpl(gh<_i84.OrdersApiClient>()),
    );
    gh.factory<_i440.OrdersRepositoryContract>(
      () => _i822.OrdersRepositoryImpl(
        gh<_i341.OrdersRemoteDataSourceContract>(),
      ),
    );
    gh.factory<_i963.ChangePasswordUseCase>(
      () => _i963.ChangePasswordUseCase(gh<_i193.ProfileRepositoryContract>()),
    );
    gh.factory<_i199.EditProfileUseCase>(
      () => _i199.EditProfileUseCase(gh<_i193.ProfileRepositoryContract>()),
    );
    gh.factory<_i133.EditVehicleInfoUseCase>(
      () => _i133.EditVehicleInfoUseCase(gh<_i193.ProfileRepositoryContract>()),
    );
    gh.factory<_i191.GetVehicleTypesUseCase>(
      () => _i191.GetVehicleTypesUseCase(gh<_i193.ProfileRepositoryContract>()),
    );
    gh.factory<_i967.UploadPhotoUseCase>(
      () => _i967.UploadPhotoUseCase(gh<_i193.ProfileRepositoryContract>()),
    );
    gh.factory<_i810.StartOrderUseCase>(
      () => _i810.StartOrderUseCase(gh<_i440.OrdersRepositoryContract>()),
    );
    gh.factory<_i148.AuthRepositoryContract>(
      () => _i954.AuthRepositoryImpl(
        gh<_i95.AuthRemoteDataSourceContract>(),
        gh<_i692.AuthManager>(),
      ),
    );
    gh.factory<_i227.EditVehicleInfoViewModel>(
      () => _i227.EditVehicleInfoViewModel(
        gh<_i191.GetVehicleTypesUseCase>(),
        gh<_i133.EditVehicleInfoUseCase>(),
      ),
    );
    gh.factory<_i110.GetProfileUseCase>(
      () => _i110.GetProfileUseCase(gh<_i193.ProfileRepositoryContract>()),
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
    gh.factory<_i845.HomeRepositoryContract>(
      () => _i60.HomeRepositoryImpl(gh<_i830.HomeRemoteDataSourceContract>()),
    );
    gh.factory<_i548.ChangePasswordViewModel>(
      () => _i548.ChangePasswordViewModel(gh<_i963.ChangePasswordUseCase>()),
    );
    gh.factory<_i530.GetProfileViewModel>(
      () => _i530.GetProfileViewModel(gh<_i110.GetProfileUseCase>()),
    );
    gh.factory<_i1006.GetOrdersUseCase>(
      () => _i1006.GetOrdersUseCase(gh<_i845.HomeRepositoryContract>()),
    );
    gh.factory<_i698.LogoutUseCase>(
      () => _i698.LogoutUseCase(gh<_i148.AuthRepositoryContract>()),
    );
    gh.factory<_i87.EditProfileViewModel>(
      () => _i87.EditProfileViewModel(
        gh<_i199.EditProfileUseCase>(),
        gh<_i967.UploadPhotoUseCase>(),
      ),
    );
    gh.factory<_i743.ApplyUseCase>(
      () => _i743.ApplyUseCase(gh<_i148.AuthRepositoryContract>()),
    );
    gh.factory<_i483.ForgetPasswordUseCase>(
      () => _i483.ForgetPasswordUseCase(gh<_i148.AuthRepositoryContract>()),
    );
    gh.factory<_i310.LogoutViewModel>(
      () => _i310.LogoutViewModel(gh<_i698.LogoutUseCase>()),
    );
    gh.factory<_i993.ApplyViewModel>(
      () => _i993.ApplyViewModel(gh<_i743.ApplyUseCase>()),
    );
    gh.factory<_i628.ForgetPasswordViewModel>(
      () => _i628.ForgetPasswordViewModel(gh<_i483.ForgetPasswordUseCase>()),
    );
    gh.factory<_i77.HomeViewModel>(
      () => _i77.HomeViewModel(
        gh<_i1006.GetOrdersUseCase>(),
        gh<_i810.StartOrderUseCase>(),
        gh<_i92.FcmService>(),
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    return this;
  }
}

class _$CacheModule extends _i953.CacheModule {}

class _$FirebaseModule extends _i398.FirebaseModule {}

class _$HttpModule extends _i799.HttpModule {}

class _$SecureStorageModule extends _i590.SecureStorageModule {}

class _$DioModule extends _i983.DioModule {}
