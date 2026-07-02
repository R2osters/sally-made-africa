// lib/core/router/app_router.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/catalog/presentation/country_select_screen.dart';
import '../../features/catalog/presentation/plan_details_screen.dart';
import '../../features/catalog/presentation/plan_select_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/my_plans/presentation/my_plans_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/onboarding/presentation/splash_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/purchase/presentation/checkout_screen.dart';
import '../../features/purchase/presentation/payment_method_screen.dart';
import '../../features/purchase/presentation/payment_processing_screen.dart';
import '../../features/purchase/presentation/payment_success_screen.dart';
import '../../shared/widgets/app_scaffold.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      // TODO(auth-subproject): guard purchase/profile routes for guests.
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (c, s) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (c, s) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (c, s) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (c, s) => const SignupScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/home', builder: (c, s) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/my-plans', builder: (c, s) => const MyPlansScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/history', builder: (c, s) => const HistoryScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/profile', builder: (c, s) => const ProfileScreen()),
          ]),
        ],
      ),
      GoRoute(
          path: '/country-select',
          builder: (c, s) => const CountrySelectScreen()),
      GoRoute(
        path: '/country/:code/plans',
        builder: (c, s) =>
            PlanSelectScreen(countryCode: s.pathParameters['code']!),
      ),
      GoRoute(
          path: '/plans/:id', builder: (c, s) => const PlanDetailsScreen()),
      GoRoute(path: '/checkout', builder: (c, s) => const CheckoutScreen()),
      GoRoute(
          path: '/payment-method',
          builder: (c, s) => const PaymentMethodScreen()),
      GoRoute(
          path: '/payment-processing',
          builder: (c, s) => const PaymentProcessingScreen()),
      GoRoute(
          path: '/payment-success',
          builder: (c, s) => const PaymentSuccessScreen()),
    ],
  );
});
