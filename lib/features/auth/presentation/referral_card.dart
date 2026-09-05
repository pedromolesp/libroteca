import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomora/core/config/l10n/l10n_extension.dart';
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
    final l10n = context.l10n;
    return BlocBuilder<ReferralCubit, ReferralState>(
      builder: (context, state) {
        final profile = state.profile;
        return _Shell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.card_giftcard, color: whiteRed, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.referralTitle,
                      style: const TextStyle(
                        color: whiteRed,
                        fontFamily: Fonts.muliBold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (profile == null)
                Text(
                  l10n.referralNeedLogin,
                  style: TextStyle(
                    color: whiteRed.withValues(alpha: 0.85),
                    fontFamily: Fonts.muliRegular,
                    fontSize: 13,
                  ),
                )
              else ...[
                Text(
                  l10n.referralYourCode,
                  style: TextStyle(
                    color: whiteRed.withValues(alpha: 0.75),
                    fontFamily: Fonts.muliRegular,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                _CodeChip(code: profile.referralCode),
                const SizedBox(height: 10),
                Text(
                  l10n.referralRedeemedCount(profile.referralCount),
                  style: TextStyle(
                    color: whiteRed.withValues(alpha: 0.85),
                    fontFamily: Fonts.muliRegular,
                    fontSize: 13,
                  ),
                ),
                if (profile.adsFreeUntil != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      l10n.referralAdsFreeUntil(
                        profile.adsFreeUntil!
                            .toLocal()
                            .toString()
                            .split(' ')
                            .first,
                      ),
                      style: const TextStyle(
                        color: yellow,
                        fontFamily: Fonts.muliBold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                Divider(color: whiteRed.withValues(alpha: 0.2), height: 26),
                _RedeemField(redeeming: state.redeeming),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _Shell extends StatelessWidget {
  const _Shell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryColorDark, Color(0xFF7B5238)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CodeChip extends StatelessWidget {
  const _CodeChip({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Clipboard.setData(ClipboardData(text: code));
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.referralCopied)));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: whiteRed.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: whiteRed.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              code,
              style: const TextStyle(
                color: whiteRed,
                fontFamily: Fonts.muliBlack,
                fontSize: 22,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.copy, size: 16, color: whiteRed),
          ],
        ),
      ),
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
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final result = await context.read<ReferralCubit>().redeem(_controller.text);
    if (!mounted) return;
    final message = switch (result) {
      RedeemResult.ok => l10n.referralOk,
      RedeemResult.unknownCode => l10n.referralUnknownCode,
      RedeemResult.ownCode => l10n.referralOwnCode,
      RedeemResult.alreadyRedeemed => l10n.referralAlreadyRedeemed,
      RedeemResult.tooLate => l10n.referralTooLate,
      RedeemResult.failed => l10n.referralRedeemFailed,
    };
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
    if (result == RedeemResult.ok) _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            textCapitalization: TextCapitalization.characters,
            style: const TextStyle(color: whiteRed),
            decoration: InputDecoration(
              isDense: true,
              hintText: l10n.referralHaveCodeHint,
              hintStyle: TextStyle(color: whiteRed.withValues(alpha: 0.6)),
              filled: true,
              fillColor: whiteRed.withValues(alpha: 0.1),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: whiteRed.withValues(alpha: 0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: whiteRed),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: whiteRed,
            foregroundColor: primaryColorDark,
            elevation: 0,
          ),
          onPressed: widget.redeeming ? null : _redeem,
          child: widget.redeeming
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: primaryColorDark,
                  ),
                )
              : Text(l10n.referralRedeem),
        ),
      ],
    );
  }
}
