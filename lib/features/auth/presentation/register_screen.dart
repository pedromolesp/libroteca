import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tomora/core/config/l10n/l10n_extension.dart';
import 'package:tomora/core/routes/routes.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/core/theme/app_fonts.dart';
import 'package:tomora/features/auth/presentation/auth_error_messages.dart';
import 'package:tomora/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:tomora/features/auth/presentation/widgets/auth_scaffold.dart';

/// Alta de cuenta (nombre + email + contraseña). Al registrarse se reserva el
/// código de referido (ver [AuthCubit.register]).
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();
  bool _busy = false;
  bool _googleBusy = false;
  bool _obscure = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    final error = await context.read<AuthCubit>().register(
          email: _email.text,
          password: _password.text,
          displayName: _name.text,
        );
    _handleResult(error);
  }

  Future<void> _google() async {
    FocusScope.of(context).unfocus();
    setState(() => _googleBusy = true);
    final error = await context.read<AuthCubit>().signInWithGoogle();
    _handleResult(error);
  }

  void _handleResult(String? error) {
    if (!mounted) return;
    setState(() {
      _busy = false;
      _googleBusy = false;
    });
    if (error == null) {
      context.goNamed(RouteNames.library);
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(authErrorMessage(error))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AuthScaffold(
      onBack: () => context.pop(),
      heading: l10n.authRegisterHeading,
      subtitle: l10n.authRegisterSubtitle,
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(l10n.authHaveAccount),
          GestureDetector(
            onTap: () => context.pop(),
            child: Text(
              l10n.authLoginHeading,
              style: const TextStyle(
                color: whiteRed,
                fontFamily: Fonts.muliBold,
                decoration: TextDecoration.underline,
                decorationColor: whiteRed,
              ),
            ),
          ),
        ],
      ),
      child: AutofillGroup(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                onEditingComplete: () => _emailFocus.requestFocus(),
                decoration:
                    authInputDecoration(l10n.authName, Icons.person_outline),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? l10n.authWriteName
                    : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _email,
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                onEditingComplete: () => _passwordFocus.requestFocus(),
                decoration: authInputDecoration(l10n.authEmail, Icons.mail_outline),
                validator: (v) => (v == null || !v.contains('@'))
                    ? l10n.authInvalidEmail
                    : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _password,
                focusNode: _passwordFocus,
                obscureText: _obscure,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
                onEditingComplete: () => _confirmFocus.requestFocus(),
                decoration: authInputDecoration(
                  l10n.authPassword,
                  Icons.lock_outline,
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                      color: greyText,
                    ),
                  ),
                ),
                validator: (v) => (v == null || v.length < 6)
                    ? l10n.authMinChars
                    : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _confirm,
                focusNode: _confirmFocus,
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                decoration: authInputDecoration(
                  l10n.authPasswordRepeat,
                  Icons.lock_outline,
                ),
                validator: (v) =>
                    v != _password.text ? l10n.authPasswordsDontMatch : null,
              ),
              const SizedBox(height: 24),
              AuthPrimaryButton(
                label: l10n.authCreateAccount,
                busy: _busy,
                onPressed: _submit,
              ),
              const SizedBox(height: 18),
              AuthOrDivider(label: l10n.authOr),
              const SizedBox(height: 18),
              AuthGoogleButton(
                label: l10n.authGoogle,
                busy: _googleBusy,
                onPressed: _google,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
