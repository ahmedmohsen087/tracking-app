import 'dart:convert';
import 'package:flowery_rider_app/config/di/di.dart';
import 'package:flowery_rider_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flowery_rider_app/core/theme/app_colors.dart';
import 'package:flowery_rider_app/core/values/app_routs_name.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flowery_rider_app/core/values/assets.dart';
import 'package:flowery_rider_app/features/auth/api/request_models/apply_request_model.dart';
import 'package:flowery_rider_app/features/auth/presentation/view_models/apply_view_model/apply_events.dart';
import 'package:flowery_rider_app/features/auth/presentation/view_models/apply_view_model/apply_state.dart';
import 'package:flowery_rider_app/features/auth/presentation/view_models/apply_view_model/apply_view_model.dart';
import 'package:flowery_rider_app/features/auth/presentation/widgets/apply_bottom_actions.dart';
import 'package:flowery_rider_app/features/auth/presentation/widgets/apply_dropdowns_and_headers.dart';
import 'package:flowery_rider_app/features/auth/presentation/widgets/apply_form_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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
  List<Map<String, String>> _vehicleTypes = [];
  bool _isLoadingCountries = true;

  @override
  void initState() {
    super.initState();
    _loadCountries();
    _loadVehicleTypes();
  }

  Future<void> _loadCountries() async {
    try {
      final response = await rootBundle.loadString('assets/files/country.json');
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
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingCountries = false);
    }
  }

  Future<void> _loadVehicleTypes() async {
    final response = await rootBundle.loadString(
      'assets/files/vehicles_type.json',
    );
    final data = await json.decode(response) as List<dynamic>;
    if (!mounted) return;
    setState(() {
      _vehicleTypes = data
          .map(
            (e) => {'id': e['id'].toString(), 'label': e['label'].toString()},
          )
          .toList();
    });
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

  Future<ImageSource?> _showPickerSheet() {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: Text(AppStrings.takePhoto),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(AppStrings.chooseFromGallery),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  void _showPermissionDeniedDialog(bool isCamera) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.permissionRequired),
        content: Text(
          isCamera
              ? AppStrings.cameraPermanentlyDenied
              : AppStrings.photoPermanentlyDenied,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings();
            },
            child: Text(AppStrings.openSettings),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile(bool isLicense) async {
    final source = await _showPickerSheet();
    if (source == null || !mounted) return;

    final viewModel = context.read<ApplyViewModel>();
    final result = source == ImageSource.camera
        ? await viewModel.checkCameraPermission()
        : await viewModel.checkPermissions();

    if (result != PermissionResult.granted) {
      if (!mounted) return;
      _showPermissionDeniedDialog(source == ImageSource.camera);
      return;
    }

    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: source,
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

  String _formatPhone() {
    var phone = _phoneController.text.trim();
    if (phone.startsWith('0')) phone = phone.substring(1);
    if (!phone.startsWith('+')) phone = '$_selectedCountryCode$phone';
    return phone;
  }

  void _onSubmit() {
    if (!_autoValidate) setState(() => _autoValidate = true);
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGender == null) {
      AppSnackBar.showError(context, AppStrings.genderRequired);
      return;
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
              phone: _formatPhone(),
              nid: _nidController.text.trim(),
              nidImgPath: _nidImgPath!,
              password: _passwordController.text,
              confirmPassword: _confirmPasswordController.text,
              gender: _selectedGender!,
            ),
          ),
        );
  }

  void _onStateListener(BuildContext context, ApplyState state) {
    if (state.applyState.data != null) {
      Navigator.of(context).pushReplacementNamed(AppRoutsName.successApplyScreen);
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ApplyViewModel, ApplyState>(
      listenWhen: (prev, curr) =>
          prev.applyState.isLoading && !curr.applyState.isLoading,
      listener: _onStateListener,
      child: Scaffold(
        appBar: const ApplyAppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: _isLoadingCountries
              ? const Center(child: CircularProgressIndicator())
              : _ApplyFormView(
                  formKey: _formKey,
                  autoValidate: _autoValidate,
                  countries: _countries,
                  vehicleTypes: _vehicleTypes,
                  selectedCountry: _selectedCountry,
                  selectedCountryCode: _selectedCountryCode,
                  selectedVehicleTypeLabel: _selectedVehicleTypeLabel,
                  vehicleLicensePath: _vehicleLicensePath,
                  nidImgPath: _nidImgPath,
                  selectedGender: _selectedGender,
                  obscurePassword: _obscurePassword,
                  obscureConfirmPassword: _obscureConfirmPassword,
                  firstNameController: _firstNameController,
                  lastNameController: _lastNameController,
                  vehicleNumberController: _vehicleNumberController,
                  emailController: _emailController,
                  phoneController: _phoneController,
                  nidController: _nidController,
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                  onCountryChanged: (map) => setState(() {
                    _selectedCountry = map['id']!;
                    _selectedCountryCode = map['code']!;
                  }),
                  onVehicleTypeChanged: (map) => setState(() {
                    _selectedVehicleTypeId = map['id']!;
                    _selectedVehicleTypeLabel = map['label']!;
                  }),
                  onPickLicense: () => _pickFile(true),
                  onPickNidImage: () => _pickFile(false),
                  onGenderChanged: (v) => setState(() => _selectedGender = v),
                  onTogglePassword: () => setState(
                    () => _obscurePassword = !_obscurePassword,
                  ),
                  onToggleConfirmPassword: () => setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword,
                  ),
                  onSubmit: _onSubmit,
                ),
        ),
      ),
    );
  }
}

class _ApplyFormView extends StatelessWidget {
  const _ApplyFormView({
    required this.formKey,
    required this.autoValidate,
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
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final bool autoValidate;
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
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autoValidate
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      child: Column(
        children: [
          ApplyFormBody(
            countries: countries,
            vehicleTypes: vehicleTypes,
            selectedCountry: selectedCountry,
            selectedCountryCode: selectedCountryCode,
            selectedVehicleTypeLabel: selectedVehicleTypeLabel,
            vehicleLicensePath: vehicleLicensePath,
            nidImgPath: nidImgPath,
            selectedGender: selectedGender,
            obscurePassword: obscurePassword,
            obscureConfirmPassword: obscureConfirmPassword,
            firstNameController: firstNameController,
            lastNameController: lastNameController,
            vehicleNumberController: vehicleNumberController,
            emailController: emailController,
            phoneController: phoneController,
            nidController: nidController,
            passwordController: passwordController,
            confirmPasswordController: confirmPasswordController,
            onCountryChanged: onCountryChanged,
            onVehicleTypeChanged: onVehicleTypeChanged,
            onPickLicense: onPickLicense,
            onPickNidImage: onPickNidImage,
            onGenderChanged: onGenderChanged,
            onTogglePassword: onTogglePassword,
            onToggleConfirmPassword: onToggleConfirmPassword,
          ),
          const SizedBox(height: 32),
          BlocBuilder<ApplyViewModel, ApplyState>(
            builder: (context, state) => ApplySubmitButton(
              isLoading: state.applyState.isLoading,
              onPressed: onSubmit,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
