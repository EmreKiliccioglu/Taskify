import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @all.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get all;

  /// No description provided for @completed.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlanan'**
  String get completed;

  /// No description provided for @active.
  ///
  /// In tr, this message translates to:
  /// **'Aktif'**
  String get active;

  /// No description provided for @settings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settings;

  /// No description provided for @darkTheme.
  ///
  /// In tr, this message translates to:
  /// **'Koyu Tema'**
  String get darkTheme;

  /// No description provided for @darkThemeEnabled.
  ///
  /// In tr, this message translates to:
  /// **'Koyu tema açık'**
  String get darkThemeEnabled;

  /// No description provided for @lightThemeEnabled.
  ///
  /// In tr, this message translates to:
  /// **'Açık tema açık'**
  String get lightThemeEnabled;

  /// No description provided for @language.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get language;

  /// No description provided for @name.
  ///
  /// In tr, this message translates to:
  /// **'İsim'**
  String get name;

  /// No description provided for @surName.
  ///
  /// In tr, this message translates to:
  /// **'Soyisim'**
  String get surName;

  /// No description provided for @login.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap'**
  String get login;

  /// No description provided for @register.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt Ol'**
  String get register;

  /// No description provided for @email.
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get email;

  /// No description provided for @forgotPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifremi unuttum?'**
  String get forgotPassword;

  /// No description provided for @signInWithGoogle.
  ///
  /// In tr, this message translates to:
  /// **'Google ile giriş yap'**
  String get signInWithGoogle;

  /// No description provided for @confirmPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi Tekrar Girin'**
  String get confirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In tr, this message translates to:
  /// **'Şifreler eşleşmiyor!'**
  String get passwordsDoNotMatch;

  /// No description provided for @enterFullName.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen ad ve soyad girin!'**
  String get enterFullName;

  /// No description provided for @forgotPassword_description.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt olurken kullandığın e-posta adresini gir. Sana sıfırlama bağlantısı gönderelim.'**
  String get forgotPassword_description;

  /// No description provided for @forgotPassword_sendButton.
  ///
  /// In tr, this message translates to:
  /// **'Şifre Sıfırlama E-postası Gönder'**
  String get forgotPassword_sendButton;

  /// No description provided for @forgotPassword_emptyEmail.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen e-posta adresinizi girin'**
  String get forgotPassword_emptyEmail;

  /// No description provided for @forgotPassword_emailSent.
  ///
  /// In tr, this message translates to:
  /// **'Şifre sıfırlama e-postası gönderildi'**
  String get forgotPassword_emailSent;

  /// No description provided for @forgotPassword_title.
  ///
  /// In tr, this message translates to:
  /// **'Şifreni Sıfırla'**
  String get forgotPassword_title;

  /// No description provided for @forgotPassword_userNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Bu e-posta ile kayıtlı kullanıcı bulunamadı'**
  String get forgotPassword_userNotFound;

  /// No description provided for @error_invalidEmail.
  ///
  /// In tr, this message translates to:
  /// **'Geçersiz e-posta adresi.'**
  String get error_invalidEmail;

  /// No description provided for @error_userNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Bu e-posta ile kayıtlı kullanıcı bulunamadı.'**
  String get error_userNotFound;

  /// No description provided for @error_wrongPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifre yanlış.'**
  String get error_wrongPassword;

  /// No description provided for @error_emailInUse.
  ///
  /// In tr, this message translates to:
  /// **'Bu e-posta zaten kullanılıyor.'**
  String get error_emailInUse;

  /// No description provided for @error_weakPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifre çok zayıf.'**
  String get error_weakPassword;

  /// No description provided for @error_channel.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen tüm alanları doldurun.'**
  String get error_channel;

  /// No description provided for @logout.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış Yap'**
  String get logout;

  /// No description provided for @loggedOut.
  ///
  /// In tr, this message translates to:
  /// **'Logged Out'**
  String get loggedOut;

  /// No description provided for @key.
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get key;

  /// No description provided for @error.
  ///
  /// In tr, this message translates to:
  /// **'Hata'**
  String get error;

  /// No description provided for @error_general.
  ///
  /// In tr, this message translates to:
  /// **'Bir hata oluştu. Lütfen tekrar deneyin.'**
  String get error_general;

  /// No description provided for @error_unknown.
  ///
  /// In tr, this message translates to:
  /// **'Bir şeyler ters gitti. Lütfen tekrar deneyin.'**
  String get error_unknown;

  /// No description provided for @loginSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Giriş başarılı!'**
  String get loginSuccess;

  /// No description provided for @googleLoginSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Google ile giriş başarılı!'**
  String get googleLoginSuccess;

  /// No description provided for @registerSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt başarılı!'**
  String get registerSuccess;

  /// No description provided for @noTaskForToday.
  ///
  /// In tr, this message translates to:
  /// **'Bugün için bir görev eklenmedi'**
  String get noTaskForToday;

  /// No description provided for @cancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In tr, this message translates to:
  /// **'Evet'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get delete;

  /// No description provided for @taskCompletedQuestion.
  ///
  /// In tr, this message translates to:
  /// **'Görev tamamlandı mı?'**
  String get taskCompletedQuestion;

  /// No description provided for @reactivateTaskQuestion.
  ///
  /// In tr, this message translates to:
  /// **'Görev tekrar aktif olsun mu?'**
  String get reactivateTaskQuestion;

  /// No description provided for @markTaskCompletedConfirmation.
  ///
  /// In tr, this message translates to:
  /// **'Bu görevi tamamlandı olarak işaretlemek istiyor musunuz?'**
  String get markTaskCompletedConfirmation;

  /// No description provided for @reactivateTaskConfirmation.
  ///
  /// In tr, this message translates to:
  /// **'Bu görevi tekrar aktif hale getirmek istiyor musunuz?'**
  String get reactivateTaskConfirmation;

  /// No description provided for @deleteTaskQuestion.
  ///
  /// In tr, this message translates to:
  /// **'Görev silinsin mi?'**
  String get deleteTaskQuestion;

  /// No description provided for @deleteTaskConfirmation.
  ///
  /// In tr, this message translates to:
  /// **'Bu görevi kalıcı olarak silmek istiyor musunuz?'**
  String get deleteTaskConfirmation;

  /// No description provided for @reminderAtTime.
  ///
  /// In tr, this message translates to:
  /// **'Zamanında'**
  String get reminderAtTime;

  /// No description provided for @reminderMinutesBefore.
  ///
  /// In tr, this message translates to:
  /// **'{minutes} dk önce'**
  String reminderMinutesBefore(Object minutes);

  /// No description provided for @createTask.
  ///
  /// In tr, this message translates to:
  /// **'Görev Oluştur'**
  String get createTask;

  /// No description provided for @selectDate.
  ///
  /// In tr, this message translates to:
  /// **'Tarih Seç'**
  String get selectDate;

  /// No description provided for @selectTime.
  ///
  /// In tr, this message translates to:
  /// **'Saat Seç'**
  String get selectTime;

  /// No description provided for @voiceAnalysisCompleted.
  ///
  /// In tr, this message translates to:
  /// **'Ses analizi tamamlandı'**
  String get voiceAnalysisCompleted;

  /// No description provided for @taskName.
  ///
  /// In tr, this message translates to:
  /// **'Görev Adı'**
  String get taskName;

  /// No description provided for @enterTitle.
  ///
  /// In tr, this message translates to:
  /// **'Başlık Giriniz'**
  String get enterTitle;

  /// No description provided for @details.
  ///
  /// In tr, this message translates to:
  /// **'Detaylar'**
  String get details;

  /// No description provided for @enterTaskDetails.
  ///
  /// In tr, this message translates to:
  /// **'Görev İçeriğini Yazınız'**
  String get enterTaskDetails;

  /// No description provided for @schedule.
  ///
  /// In tr, this message translates to:
  /// **'Zamanlama'**
  String get schedule;

  /// No description provided for @reminder.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcı'**
  String get reminder;

  /// No description provided for @reminder5MinBefore.
  ///
  /// In tr, this message translates to:
  /// **'5 dk önce'**
  String get reminder5MinBefore;

  /// No description provided for @reminder15MinBefore.
  ///
  /// In tr, this message translates to:
  /// **'15 dk önce'**
  String get reminder15MinBefore;

  /// No description provided for @reminder30MinBefore.
  ///
  /// In tr, this message translates to:
  /// **'30 dk önce'**
  String get reminder30MinBefore;

  /// No description provided for @reminder1HourBefore.
  ///
  /// In tr, this message translates to:
  /// **'1 saat önce'**
  String get reminder1HourBefore;

  /// No description provided for @fillRequiredFields.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen gerekli alanları doldurun'**
  String get fillRequiredFields;

  /// No description provided for @userNotAuthenticated.
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı doğrulanamadı'**
  String get userNotAuthenticated;

  /// No description provided for @notifications.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get notifications;

  /// No description provided for @account.
  ///
  /// In tr, this message translates to:
  /// **'Hesabım'**
  String get account;

  /// No description provided for @today.
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get today;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
