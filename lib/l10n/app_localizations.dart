import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('es'),
    Locale('de'),
    Locale('en')
  ];

  /// Nombre visible de la aplicación
  ///
  /// In es, this message translates to:
  /// **'Tomora'**
  String get appTitle;

  /// No description provided for @navLibrary.
  ///
  /// In es, this message translates to:
  /// **'Biblioteca'**
  String get navLibrary;

  /// No description provided for @navRated.
  ///
  /// In es, this message translates to:
  /// **'Valorados'**
  String get navRated;

  /// No description provided for @navSettings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get navSettings;

  /// No description provided for @libraryTitle.
  ///
  /// In es, this message translates to:
  /// **'Mi biblioteca'**
  String get libraryTitle;

  /// No description provided for @ratedTitle.
  ///
  /// In es, this message translates to:
  /// **'Valorados'**
  String get ratedTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settingsTitle;

  /// No description provided for @searchBookHint.
  ///
  /// In es, this message translates to:
  /// **'Busca un libro'**
  String get searchBookHint;

  /// No description provided for @emptyLibrary.
  ///
  /// In es, this message translates to:
  /// **'Aún no has añadido ningún libro'**
  String get emptyLibrary;

  /// No description provided for @segmentAll.
  ///
  /// In es, this message translates to:
  /// **'Biblioteca'**
  String get segmentAll;

  /// No description provided for @segmentRead.
  ///
  /// In es, this message translates to:
  /// **'Leídos'**
  String get segmentRead;

  /// No description provided for @addBook.
  ///
  /// In es, this message translates to:
  /// **'Añadir libro'**
  String get addBook;

  /// No description provided for @editBook.
  ///
  /// In es, this message translates to:
  /// **'Editar libro'**
  String get editBook;

  /// No description provided for @authLoginHeading.
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión'**
  String get authLoginHeading;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Tu biblioteca, siempre contigo'**
  String get authLoginSubtitle;

  /// No description provided for @authRegisterHeading.
  ///
  /// In es, this message translates to:
  /// **'Crea tu cuenta'**
  String get authRegisterHeading;

  /// No description provided for @authRegisterSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Empieza a ordenar tus libros'**
  String get authRegisterSubtitle;

  /// No description provided for @authName.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get authName;

  /// No description provided for @authEmail.
  ///
  /// In es, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get authPassword;

  /// No description provided for @authPasswordRepeat.
  ///
  /// In es, this message translates to:
  /// **'Repite la contraseña'**
  String get authPasswordRepeat;

  /// No description provided for @authEnter.
  ///
  /// In es, this message translates to:
  /// **'Entrar'**
  String get authEnter;

  /// No description provided for @authCreateAccount.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get authCreateAccount;

  /// No description provided for @authNoAccount.
  ///
  /// In es, this message translates to:
  /// **'¿Aún no tienes cuenta? '**
  String get authNoAccount;

  /// No description provided for @authHaveAccount.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tienes cuenta? '**
  String get authHaveAccount;

  /// No description provided for @authInvalidEmail.
  ///
  /// In es, this message translates to:
  /// **'Introduce un email válido'**
  String get authInvalidEmail;

  /// No description provided for @authMinChars.
  ///
  /// In es, this message translates to:
  /// **'Mínimo 6 caracteres'**
  String get authMinChars;

  /// No description provided for @authWriteName.
  ///
  /// In es, this message translates to:
  /// **'Escribe tu nombre'**
  String get authWriteName;

  /// No description provided for @authPasswordsDontMatch.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get authPasswordsDontMatch;

  /// No description provided for @authOr.
  ///
  /// In es, this message translates to:
  /// **'o'**
  String get authOr;

  /// No description provided for @authGoogle.
  ///
  /// In es, this message translates to:
  /// **'Continuar con Google'**
  String get authGoogle;

  /// No description provided for @settingsAccount.
  ///
  /// In es, this message translates to:
  /// **'Cuenta'**
  String get settingsAccount;

  /// No description provided for @settingsLanguage.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get settingsLanguage;

  /// No description provided for @settingsFriends.
  ///
  /// In es, this message translates to:
  /// **'Amigos'**
  String get settingsFriends;

  /// No description provided for @settingsBackup.
  ///
  /// In es, this message translates to:
  /// **'Copia de seguridad'**
  String get settingsBackup;

  /// No description provided for @logout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get logout;

  /// No description provided for @backupExport.
  ///
  /// In es, this message translates to:
  /// **'Exportar'**
  String get backupExport;

  /// No description provided for @backupImport.
  ///
  /// In es, this message translates to:
  /// **'Importar'**
  String get backupImport;

  /// No description provided for @backupDone.
  ///
  /// In es, this message translates to:
  /// **'Hecho'**
  String get backupDone;

  /// No description provided for @backupEmpty.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay libros'**
  String get backupEmpty;

  /// No description provided for @backupCancelled.
  ///
  /// In es, this message translates to:
  /// **'Cancelado'**
  String get backupCancelled;

  /// No description provided for @backupFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo completar'**
  String get backupFailed;

  /// No description provided for @languageSpanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languageEnglish.
  ///
  /// In es, this message translates to:
  /// **'Inglés'**
  String get languageEnglish;

  /// No description provided for @languageGerman.
  ///
  /// In es, this message translates to:
  /// **'Alemán'**
  String get languageGerman;

  /// No description provided for @languageSystem.
  ///
  /// In es, this message translates to:
  /// **'Idioma del sistema'**
  String get languageSystem;

  /// No description provided for @referralTitle.
  ///
  /// In es, this message translates to:
  /// **'Invita y quítate los anuncios'**
  String get referralTitle;

  /// No description provided for @referralYourCode.
  ///
  /// In es, this message translates to:
  /// **'Tu código de invitación'**
  String get referralYourCode;

  /// No description provided for @referralCopied.
  ///
  /// In es, this message translates to:
  /// **'Código copiado'**
  String get referralCopied;

  /// No description provided for @referralRedeemedCount.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =0{Nadie ha usado tu código todavía} =1{1 persona ha usado tu código} other{{count} personas han usado tu código}}'**
  String referralRedeemedCount(int count);

  /// No description provided for @referralAdsFreeUntil.
  ///
  /// In es, this message translates to:
  /// **'Sin anuncios hasta el {date}'**
  String referralAdsFreeUntil(String date);

  /// No description provided for @referralHaveCodeHint.
  ///
  /// In es, this message translates to:
  /// **'¿Te han invitado? Código'**
  String get referralHaveCodeHint;

  /// No description provided for @referralRedeem.
  ///
  /// In es, this message translates to:
  /// **'Canjear'**
  String get referralRedeem;

  /// No description provided for @referralNeedLogin.
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión para invitar a amigos y quitarte los anuncios durante 3 meses por cada invitación.'**
  String get referralNeedLogin;

  /// No description provided for @referralOk.
  ///
  /// In es, this message translates to:
  /// **'¡Código canjeado!'**
  String get referralOk;

  /// No description provided for @referralUnknownCode.
  ///
  /// In es, this message translates to:
  /// **'Ese código no existe.'**
  String get referralUnknownCode;

  /// No description provided for @referralOwnCode.
  ///
  /// In es, this message translates to:
  /// **'No puedes usar tu propio código.'**
  String get referralOwnCode;

  /// No description provided for @referralAlreadyRedeemed.
  ///
  /// In es, this message translates to:
  /// **'Ya canjeaste un código.'**
  String get referralAlreadyRedeemed;

  /// No description provided for @referralTooLate.
  ///
  /// In es, this message translates to:
  /// **'Fuera de plazo para canjear un código.'**
  String get referralTooLate;

  /// No description provided for @referralRedeemFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo canjear. Inténtalo de nuevo.'**
  String get referralRedeemFailed;

  /// No description provided for @friendsTitle.
  ///
  /// In es, this message translates to:
  /// **'Amigos'**
  String get friendsTitle;

  /// No description provided for @friendsEmpty.
  ///
  /// In es, this message translates to:
  /// **'Todavía no tienes amigos añadidos'**
  String get friendsEmpty;

  /// No description provided for @friendsAddHint.
  ///
  /// In es, this message translates to:
  /// **'Código de invitación de tu amigo'**
  String get friendsAddHint;

  /// No description provided for @friendsAdd.
  ///
  /// In es, this message translates to:
  /// **'Añadir'**
  String get friendsAdd;

  /// No description provided for @friendsRemove.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get friendsRemove;

  /// No description provided for @friendsRemoveConfirmTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar amigo'**
  String get friendsRemoveConfirmTitle;

  /// No description provided for @friendsRemoveConfirmBody.
  ///
  /// In es, this message translates to:
  /// **'Se eliminará a {name} de tus amigos y dejaréis de compartir información. Esta acción no se puede deshacer.'**
  String friendsRemoveConfirmBody(String name);

  /// No description provided for @friendsAddedOk.
  ///
  /// In es, this message translates to:
  /// **'Amigo añadido'**
  String get friendsAddedOk;

  /// No description provided for @friendsAddSelf.
  ///
  /// In es, this message translates to:
  /// **'Ese es tu propio código.'**
  String get friendsAddSelf;

  /// No description provided for @friendsAddUnknown.
  ///
  /// In es, this message translates to:
  /// **'No hay ninguna cuenta con ese código.'**
  String get friendsAddUnknown;

  /// No description provided for @friendsAddAlready.
  ///
  /// In es, this message translates to:
  /// **'Ya sois amigos.'**
  String get friendsAddAlready;

  /// No description provided for @friendsAddFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo añadir. Inténtalo de nuevo.'**
  String get friendsAddFailed;

  /// No description provided for @friendsRemoveFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo eliminar. Inténtalo de nuevo.'**
  String get friendsRemoveFailed;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;
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
      <String>['de', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
