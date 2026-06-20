import 'package:easy_localization/easy_localization.dart';

class AppStrings {
  // General
  static String get appName => 'appName'.tr();
  static String get routeNotFound => 'routeNotFound'.tr();
  static String get loading => 'loading'.tr();
  static String get cancel => 'cancel'.tr();
  static String get close => 'close'.tr();
  static String get error => 'error'.tr();
  static String get retry => 'retry'.tr();
  static String get home => 'home'.tr();
  static String get orders => 'orders'.tr();
  static String get profile => 'profile'.tr();

  // Splash / onboarding
  static String get welcomeToFloweryRiderApp => 'welcomeToFloweryRiderApp'.tr();
  static String get login => 'login'.tr();
  static String get applyNow => 'applyNow'.tr();

  // Secure storage - token
  static String get tokenEmpty => 'tokenEmpty'.tr();
  static String get tokenWriteFailed => 'tokenWriteFailed'.tr();
  static String get tokenReadFailed => 'tokenReadFailed'.tr();
  static String get tokenDeleteFailed => 'tokenDeleteFailed'.tr();

  // Secure storage - user id
  static String get userIdEmpty => 'userIdEmpty'.tr();
  static String get userIdWriteFailed => 'userIdWriteFailed'.tr();
  static String get userIdReadFailed => 'userIdReadFailed'.tr();
  static String get userIdDeleteFailed => 'userIdDeleteFailed'.tr();

  // Secure storage - remember me
  static String get rememberMeWriteFailed => 'rememberMeWriteFailed'.tr();
  static String get rememberMeReadFailed => 'rememberMeReadFailed'.tr();
  static String get rememberMeDeleteFailed => 'rememberMeDeleteFailed'.tr();

  // Secure storage - onboarding
  static String get seenOnboardingWriteFailed =>
      'seenOnboardingWriteFailed'.tr();
  static String get seenOnboardingReadFailed => 'seenOnboardingReadFailed'.tr();

  // Secure storage - general
  static String get clearStorageFailed => 'clearStorageFailed'.tr();

  // Validation - name
  static String get firstNameRequired => 'firstNameRequired'.tr();
  static String get lastNameRequired => 'lastNameRequired'.tr();
  static String get nameInvalid => 'nameInvalid'.tr();
  static String get nameTooShort => 'nameTooShort'.tr();
  static String get nameTooLong => 'nameTooLong'.tr();

  // Validation - email
  static String get emailRequired => 'emailRequired'.tr();
  static String get emailInvalid => 'emailInvalid'.tr();

  // Validation - phone
  static String get phoneRequired => 'phoneRequired'.tr();
  static String get phoneInvalid => 'phoneInvalid'.tr();

  // Validation - password
  static String get passwordRequired => 'passwordRequired'.tr();
  static String get passwordWeak => 'passwordWeak'.tr();
  static String get confirmPasswordRequired => 'confirmPasswordRequired'.tr();
  static String get passwordDoNotMatch => 'passwordDoNotMatch'.tr();

  // Validation - otp
  static String get otpEmpty => 'otpEmpty'.tr();
  static String get otpInvalid => 'otpInvalid'.tr();
  static String get otpLength => 'otpLength'.tr();

  // Error handling
  static String get noInternetConnection => 'noInternetConnection'.tr();
  static String get connectionTimeout => 'connectionTimeout'.tr();
  static String get requestCancelled => 'requestCancelled'.tr();
  static String get badCertificate => 'badCertificate'.tr();
  static String get somethingWentWrong => 'somethingWentWrong'.tr();

  // Apply screen
  static String get apply => 'apply'.tr();

  static String get welcomeExclamation => 'welcomeExclamation'.tr();

  static String get applySubtitle => 'applySubtitle'.tr();

  static String get country => 'country'.tr();

  static String get firstLegalName => 'firstLegalName'.tr();

  static String get enterFirstLegalName => 'enterFirstLegalName'.tr();

  static String get secondLegalName => 'secondLegalName'.tr();

  static String get enterSecondLegalName => 'enterSecondLegalName'.tr();

  static String get vehicleType => 'vehicleType'.tr();

  static String get vehicleNumber => 'vehicleNumber'.tr();

  static String get enterVehicleNumber => 'enterVehicleNumber'.tr();

  static String get vehicleLicense => 'vehicleLicense'.tr();

  static String get uploadLicensePhoto => 'uploadLicensePhoto'.tr();

  static String get enterYourEmail => 'enterYourEmail'.tr();

  static String get phoneNumber => 'phoneNumber'.tr();

  static String get enterPhoneNumber => 'enterPhoneNumber'.tr();

  static String get idNumber => 'idNumber'.tr();

  static String get enterNationalIdNumber => 'enterNationalIdNumber'.tr();

  static String get idImage => 'idImage'.tr();

  static String get uploadIdImage => 'uploadIdImage'.tr();

  static String get enterPassword => 'enterPassword'.tr();

  static String get confirmPassword => 'confirmPassword'.tr();

  static String get gender => 'gender'.tr();

  static String get female => 'female'.tr();

  static String get male => 'male'.tr();

  static String get continueText => 'continueText'.tr();

  static String get countryRequired => 'countryRequired'.tr();

  static String get vehicleTypeRequired => 'vehicleTypeRequired'.tr();

  static String get vehicleNumberRequired => 'vehicleNumberRequired'.tr();

  static String get vehicleLicenseRequired => 'vehicleLicenseRequired'.tr();

  static String get idNumberRequired => 'idNumberRequired'.tr();

  static String get idImageRequired => 'idImageRequired'.tr();

  static String get genderRequired => 'genderRequired'.tr();

  // Success apply screen
  static String get applicationSubmitted => 'applicationSubmitted'.tr();

  static String get applicationSubmittedSubtitle =>
      'applicationSubmittedSubtitle'.tr();
  static String get loginTitle => 'Login'.tr();
  static String get emailLabel => 'Email'.tr();
  static String get emailHint => 'Enter your email'.tr();
  static String get passwordLabel => 'Password'.tr();
  static String get passwordHint => 'Enter your password'.tr();
  static String get rememberMe => 'Remember me'.tr();
  static String get forgetPassword => 'Forget password?'.tr();
  static String get loginButton => 'Login'.tr();
  static String get continueAsGuest => 'Continue as guest'.tr();
  static String get dontHaveAccount => "Don't have an account? ".tr();
  static String get signUp => 'Sign up'.tr();
}
