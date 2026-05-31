import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/role_selection_screen.dart';
import '../../features/auth/presentation/screens/otp_login_screen.dart';
import '../../features/auth/presentation/screens/otp_verification_screen.dart';
import '../../features/auth/presentation/screens/vehicle_number_screen.dart';
import '../../features/auth/presentation/screens/driver_document_upload_screen.dart';
import '../../features/customer/presentation/screens/customer_home_screen.dart';
import '../../features/customer/presentation/screens/location_search_screen.dart';
import '../../features/customer/presentation/screens/fare_estimate_screen.dart';
import '../../features/customer/presentation/screens/searching_driver_screen.dart';
import '../../features/customer/presentation/screens/live_tracking_screen.dart';
import '../../features/driver/presentation/screens/driver_dashboard_screen.dart';
import '../../features/driver/presentation/screens/incoming_request_screen.dart';
import '../../features/driver/presentation/screens/active_ride_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/role-selection',
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        final role = state.extra as String? ?? 'customer';
        return OtpLoginScreen(role: role);
      },
    ),
    GoRoute(
      path: '/otp-verify',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final role = extra['role'] as String? ?? 'customer';
        final phone = extra['phone'] as String? ?? '';
        final email = extra['email'] as String? ?? '';
        return OtpVerificationScreen(role: role, phone: phone, email: email);
      },
    ),
    GoRoute(
      path: '/customer-home',
      builder: (context, state) => const CustomerHomeScreen(),
    ),
    GoRoute(
      path: '/location-search',
      builder: (context, state) => const LocationSearchScreen(),
    ),
    GoRoute(
      path: '/fare-estimate',
      builder: (context, state) => const FareEstimateScreen(),
    ),
    GoRoute(
      path: '/searching-driver',
      builder: (context, state) => const SearchingDriverScreen(),
    ),
    GoRoute(
      path: '/live-tracking',
      builder: (context, state) => const LiveTrackingScreen(),
    ),
    GoRoute(
      path: '/driver-dashboard',
      builder: (context, state) => const DriverDashboardScreen(),
    ),
    GoRoute(
      path: '/incoming-request',
      builder: (context, state) => const IncomingRequestScreen(),
    ),
    GoRoute(
      path: '/active-ride',
      builder: (context, state) => const ActiveRideScreen(),
    ),
    GoRoute(
      path: '/vehicle-number',
      builder: (context, state) => const VehicleNumberScreen(),
    ),
    GoRoute(
      path: '/driver-document-upload',
      builder: (context, state) => const DriverDocumentUploadScreen(),
    ),
  ],
);
