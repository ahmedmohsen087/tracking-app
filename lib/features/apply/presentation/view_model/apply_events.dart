import 'package:flowery_rider_app/features/apply/api/request_models/apply_request_model.dart';

sealed class ApplyEvents {}

class SubmitApplyEvent extends ApplyEvents {
  final ApplyRequestModel requestModel;

  SubmitApplyEvent({required this.requestModel});
}
