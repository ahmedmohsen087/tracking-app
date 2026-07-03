import 'package:flowery_rider_app/core/theme/app_colors.dart';
import 'package:flowery_rider_app/core/theme/text_styles.dart';
import 'package:flowery_rider_app/core/values/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ApplyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final String? Function(String)? validator;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;

  const ApplyTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: prefixIcon,
      ),
      validator: validator != null ? (v) => validator!(v ?? '') : null,
    );
  }
}

class ApplyFileUploadField extends FormField<String> {
  ApplyFileUploadField({
    super.key,
    required String label,
    required String hint,
    required String? filePath,
    required VoidCallback onTap,
    super.validator,
  }) : super(
         initialValue: filePath,
         builder: (FormFieldState<String> state) {
           final displayText = filePath != null
               ? filePath.split('/').last.split('\\').last
               : hint;
           return InkWell(
             onTap: onTap,
             borderRadius: BorderRadius.circular(4),
             child: InputDecorator(
               decoration: InputDecoration(
                 labelText: label,
                 floatingLabelBehavior: FloatingLabelBehavior.always,
                 errorText: state.errorText,
                 suffixIcon: SvgPicture.asset(
                   Assets.assetsIconsUpload,
                   fit: BoxFit.scaleDown,
                   colorFilter: const ColorFilter.mode(
                     AppColors.grey,
                     BlendMode.srcIn,
                   ),
                 ),
               ),
               child: Text(
                 displayText,
                 style: filePath != null
                     ? TextStyles.textFieldTextStyle
                     : TextStyles.hintTextFieldStyle,
                 overflow: TextOverflow.ellipsis,
               ),
             ),
           );
         },
       );

  @override
  FormFieldState<String> createState() => _ApplyFileUploadFieldState();
}

class _ApplyFileUploadFieldState extends FormFieldState<String> {
  @override
  ApplyFileUploadField get widget => super.widget as ApplyFileUploadField;

  @override
  void didUpdateWidget(ApplyFileUploadField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        didChange(widget.initialValue);
      });
    }
  }
}

class ApplyPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscure;
  final VoidCallback onToggle;
  final String? Function(String)? validator;

  const ApplyPasswordField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.obscure,
    required this.onToggle,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: IconButton(
          icon: SvgPicture.asset(
            obscure
                ? Assets.assetsIconsVisibilityOff
                : Assets.assetsIconsVisibilityOn,
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(
              AppColors.grey,
              BlendMode.srcIn,
            ),
          ),
          onPressed: onToggle,
        ),
      ),
      validator: validator != null ? (v) => validator!(v ?? '') : null,
    );
  }
}
