import 'package:flowery_rider_app/config/di/di.dart';
import 'package:flowery_rider_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flowery_rider_app/core/theme/app_colors.dart';
import 'package:flowery_rider_app/core/theme/text_styles.dart';
import 'package:flowery_rider_app/core/utils/validation/app_validations.dart';
import 'package:flowery_rider_app/core/values/app_routs_name.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flowery_rider_app/core/values/assets.dart';
import 'package:flowery_rider_app/features/auth/api/request_models/login_request_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../view_models/login_view_model/login_events.dart';
import '../view_models/login_view_model/login_state.dart';
import '../view_models/login_view_model/login_view_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginViewModel>(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final ValueNotifier<bool> _rememberMeNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _obscurePasswordNotifier = ValueNotifier<bool>(
    true,
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _rememberMeNotifier.dispose();
    _obscurePasswordNotifier.dispose();
    super.dispose();
  }

  void _onLogin(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<LoginViewModel>().doEvent(
      LoginRequestEvent(
        requestModel: LoginRequestModel(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _LoginAppBar(),
      body: BlocListener<LoginViewModel, LoginState>(
        listener: _LoginListener.onStateChange,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: LoginForm(
            formKey: _formKey,
            emailController: _emailController,
            passwordController: _passwordController,
            obscurePasswordNotifier: _obscurePasswordNotifier,
            rememberMeNotifier: _rememberMeNotifier,
            onLoginPressed: () => _onLogin(context),
          ),
        ),
      ),
    );
  }
}

class _LoginAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _LoginAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: EdgeInsetsDirectional.only(start: 20),
        child: Text(AppStrings.loginTitle),
      ),
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _LoginListener {
  static void onStateChange(BuildContext context, LoginState state) {
    if (state.loginState.data != null) {
      Navigator.pushReplacementNamed(context, AppRoutsName.sectionApp);
    } else if (state.loginState.msg != null) {
      AppSnackBar.showError(
        context,
        state.loginState.msg!,
        icon: SvgPicture.asset(
          Assets.assetsIconsError,
          width: 22,
          height: 22,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      );
    }
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePasswordNotifier,
    required this.rememberMeNotifier,
    required this.onLoginPressed,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final ValueNotifier<bool> obscurePasswordNotifier;
  final ValueNotifier<bool> rememberMeNotifier;
  final VoidCallback onLoginPressed;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          const SizedBox(height: 16),

          TextFormField(
            controller: emailController,
            validator: (value) => AppValidations.validateEmail(value ?? ''),
            decoration: InputDecoration(
              labelText: AppStrings.emailLabel,
              hintText: AppStrings.emailHint,
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),

          ValueListenableBuilder<bool>(
            valueListenable: obscurePasswordNotifier,
            builder: (context, isObscured, child) {
              return TextFormField(
                controller: passwordController,
                obscureText: isObscured,
                validator: (value) =>
                    AppValidations.validatePassword(value ?? ''),
                decoration: InputDecoration(
                  labelText: AppStrings.passwordLabel,
                  hintText: AppStrings.passwordHint,
                  suffixIcon: IconButton(
                    onPressed: () =>
                        obscurePasswordNotifier.value = !isObscured,
                    icon: SvgPicture.asset(
                      isObscured
                          ? Assets.assetsIconsVisibilityOff
                          : Assets.assetsIconsVisibilityOn,
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        AppColors.grey,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: rememberMeNotifier,
                builder: (context, isRemembered, child) {
                  return Checkbox(
                    value: isRemembered,
                    onChanged: (v) => {
                      rememberMeNotifier.value = v ?? false,
                      context.read<LoginViewModel>().doEvent(
                        RememberMeEvent(rememberMe: v ?? false),
                      ),
                    },
                  );
                },
              ),
              Text(AppStrings.rememberMe),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutsName.forgetPasswordScreen,
                ),
                child: Text(
                  AppStrings.dontRememberYourPassword,
                  style: TextStyles.bodyRegularUnderLine13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onLoginPressed,
              child: Text(AppStrings.loginButton),
            ),
          ),

          const SizedBox(height: 24),
          const _SignUpLink(),
        ],
      ),
    );
  }
}

class _SignUpLink extends StatelessWidget {
  const _SignUpLink();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: AppStrings.dontHaveAccount,
          style: TextStyles.bodyRegular16,
          children: [
            TextSpan(
              text: AppStrings.signUp,
              style: TextStyles.bodyRegular16.copyWith(
                color: AppColors.pink,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.pink,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () =>
                    Navigator.pushNamed(context, AppRoutsName.applyScreen),
            ),
          ],
        ),
      ),
    );
  }
}
