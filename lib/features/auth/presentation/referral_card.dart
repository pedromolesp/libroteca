import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/core/theme/app_fonts.dart';
import 'package:tomora/features/auth/data/referral_repository.dart';
import 'package:tomora/features/auth/presentation/bloc/referral_cubit.dart';

/// Tarjeta "invita y quítate los anuncios": muestra el código propio del
/// usuario y sus estadísticas, y permite canjear el código de otra persona.
/// Cada invitación canjeada da 90 días sin anuncios (acumulables) a quien
/// invita (ver la Cloud Function `redeemReferral`).
class ReferralCard extends StatelessWidget {
  const ReferralCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReferralCubit, ReferralState>(
      builder: (context, state) {
        final profile = state.profile;
        if (profile == null) {
          return const _CardShell(
            child: Text(
              'Inicia sesión para invitar a amigos y quitarte los anuncios '
              'durante 3 meses por cada invitación.',
            ),
          );
        }
        return _CardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tu código de invitación',
                style: TextStyle(fontFamily: Fonts.muliBold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  SelectableText(
                    profile.referralCode,
                    style: const TextStyle(
                      fontFamily: Fonts.muliBlack,
                      fontSize: 22,
                      letterSpacing: 2,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 18),
                    onPressed: () => Clipboard.setData(
                      ClipboardData(text: profile.referralCode),
                    ),
                  ),
                ],
              ),
              Text('Invitaciones canjeadas: ${profile.referralCount}'),
              if (profile.adsFreeUntil != null)
                Text(
                  'Sin anuncios hasta el '
                  '${profile.adsFreeUntil!.toLocal().toString().split(' ').first}',
                  style: const TextStyle(color: green),
                ),
              const Divider(height: 24),
              _RedeemField(redeeming: state.redeeming),
            ],
          ),
        );
      },
    );
  }
}

class _RedeemField extends StatefulWidget {
  const _RedeemField({required this.redeeming});

  final bool redeeming;

  @override
  State<_RedeemField> createState() => _RedeemFieldState();
}

class _RedeemFieldState extends State<_RedeemField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _redeem() async {
    final result = await context.read<ReferralCubit>().redeem(_controller.text);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_messageFor(result))),
    );
    if (result == RedeemResult.ok) _controller.clear();
  }

  String _messageFor(RedeemResult result) => switch (result) {
        RedeemResult.ok => '¡Código canjeado!',
        RedeemResult.unknownCode => 'Ese código no existe.',
        RedeemResult.ownCode => 'No puedes usar tu propio código.',
        RedeemResult.alreadyRedeemed => 'Ya canjeaste un código.',
        RedeemResult.tooLate => 'Fuera de plazo para canjear un código.',
        RedeemResult.failed => 'No se pudo canjear. Inténtalo de nuevo.',
      };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              labelText: '¿Te han invitado? Código',
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: widget.redeeming ? null : _redeem,
          child: widget.redeeming
              ? const SizedBox(
                  width: 16, height: 16, child: CircularProgressIndicator())
              : const Text('Canjear'),
        ),
      ],
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(blurRadius: 6, color: black20, offset: const Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }
}
