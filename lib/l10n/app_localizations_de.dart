// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Tomora';

  @override
  String get navLibrary => 'Bibliothek';

  @override
  String get navRated => 'Bewertet';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get libraryTitle => 'Meine Bibliothek';

  @override
  String get ratedTitle => 'Bewertet';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get searchBookHint => 'Buch suchen';

  @override
  String get emptyLibrary => 'Du hast noch keine Bücher hinzugefügt';

  @override
  String get segmentAll => 'Bibliothek';

  @override
  String get segmentRead => 'Gelesen';

  @override
  String get addBook => 'Buch hinzufügen';

  @override
  String get editBook => 'Buch bearbeiten';

  @override
  String get authLoginHeading => 'Anmelden';

  @override
  String get authLoginSubtitle => 'Deine Bibliothek, immer dabei';

  @override
  String get authRegisterHeading => 'Konto erstellen';

  @override
  String get authRegisterSubtitle => 'Bring Ordnung in deine Bücher';

  @override
  String get authName => 'Name';

  @override
  String get authEmail => 'E-Mail';

  @override
  String get authPassword => 'Passwort';

  @override
  String get authPasswordRepeat => 'Passwort wiederholen';

  @override
  String get authEnter => 'Anmelden';

  @override
  String get authCreateAccount => 'Konto erstellen';

  @override
  String get authNoAccount => 'Noch kein Konto? ';

  @override
  String get authHaveAccount => 'Schon ein Konto? ';

  @override
  String get authInvalidEmail => 'Gib eine gültige E-Mail ein';

  @override
  String get authMinChars => 'Mindestens 6 Zeichen';

  @override
  String get authWriteName => 'Gib deinen Namen ein';

  @override
  String get authPasswordsDontMatch => 'Die Passwörter stimmen nicht überein';

  @override
  String get authOr => 'oder';

  @override
  String get authGoogle => 'Mit Google fortfahren';

  @override
  String get settingsAccount => 'Konto';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsFriends => 'Freunde';

  @override
  String get settingsBackup => 'Sicherung';

  @override
  String get logout => 'Abmelden';

  @override
  String get backupExport => 'Exportieren';

  @override
  String get backupImport => 'Importieren';

  @override
  String get backupDone => 'Fertig';

  @override
  String get backupEmpty => 'Noch keine Bücher';

  @override
  String get backupCancelled => 'Abgebrochen';

  @override
  String get backupFailed => 'Konnte nicht abgeschlossen werden';

  @override
  String get languageSpanish => 'Spanisch';

  @override
  String get languageEnglish => 'Englisch';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageSystem => 'Systemsprache';

  @override
  String get referralTitle => 'Freunde einladen, Werbung entfernen';

  @override
  String get referralYourCode => 'Dein Einladungscode';

  @override
  String get referralCopied => 'Code kopiert';

  @override
  String referralRedeemedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Personen haben deinen Code benutzt',
      one: '1 Person hat deinen Code benutzt',
      zero: 'Noch niemand hat deinen Code benutzt',
    );
    return '$_temp0';
  }

  @override
  String referralAdsFreeUntil(String date) {
    return 'Werbefrei bis $date';
  }

  @override
  String get referralHaveCodeHint => 'Eingeladen worden? Code';

  @override
  String get referralRedeem => 'Einlösen';

  @override
  String get referralNeedLogin =>
      'Melde dich an, um Freunde einzuladen und pro Einladung 3 werbefreie Monate zu bekommen.';

  @override
  String get referralOk => 'Code eingelöst!';

  @override
  String get referralUnknownCode => 'Diesen Code gibt es nicht.';

  @override
  String get referralOwnCode => 'Du kannst deinen eigenen Code nicht benutzen.';

  @override
  String get referralAlreadyRedeemed => 'Du hast bereits einen Code eingelöst.';

  @override
  String get referralTooLate =>
      'Die Frist zum Einlösen eines Codes ist abgelaufen.';

  @override
  String get referralRedeemFailed =>
      'Einlösen fehlgeschlagen. Versuch es erneut.';

  @override
  String get friendsTitle => 'Freunde';

  @override
  String get friendsEmpty => 'Du hast noch keine Freunde hinzugefügt';

  @override
  String get friendsAddHint => 'Einladungscode deines Freundes';

  @override
  String get friendsAdd => 'Hinzufügen';

  @override
  String get friendsRemove => 'Entfernen';

  @override
  String get friendsRemoveConfirmTitle => 'Freund entfernen';

  @override
  String friendsRemoveConfirmBody(String name) {
    return '$name wird aus deinen Freunden entfernt und ihr teilt keine Informationen mehr. Das kann nicht rückgängig gemacht werden.';
  }

  @override
  String get friendsAddedOk => 'Freund hinzugefügt';

  @override
  String get friendsAddSelf => 'Das ist dein eigener Code.';

  @override
  String get friendsAddUnknown => 'Kein Konto mit diesem Code.';

  @override
  String get friendsAddAlready => 'Ihr seid bereits Freunde.';

  @override
  String get friendsAddFailed =>
      'Hinzufügen fehlgeschlagen. Versuch es erneut.';

  @override
  String get friendsRemoveFailed =>
      'Entfernen fehlgeschlagen. Versuch es erneut.';

  @override
  String get cancel => 'Abbrechen';
}
