import 'package:equatable/equatable.dart';
import '../../../../../config/base_state/base_state.dart';
import '../../../../auth/domain/entities/driver_entity.dart';

class GetProfileState extends Equatable {
  final BaseState<DriverEntity> getProfileState;

  const GetProfileState({this.getProfileState = const BaseState()});

  GetProfileState copyWith({BaseState<DriverEntity>? getProfileState}) {
    return GetProfileState(
      getProfileState: getProfileState ?? this.getProfileState,
    );
  }

  @override
  List<Object?> get props => [getProfileState];
}
