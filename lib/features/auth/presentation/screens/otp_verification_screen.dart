import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String role;
  final String phone;
  final String email;

  const OtpVerificationScreen({
    Key? key,
    required this.role,
    required this.phone,
    this.email = '',
  }) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyAndProceed() async {
    if (_otpController.text.length == 4) {
      // Save login state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('role', widget.role);
      if (widget.phone.isNotEmpty) {
        await prefs.setString('phone', widget.phone);
      }
      if (widget.email.isNotEmpty) {
        await prefs.setString('email', widget.email);
      }

      if (!mounted) return;
      if (widget.role == 'customer') {
        context.go('/customer-home');
      } else {
        final isDriverRegistered = prefs.getBool('isDriverRegistered') ?? false;
        if (isDriverRegistered) {
          context.go('/driver-dashboard');
        } else {
          context.go('/vehicle-number');
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid 4-digit OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String sentTo = widget.email.isNotEmpty ? widget.email : '+91 ${widget.phone}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Text(
                'Enter the 4-digit OTP',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Sent to $sentTo',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, letterSpacing: 16),
                decoration: const InputDecoration(
                  hintText: '----',
                  counterText: '',
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    // Resend OTP logic
                  },
                  child: const Text('Resend OTP'),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _verifyAndProceed,
                child: const Text('Verify & Proceed'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
