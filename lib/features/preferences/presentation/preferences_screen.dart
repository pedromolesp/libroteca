import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomora/core/config/di/dependency_injector.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/core/theme/app_fonts.dart';
import 'package:tomora/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:tomora/features/auth/presentation/bloc/auth_state.dart';
import 'package:tomora/features/auth/presentation/referral_card.dart';
import 'package:tomora/features/library/presentation/bloc/library_cubit.dart';
import 'package:tomora/features/preferences/data/library_backup_service.dart';

/// Pestaña de preferencias: sesión, tarjeta de referidos ("quita los anuncios
/// 3 meses") y copia de seguridad de la biblioteca.
class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: orangeLight,
      child: ListView(
        children: [
          const SizedBox(height: 16),
          _sectionTitle('Cuenta'),
          const _AccountTile(),
          const ReferralCard(),
          _sectionTitle('Copia de seguridad'),
          _BackupButtons(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Text(
          text,
          style: const TextStyle(fontFamily: Fonts.muliBold, color: black),
        ),
      );
}

class _AccountTile extends StatelessWidget {
  const _AccountTile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        // Tomora es "login primero": al llegar aquí siempre hay sesión. Cerrar
        // sesión hace que el router (redirect) devuelva al usuario al login.
        return ListTile(
          leading: const Icon(Icons.person),
          title: Text(state.displayName ?? state.email ?? 'Cuenta'),
          subtitle: state.email != null && state.displayName != null
              ? Text(state.email!)
              : null,
          trailing: TextButton(
            onPressed: () => context.read<AuthCubit>().logout(),
            child: const Text('Cerrar sesión'),
          ),
        );
      },
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
    final result = await action();
    if (!context.mounted) return;
    if (result == BackupResult.ok) context.read<LibraryCubit>().load();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_message(result))),
    );
  }

  String _message(BackupResult r) => switch (r) {
        BackupResult.ok => 'Hecho',
        BackupResult.empty => 'Aún no hay libros',
        BackupResult.cancelled => 'Cancelado',
        BackupResult.failed => 'No se pudo completar',
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: primaryColor),
              icon: const Icon(Icons.upload_file),
              label: const Text('Exportar'),
              onPressed: () => _run(context, _service.export),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: primaryColor),
              icon: const Icon(Icons.download),
              label: const Text('Importar'),
              onPressed: () => _run(context, _service.import),
            ),
          ),
        ],
      ),
    );
  }
}
