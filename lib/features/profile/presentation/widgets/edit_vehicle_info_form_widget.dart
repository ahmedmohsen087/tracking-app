import 'package:flowery_rider_app/core/theme/app_colors.dart';
import 'package:flowery_rider_app/core/utils/validation/app_validations.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/vehicle_type_entity.dart';
import 'package:flutter/material.dart';

class EditVehicleInfoFormWidget extends StatelessWidget {
  const EditVehicleInfoFormWidget({
    super.key,
    required this.formKey,
    required this.vehicleTypes,
    required this.selectedVehicleTypeId,
    required this.vehicleNumberController,
    required this.vehicleLicenseFileName,
    required this.onVehicleTypeChanged,
    required this.onUploadLicense,
    required this.onUpdate,
    this.isLoading = false,
  });

  final GlobalKey<FormState> formKey;
  final List<VehicleTypeEntity> vehicleTypes;
  final String? selectedVehicleTypeId;
  final TextEditingController vehicleNumberController;
  final String? vehicleLicenseFileName;
  final ValueChanged<String?> onVehicleTypeChanged;
  final VoidCallback onUploadLicense;
  final VoidCallback onUpdate;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            initialValue: selectedVehicleTypeId,
            items: vehicleTypes
                .map(
                  (e) =>
                      DropdownMenuItem(value: e.id, child: Text(e.type ?? '')),
                )
                .toList(),
            onChanged: onVehicleTypeChanged,
            decoration: InputDecoration(labelText: AppStrings.vehicleType),
            validator: (v) => AppValidations.validateRequired(
              v,
              AppStrings.vehicleTypeRequired,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: vehicleNumberController,
            decoration: InputDecoration(labelText: AppStrings.vehicleNumber),
            validator: (v) => AppValidations.validateRequired(
              v,
              AppStrings.vehicleNumberRequired,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onUploadLicense,
            child: AbsorbPointer(
              child: TextFormField(
                key: ValueKey(vehicleLicenseFileName),
                initialValue: vehicleLicenseFileName,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: AppStrings.vehicleLicense,
                  suffixIcon: const Icon(
                    Icons.upload_outlined,
                    color: AppColors.grey,
                  ),
                ),
                validator: (v) => AppValidations.validateRequired(
                  v,
                  AppStrings.vehicleLicenseRequired,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: isLoading ? null : onUpdate,
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(AppStrings.updateProfile),
            ),
          ),
        ],
      ),
    );
  }
}
