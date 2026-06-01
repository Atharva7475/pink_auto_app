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

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

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
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const OnboardingScreen(),
      ),
    ),
    GoRoute(
      path: '/role-selection',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const RoleSelectionScreen(),
      ),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) {
        final role = state.extra as String? ?? 'customer';
        return buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: OtpLoginScreen(role: role),
        );
      },
    ),
    GoRoute(
      path: '/otp-verify',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final role = extra['role'] as String? ?? 'customer';
        final phone = extra['phone'] as String? ?? '';
        return buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: OtpVerificationScreen(role: role, phone: phone),
        );
      },
    ),
    GoRoute(
      path: '/customer-home',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const CustomerHomeScreen(),
      ),
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
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const DriverDashboardScreen(),
      ),
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
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const VehicleNumberScreen(),
      ),
    ),
    GoRoute(
      path: '/driver-document-upload',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const DriverDocumentUploadScreen(),
      ),
    ),
  ],
);
