import 'package:equatable/equatable.dart';
import 'package:flowery_rider_app/config/base_state/base_state.dart';
import 'package:flowery_rider_app/features/apply/domain/entities/apply_response_entity.dart';

class ApplyState extends Equatable {
  final BaseState<ApplyResponseEntity> applyState;

  const ApplyState({this.applyState = const BaseState()});

  ApplyState copyWith({BaseState<ApplyResponseEntity>? applyState}) =>
      ApplyState(applyState: applyState ?? this.applyState);

  @override
  List<Object?> get props => [applyState];
}
