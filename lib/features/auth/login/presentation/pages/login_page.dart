import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/router/app_router.dart';
import '../../../../../../core/services/text-service/text-service.dart';
import '../providers/login_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Please fill all fields');
      return;
    }

    setState(() => _isLoading = true);
    final useCase = ref.read(loginUseCaseProvider);
    final result = await useCase(email: email, password: password);
    setState(() => _isLoading = false);

    if (!mounted) return;

    result.fold(
      (failure) => _showMessage(failure.message),
      (authResult) {
        if (!authResult.success) {
          _showMessage(authResult.message.isEmpty
              ? 'Login failed'
              : authResult.message);
          return;
        }

        context.go(AppRoutes.profile);
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: headingText(text: 'Login')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          normalText(text: 'Email'),
          const SizedBox(height: 8),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          normalText(text: 'Password'),
          const SizedBox(height: 8),
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isLoading ? null : _login,
            child: Text(_isLoading ? 'Please wait...' : 'Login'),
          ),
          TextButton(
            onPressed: () => context.go(AppRoutes.signUp),
            child: const Text('Create account'),
          ),
          TextButton(
            onPressed: () => context.go(AppRoutes.forgotPassword),
            child: const Text('Forgot password?'),
          ),
        ],
      ),
    );
  }
}
