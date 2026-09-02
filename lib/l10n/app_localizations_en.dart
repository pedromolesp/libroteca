// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tomora';

  @override
  String get navLibrary => 'Library';

  @override
  String get navRated => 'Rated';

  @override
  String get navSettings => 'Settings';

  @override
  String get libraryTitle => 'My library';

  @override
  String get ratedTitle => 'Rated';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get searchBookHint => 'Search a book';

  @override
  String get emptyLibrary => 'You haven\'t added any books yet';

  @override
  String get segmentAll => 'Library';

  @override
  String get segmentRead => 'Read';

  @override
  String get addBook => 'Add book';

  @override
  String get editBook => 'Edit book';

  @override
  String get authLoginHeading => 'Sign in';

  @override
  String get authLoginSubtitle => 'Your library, always with you';

  @override
  String get authRegisterHeading => 'Create your account';

  @override
  String get authRegisterSubtitle => 'Start organising your books';

  @override
  String get authName => 'Name';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authPasswordRepeat => 'Repeat password';

  @override
  String get authEnter => 'Sign in';

  @override
  String get authCreateAccount => 'Create account';

  @override
  String get authNoAccount => 'No account yet? ';

  @override
  String get authHaveAccount => 'Already have an account? ';

  @override
  String get authInvalidEmail => 'Enter a valid email';

  @override
  String get authMinChars => 'At least 6 characters';

  @override
  String get authWriteName => 'Enter your name';

  @override
  String get authPasswordsDontMatch => 'Passwords don\'t match';

  @override
  String get authOr => 'or';

  @override
  String get authGoogle => 'Continue with Google';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsFriends => 'Friends';

  @override
  String get settingsBackup => 'Backup';

  @override
  String get logout => 'Sign out';

  @override
  String get backupExport => 'Export';

  @override
  String get backupImport => 'Import';

  @override
  String get backupDone => 'Done';

  @override
  String get backupEmpty => 'No books yet';

  @override
  String get backupCancelled => 'Cancelled';

  @override
  String get backupFailed => 'Couldn\'t complete';

  @override
  String get languageSpanish => 'Spanish';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageGerman => 'German';

  @override
  String get languageSystem => 'System language';

  @override
  String get referralTitle => 'Invite friends, remove ads';

  @override
  String get referralYourCode => 'Your invite code';

  @override
  String get referralCopied => 'Code copied';

  @override
  String referralRedeemedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people have used your code',
      one: '1 person has used your code',
      zero: 'Nobody has used your code yet',
    );
    return '$_temp0';
  }

  @override
  String referralAdsFreeUntil(String date) {
    return 'Ad-free until $date';
  }

  @override
  String get referralHaveCodeHint => 'Got invited? Code';

  @override
  String get referralRedeem => 'Redeem';

  @override
  String get referralNeedLogin =>
      'Sign in to invite friends and get 3 ad-free months per invite.';

  @override
  String get referralOk => 'Code redeemed!';

  @override
  String get referralUnknownCode => 'That code doesn\'t exist.';

  @override
  String get referralOwnCode => 'You can\'t use your own code.';

  @override
  String get referralAlreadyRedeemed => 'You already redeemed a code.';

  @override
  String get referralTooLate => 'The window to redeem a code has passed.';

  @override
  String get referralRedeemFailed => 'Couldn\'t redeem. Try again.';

  @override
  String get friendsTitle => 'Friends';

  @override
  String get friendsEmpty => 'You haven\'t added any friends yet';

  @override
  String get friendsAddHint => 'Your friend\'s invite code';

  @override
  String get friendsAdd => 'Add';

  @override
  String get friendsRemove => 'Remove';

  @override
  String get friendsRemoveConfirmTitle => 'Remove friend';

  @override
  String friendsRemoveConfirmBody(String name) {
    return '$name will be removed from your friends and you\'ll stop sharing information. This can\'t be undone.';
  }

  @override
  String get friendsAddedOk => 'Friend added';

  @override
  String get friendsAddSelf => 'That\'s your own code.';

  @override
  String get friendsAddUnknown => 'No account with that code.';

  @override
  String get friendsAddAlready => 'You\'re already friends.';

  @override
  String get friendsAddFailed => 'Couldn\'t add. Try again.';

  @override
  String get friendsRemoveFailed => 'Couldn\'t remove. Try again.';

  @override
  String get cancel => 'Cancel';
}
