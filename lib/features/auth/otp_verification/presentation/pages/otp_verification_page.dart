import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/router/app_router.dart';
import '../../../../../../core/services/text-service/text-service.dart';
import '../providers/otp_verification_provider.dart';

class OtpVerificationPage extends ConsumerStatefulWidget {
  const OtpVerificationPage({
    required this.email,
    required this.purpose,
    super.key,
  });

  final String email;
  final String purpose;

  @override
  ConsumerState<OtpVerificationPage> createState() =>
      _OtpVerificationPageState();
}

class _OtpVerificationPageState extends ConsumerState<OtpVerificationPage> {
  final _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (widget.email.isEmpty) {
      _showMessage('Email is missing');
      return;
    }
    if (otp.isEmpty) {
      _showMessage('OTP is required');
      return;
    }

    setState(() => _isLoading = true);
    final useCase = ref.read(verifyOtpUseCaseProvider);
    final result = await useCase(email: widget.email, otp: otp);
    setState(() => _isLoading = false);

    if (!mounted) return;

    result.fold(
      (failure) => _showMessage(failure.message),
      (authResult) {
        if (!authResult.success) {
          _showMessage(authResult.message.isEmpty
              ? 'OTP verification failed'
              : authResult.message);
          return;
        }

        if (widget.purpose == 'resetPassword') {
          context.go(
            '${AppRoutes.resetPassword}?email=${Uri.encodeComponent(widget.email)}',
          );
          return;
        }

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
      appBar: AppBar(title: headingText(text: 'Verify OTP')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          smallText(text: widget.email),
          const SizedBox(height: 16),
          normalText(text: 'OTP'),
          const SizedBox(height: 8),
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isLoading ? null : _verifyOtp,
            child: Text(_isLoading ? 'Please wait...' : 'Verify'),
          ),
        ],
      ),
    );
  }
}
