import 'package:equatable/equatable.dart';
import 'package:flowery_rider_app/config/base_state/base_state.dart';
import 'package:flowery_rider_app/features/auth/domain/entities/auth_response_entity.dart';

class ApplyState extends Equatable {
  final BaseState<AuthResponseEntity> applyState;

  const ApplyState({this.applyState = const BaseState()});

  ApplyState copyWith({BaseState<AuthResponseEntity>? applyState}) =>
      ApplyState(applyState: applyState ?? this.applyState);

  @override
  List<Object?> get props => [applyState];
}
