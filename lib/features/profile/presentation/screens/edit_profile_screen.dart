import 'package:flowery_rider_app/config/di/di.dart';
import 'package:flowery_rider_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/profile_driver_entity.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/edit_profile_view_model/edit_profile_events.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/edit_profile_view_model/edit_profile_state.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/edit_profile_view_model/edit_profile_view_model.dart';
import 'package:flowery_rider_app/features/profile/presentation/widgets/edit_profile_form_widget.dart';
import 'package:flowery_rider_app/features/profile/presentation/widgets/profile_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    final driver = widget.driver;
    if (driver != null) {
      _firstNameController.text = driver.firstName;
      _lastNameController.text = driver.lastName;
      _emailController.text = driver.email;
      _phoneController.text = driver.phone;
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.editProfile)),
      body: BlocListener<EditProfileViewModel, EditProfileState>(
        listenWhen: (previous, current) =>
            (previous.editProfileState != current.editProfileState &&
                !current.editProfileState.isLoading) ||
            (previous.uploadPhotoState != current.uploadPhotoState &&
                !current.uploadPhotoState.isLoading),
        listener: (context, state) {
          if (state.editProfileState.data != null) {
            AppSnackBar.showSuccess(
              context,
              AppStrings.profileUpdatedSuccessfully,
            );
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
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              ValueListenableBuilder<String?>(
                valueListenable: _selectedImagePath,
                builder: (context, imagePath, _) => ProfileAvatarWidget(
                  imagePath: imagePath,
                  onTap: _pickImage,
                ),
              ),
              const SizedBox(height: 24),
              EditProfileFormWidget(
                formKey: _formKey,
                firstNameController: _firstNameController,
                lastNameController: _lastNameController,
                emailController: _emailController,
                phoneController: _phoneController,
                onUpdate: _onUpdate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
