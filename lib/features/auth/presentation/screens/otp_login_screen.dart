import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OtpLoginScreen extends StatefulWidget {
  final String role;
  
  const OtpLoginScreen({Key? key, required this.role}) : super(key: key);

  @override
  State<OtpLoginScreen> createState() => _OtpLoginScreenState();
}

class _OtpLoginScreenState extends State<OtpLoginScreen> {
  final _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCustomer = widget.role == 'customer';
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${isCustomer ? 'Customer' : 'Driver'} Login'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Text(
                'Enter your mobile number',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'We will send you a One Time Password to verify your account.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _inputController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: const InputDecoration(
                  hintText: 'Mobile Number',
                  prefixIcon: Icon(Icons.phone),
                  prefixText: '+91 ',
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  final input = _inputController.text.trim();
                  
                  if (input.length == 10 && RegExp(r'^\d+$').hasMatch(input)) {
                    context.push('/otp-verify', extra: {
                      'role': widget.role, 
                      'phone': input,
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Enter a valid 10-digit number')
                      ),
                    );
                  }
                },
                child: const Text('Get OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
