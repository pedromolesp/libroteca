// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Tomora';

  @override
  String get navLibrary => 'Biblioteca';

  @override
  String get navRated => 'Valorados';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get libraryTitle => 'Mi biblioteca';

  @override
  String get ratedTitle => 'Valorados';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get searchBookHint => 'Busca un libro';

  @override
  String get emptyLibrary => 'Aún no has añadido ningún libro';

  @override
  String get segmentAll => 'Biblioteca';

  @override
  String get segmentRead => 'Leídos';

  @override
  String get addBook => 'Añadir libro';

  @override
  String get editBook => 'Editar libro';

  @override
  String get authLoginHeading => 'Inicia sesión';

  @override
  String get authLoginSubtitle => 'Tu biblioteca, siempre contigo';

  @override
  String get authRegisterHeading => 'Crea tu cuenta';

  @override
  String get authRegisterSubtitle => 'Empieza a ordenar tus libros';

  @override
  String get authName => 'Nombre';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Contraseña';

  @override
  String get authPasswordRepeat => 'Repite la contraseña';

  @override
  String get authEnter => 'Entrar';

  @override
  String get authCreateAccount => 'Crear cuenta';

  @override
  String get authNoAccount => '¿Aún no tienes cuenta? ';

  @override
  String get authHaveAccount => '¿Ya tienes cuenta? ';

  @override
  String get authInvalidEmail => 'Introduce un email válido';

  @override
  String get authMinChars => 'Mínimo 6 caracteres';

  @override
  String get authWriteName => 'Escribe tu nombre';

  @override
  String get authPasswordsDontMatch => 'Las contraseñas no coinciden';

  @override
  String get authOr => 'o';

  @override
  String get authGoogle => 'Continuar con Google';

  @override
  String get settingsAccount => 'Cuenta';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsFriends => 'Amigos';

  @override
  String get settingsBackup => 'Copia de seguridad';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get backupExport => 'Exportar';

  @override
  String get backupImport => 'Importar';

  @override
  String get backupDone => 'Hecho';

  @override
  String get backupEmpty => 'Aún no hay libros';

  @override
  String get backupCancelled => 'Cancelado';

  @override
  String get backupFailed => 'No se pudo completar';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get languageGerman => 'Alemán';

  @override
  String get languageSystem => 'Idioma del sistema';

  @override
  String get referralTitle => 'Invita y quítate los anuncios';

  @override
  String get referralYourCode => 'Tu código de invitación';

  @override
  String get referralCopied => 'Código copiado';

  @override
  String referralRedeemedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count personas han usado tu código',
      one: '1 persona ha usado tu código',
      zero: 'Nadie ha usado tu código todavía',
    );
    return '$_temp0';
  }

  @override
  String referralAdsFreeUntil(String date) {
    return 'Sin anuncios hasta el $date';
  }

  @override
  String get referralHaveCodeHint => '¿Te han invitado? Código';

  @override
  String get referralRedeem => 'Canjear';

  @override
  String get referralNeedLogin =>
      'Inicia sesión para invitar a amigos y quitarte los anuncios durante 3 meses por cada invitación.';

  @override
  String get referralOk => '¡Código canjeado!';

  @override
  String get referralUnknownCode => 'Ese código no existe.';

  @override
  String get referralOwnCode => 'No puedes usar tu propio código.';

  @override
  String get referralAlreadyRedeemed => 'Ya canjeaste un código.';

  @override
  String get referralTooLate => 'Fuera de plazo para canjear un código.';

  @override
  String get referralRedeemFailed => 'No se pudo canjear. Inténtalo de nuevo.';

  @override
  String get friendsTitle => 'Amigos';

  @override
  String get friendsEmpty => 'Todavía no tienes amigos añadidos';

  @override
  String get friendsAddHint => 'Código de invitación de tu amigo';

  @override
  String get friendsAdd => 'Añadir';

  @override
  String get friendsRemove => 'Eliminar';

  @override
  String get friendsRemoveConfirmTitle => 'Eliminar amigo';

  @override
  String friendsRemoveConfirmBody(String name) {
    return 'Se eliminará a $name de tus amigos y dejaréis de compartir información. Esta acción no se puede deshacer.';
  }

  @override
  String get friendsAddedOk => 'Amigo añadido';

  @override
  String get friendsAddSelf => 'Ese es tu propio código.';

  @override
  String get friendsAddUnknown => 'No hay ninguna cuenta con ese código.';

  @override
  String get friendsAddAlready => 'Ya sois amigos.';

  @override
  String get friendsAddFailed => 'No se pudo añadir. Inténtalo de nuevo.';

  @override
  String get friendsRemoveFailed => 'No se pudo eliminar. Inténtalo de nuevo.';

  @override
  String get cancel => 'Cancelar';
}
