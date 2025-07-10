import 'package:flutter/material.dart';
import '../../shared/components/custom_textfield.dart';
import '../../shared/components/primary_button.dart';
import '../../shared/utils/validators.dart';
import '../../shared/constants/app_strings.dart';
import '../../contracts/contracts_routes.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1)); // Simulación de espera

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Simula login con cualquier combinación válida
    if (email.isNotEmpty && password.isNotEmpty) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, ContractsRoutes.list);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credenciales inválidas')),
        );
      }
    }

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            hint: AppStrings.emailHint,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hint: AppStrings.passwordHint,
            controller: _passwordController,
            obscure: true,
            validator: Validators.required,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: AppStrings.loginButton,
            isLoading: _isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
