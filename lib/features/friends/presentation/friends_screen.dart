import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomora/core/config/l10n/l10n_extension.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/core/theme/app_fonts.dart';
import 'package:tomora/features/auth/presentation/referral_card.dart';
import 'package:tomora/features/friends/data/friends_repository.dart';
import 'package:tomora/features/friends/domain/model/friend.dart';
import 'package:tomora/features/friends/presentation/bloc/friends_cubit.dart';

/// Todo lo relacionado con personas: la tarjeta de invitación (tu código y el
/// canje del de otra persona), añadir amigos por código, ver la lista y
/// eliminarlos. Al eliminar, la Cloud Function `onConnectionDeleted` borra la
/// información compartida entre las dos cuentas.
class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: primaryColorLight,
      appBar: AppBar(
        backgroundColor: primaryColorDark,
        iconTheme: const IconThemeData(color: whiteRed),
        title: Text(
          l10n.friendsTitle,
          style: const TextStyle(color: whiteRed, fontFamily: Fonts.muliBold),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<FriendsCubit, FriendsState>(
          builder: (context, state) {
            return ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: ReferralCard(),
                ),
                _SectionLabel(l10n.friendsTitle),
                const _AddFriendField(),
                const Divider(height: 1),
                if (state.loading)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state.friends.isEmpty)
                  _EmptyHint(l10n.friendsEmpty)
                else
                  for (var i = 0; i < state.friends.length; i++) ...[
                    if (i > 0) const Divider(height: 1, indent: 72),
                    _FriendTile(friend: state.friends[i]),
                  ],
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 2),
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

class _AddFriendField extends StatefulWidget {
  const _AddFriendField();

  @override
  State<_AddFriendField> createState() => _AddFriendFieldState();
}

class _AddFriendFieldState extends State<_AddFriendField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final result = await context.read<FriendsCubit>().addByCode(_controller.text);
    if (!mounted) return;
    final message = switch (result) {
      AddFriendResult.ok => l10n.friendsAddedOk,
      AddFriendResult.ownCode => l10n.friendsAddSelf,
      AddFriendResult.unknownCode => l10n.friendsAddUnknown,
      AddFriendResult.alreadyFriends => l10n.friendsAddAlready,
      AddFriendResult.failed => l10n.friendsAddFailed,
    };
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
    if (result == AddFriendResult.ok) _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final working =
        context.select((FriendsCubit c) => c.state.working);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: primaryColorDark.withValues(alpha: 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  hintText: l10n.friendsAddHint,
                  filled: true,
                  fillColor: white,
                  prefixIcon: const Icon(Icons.person_add_alt_1),
                ),
                onSubmitted: (_) => _add(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColorDark,
                foregroundColor: whiteRed,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: working ? null : _add,
              child: working
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: whiteRed,
                      ),
                    )
                  : Text(l10n.friendsAdd),
            ),
          ),
        ],
      ),
    );
  }
}

class _FriendTile extends StatelessWidget {
  const _FriendTile({required this.friend});

  final Friend friend;

  Future<void> _confirmRemove(BuildContext context) async {
    final l10n = context.l10n;
    final cubit = context.read<FriendsCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.friendsRemoveConfirmTitle),
        content: Text(l10n.friendsRemoveConfirmBody(friend.label)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: red),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.friendsRemove),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final ok = await cubit.remove(friend);
    if (!ok) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.friendsRemoveFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: primaryColor,
        child: Text(
          friend.label.isNotEmpty ? friend.label[0].toUpperCase() : '?',
          style: const TextStyle(color: whiteRed, fontFamily: Fonts.muliBold),
        ),
      ),
      title: Text(friend.label,
          style: const TextStyle(fontFamily: Fonts.muliBold)),
      subtitle: friend.email.isNotEmpty && friend.email != friend.label
          ? Text(friend.email)
          : null,
      trailing: IconButton(
        icon: const Icon(Icons.person_remove_alt_1, color: red),
        tooltip: context.l10n.friendsRemove,
        onPressed: () => _confirmRemove(context),
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 48, 32, 32),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: greyText, fontFamily: Fonts.muliRegular),
      ),
    );
  }
}
