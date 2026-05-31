import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchingDriverScreen extends StatefulWidget {
  const SearchingDriverScreen({Key? key}) : super(key: key);

  @override
  State<SearchingDriverScreen> createState() => _SearchingDriverScreenState();
}

class _SearchingDriverScreenState extends State<SearchingDriverScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate finding a driver
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.pushReplacement('/live-tracking');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary.withOpacity(0.05),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: theme.colorScheme.primary),
            const SizedBox(height: 32),
            Text(
              'Finding you a safe ride...',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Contacting nearby Pink Auto drivers',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
