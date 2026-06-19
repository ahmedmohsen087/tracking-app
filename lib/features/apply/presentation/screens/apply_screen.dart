import 'dart:convert';

import 'package:flowery_rider_app/config/di/di.dart';
import 'package:flowery_rider_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flowery_rider_app/core/theme/app_colors.dart';
import 'package:flowery_rider_app/core/theme/text_styles.dart';
import 'package:flowery_rider_app/core/utils/validation/app_validations.dart';
import 'package:flowery_rider_app/core/values/app_routs_name.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flowery_rider_app/core/values/assets.dart';
import 'package:flowery_rider_app/features/apply/api/request_models/apply_request_model.dart';
import 'package:flowery_rider_app/features/apply/presentation/utils/apply_constants.dart';
import 'package:flowery_rider_app/features/apply/presentation/view_model/apply_events.dart';
import 'package:flowery_rider_app/features/apply/presentation/view_model/apply_state.dart';
import 'package:flowery_rider_app/features/apply/presentation/view_model/apply_view_model.dart';
import 'package:flowery_rider_app/features/apply/presentation/widgets/apply_bottom_actions.dart';
import 'package:flowery_rider_app/features/apply/presentation/widgets/apply_dropdowns_and_headers.dart';
import 'package:flowery_rider_app/features/apply/presentation/widgets/apply_form_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class ApplyScreen extends StatelessWidget {
  const ApplyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ApplyViewModel>(),
      child: const _ApplyScreenContent(),
    );
  }
}

class _ApplyScreenContent extends StatefulWidget {
  const _ApplyScreenContent();

  @override
  State<_ApplyScreenContent> createState() => _ApplyScreenContentState();
}

