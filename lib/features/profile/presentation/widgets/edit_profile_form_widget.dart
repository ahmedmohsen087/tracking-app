import 'package:flowery_rider_app/core/utils/validation/app_validations.dart';
import 'package:flowery_rider_app/core/values/app_routs_name.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';

class EditProfileFormWidget extends StatelessWidget {
  const EditProfileFormWidget({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.onUpdate,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: firstNameController,
                  validator: (v) => AppValidations.validateFirstName(v),
                  decoration: InputDecoration(labelText: AppStrings.firstName),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: lastNameController,
                  validator: (v) => AppValidations.validateLastName(v),
                  decoration: InputDecoration(labelText: AppStrings.lastName),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: emailController,
            validator: (v) => AppValidations.validateEmail(v),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: AppStrings.emailLabel),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: phoneController,
            validator: (v) => AppValidations.validatePhone(v),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(labelText: AppStrings.phoneNumber),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, AppRoutsName.changePasswordScreen),
            child: AbsorbPointer(
              child: TextFormField(
                readOnly: true,
                initialValue: '••••••••',
                decoration: InputDecoration(
                  labelText: AppStrings.password,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      AppStrings.changePassword,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onUpdate,
              child: Text(AppStrings.updateProfile),
            ),
          ),
        ],
      ),
    );
  }
}
