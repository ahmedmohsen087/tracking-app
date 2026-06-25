import 'package:equatable/equatable.dart';
import 'package:flowery_rider_app/config/base_state/base_state.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/profile_entity.dart';

class ChangePasswordState extends Equatable {
  final BaseState<ProfileResponseEntity> changePasswordState;
  final bool autoValidate;

  const ChangePasswordState({
    this.changePasswordState = const BaseState(),
    this.autoValidate = false,
  });

  ChangePasswordState copyWith({
    BaseState<ProfileResponseEntity>? changePasswordState,
    bool? autoValidate,
  }) {
    return ChangePasswordState(
      changePasswordState: changePasswordState ?? this.changePasswordState,
      autoValidate: autoValidate ?? this.autoValidate,
    );
  }

  @override
  List<Object> get props => [changePasswordState, autoValidate];
}
