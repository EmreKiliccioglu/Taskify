// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get all => 'Tümü';

  @override
  String get completed => 'Tamamlanan';

  @override
  String get active => 'Aktif';

  @override
  String get settings => 'Ayarlar';

  @override
  String get darkTheme => 'Koyu Tema';

  @override
  String get darkThemeEnabled => 'Koyu tema açık';

  @override
  String get lightThemeEnabled => 'Açık tema açık';

  @override
  String get language => 'Dil';

  @override
  String get name => 'İsim';

  @override
  String get surName => 'Soyisim';

  @override
  String get login => 'Giriş Yap';

  @override
  String get register => 'Kayıt Ol';

  @override
  String get email => 'E-posta';

  @override
  String get forgotPassword => 'Şifremi unuttum?';

  @override
  String get signInWithGoogle => 'Google ile giriş yap';

  @override
  String get confirmPassword => 'Şifreyi Tekrar Girin';

  @override
  String get passwordsDoNotMatch => 'Şifreler eşleşmiyor!';

  @override
  String get enterFullName => 'Lütfen ad ve soyad girin!';

  @override
  String get forgotPassword_description =>
      'Kayıt olurken kullandığın e-posta adresini gir. Sana sıfırlama bağlantısı gönderelim.';

  @override
  String get forgotPassword_sendButton => 'Şifre Sıfırlama E-postası Gönder';

  @override
  String get forgotPassword_emptyEmail => 'Lütfen e-posta adresinizi girin';

  @override
  String get forgotPassword_emailSent => 'Şifre sıfırlama e-postası gönderildi';

  @override
  String get forgotPassword_title => 'Şifreni Sıfırla';

  @override
  String get forgotPassword_userNotFound =>
      'Bu e-posta ile kayıtlı kullanıcı bulunamadı';

  @override
  String get error_invalidEmail => 'Geçersiz e-posta adresi.';

  @override
  String get error_userNotFound =>
      'Bu e-posta ile kayıtlı kullanıcı bulunamadı.';

  @override
  String get error_wrongPassword => 'Şifre yanlış.';

  @override
  String get error_emailInUse => 'Bu e-posta zaten kullanılıyor.';

  @override
  String get error_weakPassword => 'Şifre çok zayıf.';

  @override
  String get error_channel => 'Lütfen tüm alanları doldurun.';

  @override
  String get logout => 'Logout';

  @override
  String get loggedOut => 'Logged Out';

  @override
  String get key => 'Şifre';

  @override
  String get error => 'Hata';

  @override
  String get error_general => 'Bir hata oluştu. Lütfen tekrar deneyin.';

  @override
  String get error_unknown => 'Bir şeyler ters gitti. Lütfen tekrar deneyin.';

  @override
  String get loginSuccess => 'Giriş başarılı!';

  @override
  String get googleLoginSuccess => 'Google ile giriş başarılı!';

  @override
  String get registerSuccess => 'Kayıt başarılı!';
}
