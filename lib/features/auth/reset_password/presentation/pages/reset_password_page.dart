import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/router/app_router.dart';
import '../../../../../../core/services/text-service/text-service.dart';
import '../providers/reset_password_provider.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({
    required this.email,
    super.key,
  });

  final String email;

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    final password = _passwordController.text;
    if (widget.email.isEmpty) {
      _showMessage('Email is missing');
      return;
    }
    if (password.isEmpty) {
      _showMessage('Password is required');
      return;
    }

    setState(() => _isLoading = true);
    final useCase = ref.read(resetPasswordUseCaseProvider);
    final result = await useCase(email: widget.email, password: password);
    setState(() => _isLoading = false);

    if (!mounted) return;

    result.fold(
      (failure) => _showMessage(failure.message),
      (authResult) {
        if (!authResult.success) {
          _showMessage(authResult.message.isEmpty
              ? 'Password reset failed'
              : authResult.message);
          return;
        }

        _showMessage('Password updated successfully');
        context.go(AppRoutes.login);
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
      appBar: AppBar(title: headingText(text: 'Reset Password')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          smallText(text: widget.email),
          const SizedBox(height: 16),
          normalText(text: 'New password'),
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
            onPressed: _isLoading ? null : _resetPassword,
            child: Text(_isLoading ? 'Please wait...' : 'Update Password'),
          ),
        ],
      ),
    );
  }
}
