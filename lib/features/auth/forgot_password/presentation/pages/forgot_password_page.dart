import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/router/app_router.dart';
import '../../../../../../core/services/text-service/text-service.dart';
import '../providers/forgot_password_provider.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _requestOtp() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showMessage('Email is required');
      return;
    }

    setState(() => _isLoading = true);
    final useCase = ref.read(requestPasswordResetOtpUseCaseProvider);
    final result = await useCase(email);
    setState(() => _isLoading = false);

    if (!mounted) return;

    result.fold(
      (failure) => _showMessage(failure.message),
      (authResult) {
        if (!authResult.success) {
          _showMessage(authResult.message.isEmpty
              ? 'Could not send OTP'
              : authResult.message);
          return;
        }

        context.go(
          '${AppRoutes.otpVerification}?email=${Uri.encodeComponent(email)}&purpose=resetPassword',
        );
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
      appBar: AppBar(title: headingText(text: 'Forgot Password')),
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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isLoading ? null : _requestOtp,
            child: Text(_isLoading ? 'Please wait...' : 'Send OTP'),
          ),
        ],
      ),
    );
  }
}
