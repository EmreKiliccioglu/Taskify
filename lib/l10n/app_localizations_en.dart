// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get all => 'All';

  @override
  String get completed => 'Completed';

  @override
  String get active => 'Active';

  @override
  String get settings => 'Settings';

  @override
  String get darkTheme => 'Dark Theme';

  @override
  String get darkThemeEnabled => 'Dark mode enabled';

  @override
  String get lightThemeEnabled => 'Light mode enabled';

  @override
  String get language => 'Language';

  @override
  String get name => 'Name';

  @override
  String get surName => 'Surname';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'E-mail';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get confirmPassword => 'Re-enter Password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match!';

  @override
  String get enterFullName => 'Please enter your full name!';

  @override
  String get forgotPassword_description =>
      'Enter the email address you used during registration. We will send you a reset link.';

  @override
  String get forgotPassword_sendButton => 'Send Password Reset Email';

  @override
  String get forgotPassword_emptyEmail => 'Please enter your email address';

  @override
  String get forgotPassword_emailSent => 'Password reset email has been sent';

  @override
  String get forgotPassword_title => 'Reset Your Password';

  @override
  String get forgotPassword_userNotFound =>
      'No user found with this email address';

  @override
  String get error_invalidEmail => 'Invalid email address.';

  @override
  String get error_userNotFound => 'No user found with this email.';

  @override
  String get error_wrongPassword => 'The password is incorrect.';

  @override
  String get error_emailInUse => 'This email is already in use.';

  @override
  String get error_weakPassword => 'The password is too weak.';

  @override
  String get error_channel => 'Please fill in all fields.';

  @override
  String get logout => 'Logout';

  @override
  String get loggedOut => 'Logged Out';

  @override
  String get key => 'Key';

  @override
  String get error => 'Error';

  @override
  String get error_general => 'An error occurred. Please try again.';

  @override
  String get error_unknown => 'Something went wrong. Please try again.';

  @override
  String get loginSuccess => 'Login successful!';

  @override
  String get googleLoginSuccess => 'Google login successful!';

  @override
  String get registerSuccess => 'Registration successful!';
}
