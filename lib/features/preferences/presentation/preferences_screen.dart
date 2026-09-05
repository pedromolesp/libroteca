import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tomora/core/config/di/dependency_injector.dart';
import 'package:tomora/core/config/l10n/l10n_extension.dart';
import 'package:tomora/core/config/l10n/locale_cubit.dart';
import 'package:tomora/core/config/theme/theme_cubit.dart';
import 'package:tomora/core/routes/routes.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/core/theme/app_fonts.dart';
import 'package:tomora/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:tomora/features/auth/presentation/bloc/auth_state.dart';
import 'package:tomora/features/library/presentation/bloc/library_cubit.dart';
import 'package:tomora/features/preferences/data/library_backup_service.dart';

/// Ajustes: cuenta, idioma y copia de seguridad de la biblioteca. Invitar
/// amigos y canjear códigos vive en la pantalla de Amigos (botón de la barra
/// superior), junto al resto de la gestión de contactos.
class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      color: context.colors.background,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
        children: [
          _SectionTitle(l10n.settingsAccount),
          const _AccountTile(),
          const SizedBox(height: 8),
          const _DeleteAccountButton(),
          const SizedBox(height: 24),
          _SectionTitle(l10n.settingsLanguage),
          const _LanguageDropdown(),
          const SizedBox(height: 24),
          _SectionTitle(l10n.settingsTheme),
          const _ThemeDropdown(),
          const SizedBox(height: 24),
          _SectionTitle(l10n.settingsBackup),
          _BackupButtons(),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontFamily: Fonts.muliBold,
          fontSize: 12,
          letterSpacing: 1,
          color: primaryColorDark.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

/// Contenedor blanco redondeado reutilizado por las tarjetas de ajustes.
class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: primaryColorDark.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: child,
    );
  }
}

class _AccountTile extends StatelessWidget {
  const _AccountTile();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final name = (state.displayName?.isNotEmpty ?? false)
            ? state.displayName!
            : (state.email ?? l10n.settingsAccount);
        return _Card(
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: primaryColor,
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: whiteRed,
                    fontFamily: Fonts.muliBlack,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(fontFamily: Fonts.muliBold)),
                    if (state.email != null &&
                        state.email != name &&
                        state.email!.isNotEmpty)
                      Text(state.email!,
                          style: TextStyle(
                              color: context.colors.onSurfaceMuted,
                              fontSize: 13)),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => context.read<AuthCubit>().logout(),
                style: TextButton.styleFrom(foregroundColor: primaryColorDark),
                child: Text(l10n.logout),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DeleteAccountButton extends StatelessWidget {
  const _DeleteAccountButton();

  Future<void> _confirmAndDelete(BuildContext context) async {
    final l10n = context.l10n;
    final authCubit = context.read<AuthCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteAccountConfirmTitle),
        content: Text(l10n.deleteAccountConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: red),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.settingsDeleteAccount),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final rootNavigator = Navigator.of(context, rootNavigator: true);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    final ok = await authCubit.deleteAccount();
    rootNavigator.pop(); // cierra el spinner
    if (ok) {
      router.goNamed(RouteNames.login);
    } else {
      messenger.showSnackBar(SnackBar(content: Text(l10n.deleteAccountFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: () => _confirmAndDelete(context),
        icon: const Icon(Icons.delete_forever_outlined, size: 18, color: red),
        label: Text(l10n.settingsDeleteAccount,
            style: const TextStyle(color: red)),
      ),
    );
  }
}

class _LanguageDropdown extends StatelessWidget {
  const _LanguageDropdown();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final current = context.watch<LocaleCubit>().state;

    String labelFor(String? code) => switch (code) {
          'es' => '🇪🇸  ${l10n.languageSpanish}',
          'en' => '🇬🇧  ${l10n.languageEnglish}',
          'de' => '🇩🇪  ${l10n.languageGerman}',
          _ => '🌐  ${l10n.languageSystem}',
        };

    final codes = <String?>[
      null,
      ...LocaleCubit.supported.map((l) => l.languageCode)
    ];

    return _Card(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: current?.languageCode,
          isExpanded: true,
          borderRadius: BorderRadius.circular(12),
          icon: const Icon(Icons.expand_more, color: primaryColorDark),
          items: [
            for (final code in codes)
              DropdownMenuItem<String?>(
                value: code,
                child: Text(
                  labelFor(code),
                  style: const TextStyle(fontFamily: Fonts.muliRegular),
                ),
              ),
          ],
          onChanged: (code) => context
              .read<LocaleCubit>()
              .setLocale(code == null ? null : Locale(code)),
        ),
      ),
    );
  }
}

class _ThemeDropdown extends StatelessWidget {
  const _ThemeDropdown();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final current = context.watch<ThemeCubit>().state;

    String labelFor(ThemeMode mode) => switch (mode) {
          ThemeMode.light => l10n.themeLight,
          ThemeMode.dark => l10n.themeDark,
          ThemeMode.system => l10n.themeSystem,
        };

    return _Card(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ThemeMode>(
          value: current,
          isExpanded: true,
          borderRadius: BorderRadius.circular(12),
          icon: const Icon(Icons.expand_more, color: primaryColorDark),
          items: [
            for (final mode in ThemeMode.values)
              DropdownMenuItem<ThemeMode>(
                value: mode,
                child: Text(
                  labelFor(mode),
                  style: const TextStyle(fontFamily: Fonts.muliRegular),
                ),
              ),
          ],
          onChanged: (mode) {
            if (mode != null) context.read<ThemeCubit>().setThemeMode(mode);
          },
        ),
      ),
    );
  }
}

class _BackupButtons extends StatelessWidget {
  _BackupButtons();

  final _service = getIt<LibraryBackupService>();

  Future<void> _run(
    BuildContext context,
    Future<BackupResult> Function() action,
  ) async {
    final l10n = context.l10n;
    final result = await action();
    if (!context.mounted) return;
    if (result == BackupResult.ok) context.read<LibraryCubit>().load();
    final message = switch (result) {
      BackupResult.ok => l10n.backupDone,
      BackupResult.empty => l10n.backupEmpty,
      BackupResult.cancelled => l10n.backupCancelled,
      BackupResult.failed => l10n.backupFailed,
    };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    ButtonStyle style() => FilledButton.styleFrom(
          backgroundColor: primaryColorDark,
          foregroundColor: whiteRed,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        );
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            style: style(),
            icon: const Icon(Icons.upload_file, size: 18),
            label: Text(l10n.backupExport),
            onPressed: () => _run(context, _service.export),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            style: style(),
            icon: const Icon(Icons.download, size: 18),
            label: Text(l10n.backupImport),
            onPressed: () => _run(context, _service.import),
          ),
        ),
      ],
    );
  }
}
