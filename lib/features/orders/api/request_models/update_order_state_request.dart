import 'package:flowery_rider_app/core/values/api_parameters.dart';

class UpdateOrderStateRequest {
  final String state;

  const UpdateOrderStateRequest({required this.state});

  Map<String, dynamic> toJson() => {ApiParameters.state: state};
}
