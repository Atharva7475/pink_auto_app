import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class ActiveRideScreen extends StatefulWidget {
  const ActiveRideScreen({Key? key}) : super(key: key);

  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen> {
  bool isRideStarted = false;
  GoogleMapController? _mapController;
  bool _locationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _handleLocationPermission();
  }

  Future<void> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location services are disabled.')));
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are denied')));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return;
    }

    setState(() {
      _locationPermissionGranted = true;
    });

    _moveToCurrentLocation();
  }

  Future<void> _moveToCurrentLocation() async {
    if (_locationPermissionGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition();
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 16,
            ),
          ),
        );
      } catch (e) {
        debugPrint("Error getting location: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(19.0760, 72.8777),
              zoom: 16,
            ),
            zoomControlsEnabled: false,
            myLocationEnabled: _locationPermissionGranted,
            myLocationButtonEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => context.go('/driver-dashboard'),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 340, right: 16),
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  if (!_locationPermissionGranted) {
                    _handleLocationPermission();
                  } else {
                    _moveToCurrentLocation();
                  }
                },
                child: Icon(Icons.my_location, color: theme.colorScheme.primary),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isRideStarted ? 'Navigating to Drop' : 'Pickup in 3 mins',
                        style: theme.textTheme.titleLarge,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isRideStarted ? '12 mins left' : '1.2 km away',
                          style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        isRideStarted ? Icons.location_on : Icons.my_location,
                        color: isRideStarted ? Colors.red : Colors.blue,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          isRideStarted ? 'BKC, Bandra East' : 'Phoenix Marketcity, Kurla',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.navigation, color: Colors.blue),
                        onPressed: () {
                          // Open Google Maps intent for navigation
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=32'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Riya Sharma', style: theme.textTheme.titleMedium),
                            Text('Payment: Cash', style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                      IconButton(icon: const Icon(Icons.call, color: Colors.green), onPressed: () {}),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (!isRideStarted)
                    ElevatedButton(
                      onPressed: () {
                        _showOtpDialog(context);
                      },
                      child: const Text('Arrived & Start Ride'),
                    )
                  else
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        _showRideCompleteDialog(context);
                      },
                      child: const Text('End Ride'),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOtpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enter Customer OTP'),
        content: const TextField(
          keyboardType: TextInputType.number,
          maxLength: 4,
          decoration: InputDecoration(hintText: 'OTP'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                isRideStarted = true;
              });
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }

  void _showRideCompleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ride Completed'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Collect cash from customer:'),
            const SizedBox(height: 16),
            Text('₹ 150', style: Theme.of(context).textTheme.displayMedium),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/driver-dashboard');
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
