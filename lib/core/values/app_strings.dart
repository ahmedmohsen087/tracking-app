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

  // Bottom navigation
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
  static String get email => 'email'.tr();
  static String get enterYourEmail => 'enterYourEmail'.tr();
  static String get emailVerification => 'emailVerification'.tr();
  static String get pleaseEnterYourEmailAssociated =>
      'pleaseEnterYourEmailAssociated'.tr();
  static String get pleaseEnterYourCode => 'pleaseEnterYourCode'.tr();
  static String get didntReceiveCode => 'didntReceiveCode'.tr();
  static String get resend => 'resend'.tr();

  // Validation - phone
  static String get phoneRequired => 'phoneRequired'.tr();
  static String get phoneInvalid => 'phoneInvalid'.tr();

  // Validation - password
  static String get passwordRequired => 'passwordRequired'.tr();
  static String get passwordWeak => 'passwordWeak'.tr();
  static String get confirmPasswordRequired => 'confirmPasswordRequired'.tr();
  static String get passwordDoNotMatch => 'passwordDoNotMatch'.tr();
  static String get password => 'password'.tr();
  static String get forgetPassword => 'forgetPassword'.tr();
  static String get confirm => 'confirm'.tr();
  static String get resetPassword => 'resetPassword'.tr();
  static String get passwordMustNotBeEmpty => 'passwordMustNotBeEmpty'.tr();
  static String get newPassword => 'newPassword'.tr();
  static String get enterYourPassword => 'enterYourPassword'.tr();
  static String get enterPassword => 'enterPassword'.tr();
  static String get confirmPassword => 'confirmPassword'.tr();

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
  // Logout
  static String get logout => 'logout'.tr();
  static String get confirmLogout => 'confirmLogout'.tr();
  // login screen
  static String get loginTitle => 'login'.tr();
  static String get emailLabel => 'email'.tr();
  static String get emailHint => 'enterYourEmail'.tr();
  static String get passwordLabel => 'password'.tr();
  static String get passwordHint => 'enterYourPassword'.tr();
  static String get rememberMe => 'rememberMe'.tr();
  static String get dontRememberYourPassword => 'dontRememberYourPassword'.tr();
  static String get loginButton => 'login'.tr();
  static String get continueAsGuest => 'continueAsGuest'.tr();
  static String get dontHaveAccount => "dontHaveAccount".tr();
  static String get signUp => 'signUp'.tr();

  // Apply
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
  static String get phoneNumber => 'phoneNumber'.tr();
  static String get enterPhoneNumber => 'enterPhoneNumber'.tr();
  static String get idNumber => 'idNumber'.tr();
  static String get enterNationalIdNumber => 'enterNationalIdNumber'.tr();
  static String get idImage => 'idImage'.tr();
  static String get uploadIdImage => 'uploadIdImage'.tr();
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

  // Apply - success screen
  static String get applicationSubmitted => 'applicationSubmitted'.tr();
  static String get applicationSubmittedSubtitle =>
      'applicationSubmittedSubtitle'.tr();

  // Apply screen - permission dialog
  static String get permissionRequired => 'permissionRequired'.tr();
  static String get photoPermanentlyDenied => 'photoPermanentlyDenied'.tr();
  static String get openSettings => 'openSettings'.tr();
  static String get photoDenied => 'photoDenied'.tr();
  static String get cameraPermanentlyDenied => 'cameraPermanentlyDenied'.tr();
  static String get cameraDenied => 'cameraDenied'.tr();
  static String get chooseImageSource => 'chooseImageSource'.tr();
  static String get takePhoto => 'takePhoto'.tr();
  static String get chooseFromGallery => 'chooseFromGallery'.tr();
  // change password
  static String get passwordUpdated => 'passwordUpdated'.tr();
  static String get currentPassword => 'currentPassword'.tr();
  static String get changePassword => 'changePassword'.tr();
  static String get update => 'update'.tr();
  static String get editProfile => 'editProfile'.tr();
  static String get updateProfile => 'updateProfile'.tr();
  static String get profileUpdatedSuccessfully =>
      'profileUpdatedSuccessfully'.tr();
  static String get photoUploadedSuccessfully =>
      'photoUploadedSuccessfully'.tr();
  static String get firstName => 'firstName'.tr();
  static String get lastName => 'lastName'.tr();
  static String get vehicleInfoUpdatedSuccessfully =>
      'vehicleInfoUpdatedSuccessfully'.tr();
  static String get editVehicleInfo => 'editVehicleInfo'.tr();

  // flower order
  static String get flowerOrder => 'flowerOrder'.tr();
  static String get pickupAddress => 'pickupAddress'.tr();
  static String get userAddress => 'userAddress'.tr();
  static String get reject => 'reject'.tr();
  static String get accept => 'accept'.tr();
  static String get myOrders => 'myOrders'.tr();
  static String get cancelled => 'cancelled'.tr();
  static String get completed => 'completed'.tr();
  static String get recentOrders => 'recentOrders'.tr();

  // profile
  static String get vehicleInfo => 'vehicleInfo'.tr();
  static String get language => 'language'.tr();
  static String get english => 'english'.tr();
  static String get noProfileDataAvailable => 'noProfileDataAvailable'.tr();
  // forget password
  static String get pleaseEnterYourEmailAssociatedToYourAccount =>
      'pleaseEnterYourEmailAssociatedToYourAccount'.tr();
  static String get didntReciveCode => 'didntReciveCode'.tr();
  static String get hitTextForResetPassword => 'hitTextForResetPassword'.tr();
}
