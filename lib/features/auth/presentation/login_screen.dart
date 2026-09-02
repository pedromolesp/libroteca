import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tomora/core/routes/routes.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/core/theme/app_fonts.dart';
import 'package:tomora/features/auth/presentation/auth_error_messages.dart';
import 'package:tomora/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:tomora/features/auth/presentation/widgets/auth_scaffold.dart';

/// Inicio de sesión con email y contraseña. Primera pantalla de Tomora cuando
/// no hay sesión restaurada.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _passwordFocus = FocusNode();
  bool _busy = false;
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    final error = await context.read<AuthCubit>().login(
          email: _email.text,
          password: _password.text,
        );
    if (!mounted) return;
    setState(() => _busy = false);
    if (error == null) {
      context.goNamed(RouteNames.library);
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(authErrorMessage(error))),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      heading: 'Inicia sesión',
      subtitle: 'Tu biblioteca, siempre contigo',
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('¿Aún no tienes cuenta? '),
          GestureDetector(
            onTap: () => context.pushNamed(RouteNames.register),
            child: const Text(
              'Crear cuenta',
              style: TextStyle(
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
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.username, AutofillHints.email],
                onEditingComplete: () => _passwordFocus.requestFocus(),
                decoration: authInputDecoration('Email', Icons.mail_outline),
                validator: (v) => (v == null || !v.contains('@'))
                    ? 'Introduce un email válido'
                    : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _password,
                focusNode: _passwordFocus,
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                onFieldSubmitted: (_) => _submit(),
                decoration: authInputDecoration(
                  'Contraseña',
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
                    ? 'Mínimo 6 caracteres'
                    : null,
              ),
              const SizedBox(height: 24),
              AuthPrimaryButton(
                label: 'Entrar',
                busy: _busy,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