class _ApplyScreenContentState extends State<_ApplyScreenContent> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nidController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedCountry = 'Egypt';
  String _selectedCountryCode = '+20';
  String _selectedVehicleTypeId = '6a32b278992612ae599acf91';
  String _selectedVehicleTypeLabel = 'Car';
  String? _vehicleLicensePath;
  String? _nidImgPath;
  String? _selectedGender;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _autoValidate = false;
  List<Map<String, String>> _countries = [];
  bool _isLoadingCountries = true;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/countries/country.json',
      );
      final data = await json.decode(response) as List<dynamic>;
      if (!mounted) return;
      setState(() {
        _countries = data
            .map(
              (e) => {
                'id': e['name'].toString(),
                'label': e['name'].toString(),
                'code': e['phoneCode'].toString().contains('+')
                    ? e['phoneCode'].toString()
                    : '+${e['phoneCode']}',
                'flag': e['flag'].toString(),
              },
            )
            .toList();

        final egypt = _countries.firstWhere(
          (c) => c['id'] == 'EG' || c['label'] == 'Egypt',
          orElse: () => _countries.first,
        );
        _selectedCountry = egypt['id']!;
        _selectedCountryCode = egypt['code']!;
        _isLoadingCountries = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingCountries = false;
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _vehicleNumberController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nidController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickFile(bool isLicense) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (image == null) return;
    setState(() {
      if (isLicense) {
        _vehicleLicensePath = image.path;
      } else {
        _nidImgPath = image.path;
      }
    });
  }

  void _onSubmit() {
    if (!_autoValidate) {
      setState(() {
        _autoValidate = true;
      });
    }

    if (!_formKey.currentState!.validate()) return;

    if (_selectedGender == null) {
      AppSnackBar.showError(context, AppStrings.genderRequired);
      return;
    }

    var formattedPhone = _phoneController.text.trim();
    if (formattedPhone.startsWith('0')) {
      formattedPhone = formattedPhone.substring(1);
    }
    if (!formattedPhone.startsWith('+')) {
      formattedPhone = '$_selectedCountryCode$formattedPhone';
    }

    context.read<ApplyViewModel>().doEvent(
      SubmitApplyEvent(
        requestModel: ApplyRequestModel(
          country: _selectedCountry,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          vehicleTypeId: _selectedVehicleTypeId,
          vehicleNumber: _vehicleNumberController.text.trim(),
          vehicleLicensePath: _vehicleLicensePath!,
          email: _emailController.text.trim(),
          phone: formattedPhone,
          nid: _nidController.text.trim(),
          nidImgPath: _nidImgPath!,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          gender: _selectedGender!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ApplyViewModel, ApplyState>(
      listenWhen: (previous, current) =>
          previous.applyState.isLoading && !current.applyState.isLoading,
      listener: (context, state) {
        if (state.applyState.data != null) {
          Navigator.of(
            context,
          ).pushReplacementNamed(AppRoutsName.successApplyScreen);
        } else if (state.applyState.msg != null) {
          AppSnackBar.showError(
            context,
            state.applyState.msg!,
            icon: SvgPicture.asset(
              Assets.assetsIconsError,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.white,
                BlendMode.srcIn,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: const ApplyAppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: _isLoadingCountries
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  autovalidateMode: _autoValidate
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const WelcomeHeader(),
                      const SizedBox(height: 24),
                      CountryDropdown(
                        value: _selectedCountry,
                        countries: _countries,
                        onChanged: (map) => setState(() {
                          _selectedCountry = map['id']!;
                          _selectedCountryCode = map['code']!;
                        }),
                      ),
                      const SizedBox(height: 16),
                      ApplyTextField(
                        controller: _firstNameController,
                        label: AppStrings.firstLegalName,
                        hint: AppStrings.enterFirstLegalName,
                        validator: AppValidations.validateFirstName,
                      ),
                      const SizedBox(height: 16),
                      ApplyTextField(
                        controller: _lastNameController,
                        label: AppStrings.secondLegalName,
                        hint: AppStrings.enterSecondLegalName,
                        validator: AppValidations.validateLastName,
                      ),
                      const SizedBox(height: 16),
                      VehicleTypeDropdown(
                        value: _selectedVehicleTypeLabel,
                        types: ApplyConstants.vehicleTypes,
                        onChanged: (map) => setState(() {
                          _selectedVehicleTypeId = map['id']!;
                          _selectedVehicleTypeLabel = map['label']!;
                        }),
                      ),
                      const SizedBox(height: 16),
                      ApplyTextField(
                        controller: _vehicleNumberController,
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
                        filePath: _vehicleLicensePath,
                        onTap: () => _pickFile(true),
                        validator: (v) => AppValidations.validateRequired(
                          v ?? '',
                          AppStrings.vehicleLicenseRequired,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ApplyTextField(
                        controller: _emailController,
                        label: 'Email',
                        hint: AppStrings.enterYourEmail,
                        keyboardType: TextInputType.emailAddress,
                        validator: AppValidations.validateEmail,
                      ),
                      const SizedBox(height: 16),
                      ApplyTextField(
                        controller: _phoneController,
                        label: AppStrings.phoneNumber,
                        hint: AppStrings.enterPhoneNumber,
                        keyboardType: TextInputType.phone,
                        prefixIcon: Container(
                          width: 76,
                          margin: const EdgeInsets.only(right: 12),
                          alignment: Alignment.center,
                          child: Text(
                            '($_selectedCountryCode)',
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
                        controller: _nidController,
                        label: AppStrings.idNumber,
                        hint: AppStrings.enterNationalIdNumber,
                        keyboardType: TextInputType.number,
                        validator: AppValidations.validateNid,
                      ),
                      const SizedBox(height: 16),
                      ApplyFileUploadField(
                        label: AppStrings.idImage,
                        hint: AppStrings.uploadIdImage,
                        filePath: _nidImgPath,
                        onTap: () => _pickFile(false),
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
                              controller: _passwordController,
                              label: 'Password',
                              hint: AppStrings.enterPassword,
                              obscure: _obscurePassword,
                              onToggle: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              validator: AppValidations.validatePassword,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ApplyPasswordField(
                              controller: _confirmPasswordController,
                              label: AppStrings.confirmPassword,
                              hint: AppStrings.confirmPassword,
                              obscure: _obscureConfirmPassword,
                              onToggle: () => setState(
                                () => _obscureConfirmPassword =
                                    !_obscureConfirmPassword,
                              ),
                              validator: (v) =>
                                  AppValidations.validateConfirmPassword(
                                    _passwordController.text,
                                    v,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ApplyGenderRow(
                        selected: _selectedGender,
                        onChanged: (v) => setState(() => _selectedGender = v),
                      ),
                      const SizedBox(height: 32),
                      BlocBuilder<ApplyViewModel, ApplyState>(
                        builder: (context, state) => ApplySubmitButton(
                          isLoading: state.applyState.isLoading,
                          onPressed: _onSubmit,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
