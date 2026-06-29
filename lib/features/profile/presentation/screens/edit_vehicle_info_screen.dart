import 'package:flowery_rider_app/config/di/di.dart';
import 'package:flowery_rider_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/edit_vehicle_info_request_model.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/profile_driver_entity.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/edit_vehicle_info_view_model/edit_vehicle_info_events.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/edit_vehicle_info_view_model/edit_vehicle_info_state.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/edit_vehicle_info_view_model/edit_vehicle_info_view_model.dart';
import 'package:flowery_rider_app/features/profile/presentation/widgets/edit_vehicle_info_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditVehicleInfoScreen extends StatelessWidget {
  const EditVehicleInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final driver =
        ModalRoute.of(context)?.settings.arguments as ProfileDriverEntity?;
    return BlocProvider(
      create: (_) =>
          getIt<EditVehicleInfoViewModel>()..doEvent(GetVehicleTypesEvent()),
      child: EditVehicleInfoView(driver: driver),
    );
  }
}

class EditVehicleInfoView extends StatefulWidget {
  final ProfileDriverEntity? driver;

  const EditVehicleInfoView({super.key, this.driver});

  @override
  State<EditVehicleInfoView> createState() => _EditVehicleInfoViewState();
}

class _EditVehicleInfoViewState extends State<EditVehicleInfoView> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleNumberController = TextEditingController();

  final ValueNotifier<String?> _selectedVehicleTypeId = ValueNotifier(null);
  final ValueNotifier<String?> _selectedLicenseFilePath = ValueNotifier(null);
  final ValueNotifier<String?> _selectedLicenseFileName = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    final driver = widget.driver;
    if (driver != null) {
      _vehicleNumberController.text = driver.vehicleNumber;
    }
  }

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    _selectedVehicleTypeId.dispose();
    _selectedLicenseFilePath.dispose();
    _selectedLicenseFileName.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    _selectedLicenseFilePath.value = file.path;
    _selectedLicenseFileName.value = file.path.split('/').last;
  }

  void _onUpdate() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_selectedVehicleTypeId.value == null ||
        _selectedLicenseFilePath.value == null) {
      return;
    }

    context.read<EditVehicleInfoViewModel>().doEvent(
      EditVehicleInfoSubmitEvent(
        requestModel: EditVehicleInfoRequestModel(
          vehicleTypeId: _selectedVehicleTypeId.value!,
          vehicleNumber: _vehicleNumberController.text.trim(),
          vehicleLicenseFilePath: _selectedLicenseFilePath.value!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.editVehicleInfo)),
      body: BlocListener<EditVehicleInfoViewModel, EditVehicleInfoState>(
        listenWhen: (previous, current) =>
            (previous.editVehicleInfoState != current.editVehicleInfoState &&
                !current.editVehicleInfoState.isLoading) ||
            (previous.getVehicleTypesState != current.getVehicleTypesState &&
                !current.getVehicleTypesState.isLoading),
        listener: (context, state) {
          if (state.editVehicleInfoState.data != null) {
            AppSnackBar.showSuccess(
              context,
              AppStrings.vehicleInfoUpdatedSuccessfully,
            );
          } else if (state.editVehicleInfoState.msg != null) {
            AppSnackBar.showError(context, state.editVehicleInfoState.msg!);
          }

          if (state.getVehicleTypesState.msg != null) {
            AppSnackBar.showError(context, state.getVehicleTypesState.msg!);
          }
        },
        child: BlocBuilder<EditVehicleInfoViewModel, EditVehicleInfoState>(
          buildWhen: (previous, current) =>
              previous.getVehicleTypesState != current.getVehicleTypesState ||
              previous.editVehicleInfoState != current.editVehicleInfoState,
          builder: (context, state) {
            if (state.getVehicleTypesState.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final vehicleTypes =
                state.getVehicleTypesState.data?.vehicles ?? [];

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ValueListenableBuilder<String?>(
                valueListenable: _selectedVehicleTypeId,
                builder: (context, vehicleTypeId, _) {
                  return ValueListenableBuilder<String?>(
                    valueListenable: _selectedLicenseFileName,
                    builder: (context, licenseFileName, _) {
                      return EditVehicleInfoFormWidget(
                        formKey: _formKey,
                        vehicleTypes: vehicleTypes,
                        selectedVehicleTypeId: vehicleTypeId,
                        vehicleNumberController: _vehicleNumberController,
                        vehicleLicenseFileName: licenseFileName,
                        onVehicleTypeChanged: (val) {
                          _selectedVehicleTypeId.value = val;
                        },
                        onUploadLicense: _pickImage,
                        onUpdate: _onUpdate,
                        isLoading: state.editVehicleInfoState.isLoading,
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
