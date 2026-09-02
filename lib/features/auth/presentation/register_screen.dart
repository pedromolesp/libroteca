import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tomora/core/routes/routes.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/core/theme/app_fonts.dart';
import 'package:tomora/features/auth/presentation/auth_error_messages.dart';
import 'package:tomora/features/auth/presentation/bloc/auth_cubit.dart';

/// Andamiaje de registro (email/contraseña + nombre), estilo Planogether.
/// Al registrarse se reserva el código de referido (ver [AuthCubit.register]).
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
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    final error = await context.read<AuthCubit>().register(
          email: _email.text,
          password: _password.text,
          displayName: _name.text,
        );
    if (!mounted) return;
    setState(() => _busy = false);
    if (error == null) {
      context.goNamed(RouteNames.library);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authErrorMessage(error))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColorDark,
        title: const Text('Crear cuenta',
            style: TextStyle(color: white, fontFamily: Fonts.muliBold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Escribe tu nombre'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) =>
                    (v == null || !v.contains('@')) ? 'Email no válido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                validator: (v) =>
                    (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _busy ? null : _submit,
                  child: _busy
                      ? const CircularProgressIndicator()
                      : const Text('Crear cuenta'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
