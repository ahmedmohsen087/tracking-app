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
  static String get welcomeToFloweryRiderApp =>
      'welcomeToFloweryRiderApp'.tr();
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
  static String get seenOnboardingReadFailed =>
      'seenOnboardingReadFailed'.tr();

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
  static String get email => 'email'.tr();
  static String get enterYourEmail => 'enterYourEmail'.tr();
  static String get emailVerification => 'EmailVerification'.tr();
  static String get pleaseEnterYourEmailAssociatedToYourAccount =>
  'Please enter your email associated to \n your account'.tr();
  static String get pleaseEnterYourCodeThatSendToYourEmailAddress =>
  'Please enter your code that send to your \n email address'.tr();
  static String get didntReceiveCode => 'Did\'nTReceiveCode ?'.tr();
  static String get resend => ' Resend'.tr();


  // Validation - phone
  static String get phoneRequired => 'phoneRequired'.tr();
  static String get phoneInvalid => 'phoneInvalid'.tr();

  // Validation - password
  static String get passwordRequired => 'passwordRequired'.tr();
  static String get passwordWeak => 'passwordWeak'.tr();
  static String get confirmPasswordRequired => 'confirmPasswordRequired'.tr();
  static String get passwordDoNotMatch => 'passwordDoNotMatch'.tr();
  static String get password => 'password'.tr();
  static String get forgetPassword => 'ForgetPassword'.tr();
  static String get confirm => 'Confirm'.tr();





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
}
