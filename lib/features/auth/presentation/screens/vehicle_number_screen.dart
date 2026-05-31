import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VehicleNumberScreen extends StatefulWidget {
  const VehicleNumberScreen({Key? key}) : super(key: key);

  @override
  State<VehicleNumberScreen> createState() => _VehicleNumberScreenState();
}

class _VehicleNumberScreenState extends State<VehicleNumberScreen> {
  final _vehicleNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    super.dispose();
  }

  void _proceedToDocumentUpload() {
    if (_formKey.currentState?.validate() ?? false) {
      // In a real app, you might save this number to state or pass it along.
      context.go('/driver-document-upload');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Details'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Text(
                  'Enter Vehicle Registration Number',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Please enter the registration number of the auto rickshaw you will be driving.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _vehicleNumberController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'Vehicle Number',
                    hintText: 'e.g., MH 01 AB 1234',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a valid vehicle number';
                    }
                    if (value.trim().length < 6) {
                      return 'Vehicle number is too short';
                    }
                    return null;
                  },
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _proceedToDocumentUpload,
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
