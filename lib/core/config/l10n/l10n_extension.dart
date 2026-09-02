import 'package:flutter/widgets.dart';
import 'package:tomora/l10n/app_localizations.dart';

/// Atajo: `context.l10n.miClave` en vez de `AppLocalizations.of(context).miClave`.
extension L10nExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
