import 'package:equatable/equatable.dart';
import '../../../../../config/base_state/base_state.dart';
import '../../../domain/entities/profile_driver_entity.dart';

class GetProfileState extends Equatable {
  final BaseState<ProfileDriverEntity> getProfileState;

  const GetProfileState({this.getProfileState = const BaseState()});

  GetProfileState copyWith({BaseState<ProfileDriverEntity>? getProfileState}) {
    return GetProfileState(
      getProfileState: getProfileState ?? this.getProfileState,
    );
  }

  @override
  List<Object?> get props => [getProfileState];
}
