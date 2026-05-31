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
                isCustomer ? 'Enter your mobile number or email' : 'Enter your mobile number',
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
                keyboardType: isCustomer ? TextInputType.emailAddress : TextInputType.phone,
                maxLength: isCustomer ? null : 10,
                decoration: InputDecoration(
                  hintText: isCustomer ? 'Mobile Number or Email' : 'Mobile Number',
                  prefixIcon: Icon(isCustomer ? Icons.person : Icons.phone),
                  prefixText: isCustomer ? null : '+91 ',
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  final input = _inputController.text.trim();
                  bool isValid = false;
                  bool isEmail = false;
                  
                  if (isCustomer) {
                    final phoneRegex = RegExp(r'^\d{10}$');
                    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    
                    if (phoneRegex.hasMatch(input)) {
                      isValid = true;
                    } else if (emailRegex.hasMatch(input)) {
                      isValid = true;
                      isEmail = true;
                    }
                  } else {
                    if (input.length == 10 && RegExp(r'^\d+$').hasMatch(input)) {
                      isValid = true;
                    }
                  }

                  if (isValid) {
                    context.go('/otp-verify', extra: {
                      'role': widget.role, 
                      'phone': isEmail ? '' : input,
                      'email': isEmail ? input : '',
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isCustomer ? 'Enter a valid 10-digit number or email' : 'Enter a valid 10-digit number')
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
