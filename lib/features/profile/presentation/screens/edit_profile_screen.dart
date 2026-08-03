import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider_app/config/di/di.dart';
import 'package:flowery_rider_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flowery_rider_app/core/theme/app_colors.dart';
import 'package:flowery_rider_app/core/theme/text_styles.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flowery_rider_app/core/values/assets.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/profile_driver_entity.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/edit_profile_view_model/edit_profile_events.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/edit_profile_view_model/edit_profile_state.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/edit_profile_view_model/edit_profile_view_model.dart';
import 'package:flowery_rider_app/features/profile/presentation/widgets/edit_profile_form_widget.dart';
import 'package:flowery_rider_app/features/profile/presentation/widgets/profile_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatelessWidget {
  final ProfileDriverEntity? driver;

  const EditProfileScreen({super.key, this.driver});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EditProfileViewModel>(),
      child: EditProfileView(driver: driver),
    );
  }
}

class EditProfileView extends StatefulWidget {
  final ProfileDriverEntity? driver;

  const EditProfileView({super.key, this.driver});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final ValueNotifier<String?> _selectedImagePath = ValueNotifier(null);
  String _gender = 'male';

  @override
  void initState() {
    super.initState();
    final driver = widget.driver;
    if (driver != null) {
      _firstNameController.text = driver.firstName;
      _lastNameController.text = driver.lastName;
      _emailController.text = driver.email;
      _phoneController.text = driver.phone;
      if (driver.gender.isNotEmpty) {
        _gender = driver.gender.toLowerCase();
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _selectedImagePath.dispose();
    super.dispose();
  }

  Future<void> _showImageSourceDialog() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (_) => const _ImageSourceDialog(),
    );

    if (source == null) return;
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source);
    if (file == null) return;

    _selectedImagePath.value = file.path;
    if (!mounted) return;

    context.read<EditProfileViewModel>().doEvent(
          UploadPhotoEvent(filePath: file.path),
        );
  }

  void _onUpdate() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<EditProfileViewModel>().doEvent(
          EditProfileSubmitEvent(
            requestModel: EditProfileRequestModel(
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              email: _emailController.text.trim(),
              phone: _phoneController.text.trim(),
            ),
          ),
        );
  }

  void _onStateListener(BuildContext context, EditProfileState state) {
    if (state.editProfileState.data != null) {
      AppSnackBar.showSuccess(
        context,
        AppStrings.profileUpdatedSuccessfully,
      );
      Navigator.pop(context, true);
    } else if (state.editProfileState.msg != null) {
      AppSnackBar.showError(context, state.editProfileState.msg!);
    }

    if (state.uploadPhotoState.data != null) {
      AppSnackBar.showSuccess(
        context,
        AppStrings.photoUploadedSuccessfully,
      );
    } else if (state.uploadPhotoState.msg != null) {
      AppSnackBar.showError(context, state.uploadPhotoState.msg!);
    }
  }

  @override
  Widget build(BuildContext context) {
    context.locale;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          icon: SvgPicture.asset(
            Assets.assetsIconsArrowBack,
            width: 24,
            height: 24,
            matchTextDirection: true,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(AppStrings.editProfile),
      ),
      body: BlocListener<EditProfileViewModel, EditProfileState>(
        listenWhen: (prev, curr) =>
            (prev.editProfileState != curr.editProfileState &&
                !curr.editProfileState.isLoading) ||
            (prev.uploadPhotoState != curr.uploadPhotoState &&
                !curr.uploadPhotoState.isLoading),
        listener: _onStateListener,
        child: BlocBuilder<EditProfileViewModel, EditProfileState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  ValueListenableBuilder<String?>(
                    valueListenable: _selectedImagePath,
                    builder: (context, imagePath, _) => ProfileAvatarWidget(
                      imagePath: imagePath ?? widget.driver?.photo,
                      onTap: _showImageSourceDialog,
                    ),
                  ),
                  const SizedBox(height: 24),
                  EditProfileFormWidget(
                    formKey: _formKey,
                    firstNameController: _firstNameController,
                    lastNameController: _lastNameController,
                    emailController: _emailController,
                    phoneController: _phoneController,
                    gender: _gender,
                    onGenderChanged: (val) => setState(() => _gender = val),
                    onUpdate: _onUpdate,
                    isLoading: state.editProfileState.isLoading,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ImageSourceDialog extends StatelessWidget {
  const _ImageSourceDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.editProfile,
              style: TextStyles.bodyMedium18.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _ImageSourceOption(
              icon: Icons.camera_alt_rounded,
              label: AppStrings.takePhoto,
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            const SizedBox(height: 12),
            _ImageSourceOption(
              icon: Icons.photo_library_rounded,
              label: AppStrings.chooseFromGallery,
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageSourceOption extends StatelessWidget {
  const _ImageSourceOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.lightPink,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.pink, size: 22),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyles.bodyRegular14.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
