import 'package:flowery_rider_app/core/theme/text_styles.dart';
import 'package:flowery_rider_app/core/utils/validation/app_validations.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flowery_rider_app/features/auth/presentation/widgets/apply_bottom_actions.dart';
import 'package:flowery_rider_app/features/auth/presentation/widgets/apply_dropdowns_and_headers.dart';
import 'package:flowery_rider_app/features/auth/presentation/widgets/apply_form_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ApplyFormBody extends StatelessWidget {
  final List<Map<String, String>> countries;
  final List<Map<String, String>> vehicleTypes;
  final String selectedCountry;
  final String selectedCountryCode;
  final String selectedVehicleTypeLabel;
  final String? vehicleLicensePath;
  final String? nidImgPath;
  final String? selectedGender;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController vehicleNumberController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController nidController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final ValueChanged<Map<String, String>> onCountryChanged;
  final ValueChanged<Map<String, String>> onVehicleTypeChanged;
  final VoidCallback onPickLicense;
  final VoidCallback onPickNidImage;
  final ValueChanged<String?> onGenderChanged;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;

  const ApplyFormBody({
    super.key,
    required this.countries,
    required this.vehicleTypes,
    required this.selectedCountry,
    required this.selectedCountryCode,
    required this.selectedVehicleTypeLabel,
    required this.vehicleLicensePath,
    required this.nidImgPath,
    required this.selectedGender,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.firstNameController,
    required this.lastNameController,
    required this.vehicleNumberController,
    required this.emailController,
    required this.phoneController,
    required this.nidController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onCountryChanged,
    required this.onVehicleTypeChanged,
    required this.onPickLicense,
    required this.onPickNidImage,
    required this.onGenderChanged,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WelcomeHeader(),
        const SizedBox(height: 24),
        CountryDropdown(
          value: selectedCountry,
          countries: countries,
          onChanged: onCountryChanged,
        ),
        const SizedBox(height: 16),
        ApplyTextField(
          controller: firstNameController,
          label: AppStrings.firstLegalName,
          hint: AppStrings.enterFirstLegalName,
          validator: AppValidations.validateFirstName,
        ),
        const SizedBox(height: 16),
        ApplyTextField(
          controller: lastNameController,
          label: AppStrings.secondLegalName,
          hint: AppStrings.enterSecondLegalName,
          validator: AppValidations.validateLastName,
        ),
        const SizedBox(height: 16),
        VehicleTypeDropdown(
          value: selectedVehicleTypeLabel,
          types: vehicleTypes,
          onChanged: onVehicleTypeChanged,
        ),
        const SizedBox(height: 16),
        ApplyTextField(
          controller: vehicleNumberController,
          label: AppStrings.vehicleNumber,
          hint: AppStrings.enterVehicleNumber,
          validator: (v) => AppValidations.validateRequired(
            v,
            AppStrings.vehicleNumberRequired,
          ),
        ),
        const SizedBox(height: 16),
        ApplyFileUploadField(
          label: AppStrings.vehicleLicense,
          hint: AppStrings.uploadLicensePhoto,
          filePath: vehicleLicensePath,
          onTap: onPickLicense,
          validator: (v) => AppValidations.validateRequired(
            v ?? '',
            AppStrings.vehicleLicenseRequired,
          ),
        ),
        const SizedBox(height: 16),
        ApplyTextField(
          controller: emailController,
          label: AppStrings.email,
          hint: AppStrings.enterYourEmail,
          keyboardType: TextInputType.emailAddress,
          validator: AppValidations.validateEmail,
        ),
        const SizedBox(height: 16),
        ApplyTextField(
          controller: phoneController,
          label: AppStrings.phoneNumber,
          hint: AppStrings.enterPhoneNumber,
          keyboardType: TextInputType.phone,
          prefixIcon: Container(
            width: 76,
            margin: const EdgeInsets.only(right: 12),
            alignment: Alignment.center,
            child: Text(
              '($selectedCountryCode)',
              style: TextStyles.bodyRegular14.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
          validator: AppValidations.validatePhone,
        ),
        const SizedBox(height: 16),
        ApplyTextField(
          controller: nidController,
          label: AppStrings.idNumber,
          hint: AppStrings.enterNationalIdNumber,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(14),
          ],
          validator: AppValidations.validateNid,
        ),
        const SizedBox(height: 16),
        ApplyFileUploadField(
          label: AppStrings.idImage,
          hint: AppStrings.uploadIdImage,
          filePath: nidImgPath,
          onTap: onPickNidImage,
          validator: (v) => AppValidations.validateRequired(
            v ?? '',
            AppStrings.idImageRequired,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ApplyPasswordField(
                controller: passwordController,
                label: AppStrings.password,
                hint: AppStrings.enterPassword,
                obscure: obscurePassword,
                onToggle: onTogglePassword,
                validator: AppValidations.validatePassword,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ApplyPasswordField(
                controller: confirmPasswordController,
                label: AppStrings.confirmPassword,
                hint: AppStrings.confirmPassword,
                obscure: obscureConfirmPassword,
                onToggle: onToggleConfirmPassword,
                validator: (v) => AppValidations.validateConfirmPassword(
                  passwordController.text,
                  v,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ApplyGenderRow(selected: selectedGender, onChanged: onGenderChanged),
      ],
    );
  }
}
