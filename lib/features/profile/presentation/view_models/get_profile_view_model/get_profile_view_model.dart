
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../config/base_response/base_response.dart';
import '../../../../../config/base_state/base_state.dart';
import '../../../domain/entities/profile_driver_entity.dart';
import '../../../domain/use_cases/get_profile_use_case.dart';
import 'get_profile_event.dart';
import 'get_profile_state.dart';

@injectable
class GetProfileViewModel extends Cubit<GetProfileState> {
  final GetProfileUseCase _getProfileUseCases;

  GetProfileViewModel(this._getProfileUseCases)
      : super(const GetProfileState());

  void doEvent(GetProfileEvent event) {
    switch (event) {

      case RefreshProfileEvent():
        _getProfile();
    }
  }





  Future<void> _getProfile() async {
    emit(
      state.copyWith(getProfileState: BaseState<ProfileDriverEntity>.loading()),
    );
    final response = await _getProfileUseCases();
    switch (response) {
      case SuccessBaseResponse():
        emit(
          state.copyWith(
            getProfileState: BaseState<ProfileDriverEntity>.success(
              response.data,
            ),
          ),
        );
      case ErrorBaseResponse():
        emit(
          state.copyWith(
            getProfileState: BaseState<ProfileDriverEntity>.error(
              response.errorMessage,
            ),
          ),
        );
    }
  }
}
