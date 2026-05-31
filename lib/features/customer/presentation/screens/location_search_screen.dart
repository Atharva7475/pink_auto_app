import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({Key? key}) : super(key: key);

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Destination'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Pickup Location',
                prefixIcon: const Icon(Icons.my_location, color: Colors.blue),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              controller: TextEditingController(text: 'Current Location'),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: 'Drop Location',
                prefixIcon: const Icon(Icons.location_on, color: Colors.red),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              autofocus: true,
              onSubmitted: (value) {
                // Navigate to Fare Estimate
                context.push('/fare-estimate');
              },
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Phoenix Marketcity'),
                    subtitle: const Text('Kurla West, Mumbai'),
                    onTap: () {
                      context.push('/fare-estimate');
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Chhatrapati Shivaji Maharaj Terminus'),
                    subtitle: const Text('Fort, Mumbai'),
                    onTap: () {
                      context.push('/fare-estimate');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
