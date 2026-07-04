// lib/core/router/app_router.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/otp_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/auth/presentation/welcome_screen.dart';
import '../../features/catalog/domain/catalog_models.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/my_plans/presentation/active_plan_screen.dart';
import '../../features/my_plans/presentation/my_plans_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/purchase/presentation/checkout_screen.dart';
import '../../features/purchase/presentation/plan_detail_screen.dart';
import '../../features/purchase/presentation/success_screen.dart';
import '../../shared/widgets/app_scaffold.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      // TODO(auth-subproject): guard purchase/profile routes for guests.
      return null;
    },
    routes: [
      GoRoute(
        path: '/auth',
        builder: (c, s) => const WelcomeScreen(),
        routes: [
          GoRoute(path: 'login', builder: (c, s) => const LoginScreen()),
          GoRoute(path: 'signup', builder: (c, s) => const SignupScreen()),
          GoRoute(path: 'otp', builder: (c, s) => const OtpScreen()),
        ],
      ),
      // Purchase flow + notifications live outside the tab shell.
      GoRoute(
        path: '/plan-detail',
        builder: (c, s) => PlanDetailScreen(plan: s.extra! as SelectedPlan),
      ),
      GoRoute(
        path: '/checkout',
        builder: (c, s) => CheckoutScreen(plan: s.extra! as SelectedPlan),
      ),
      GoRoute(
        path: '/success',
        builder: (c, s) => SuccessScreen(plan: s.extra! as SelectedPlan),
      ),
      GoRoute(
        path: '/active-plan',
        builder: (c, s) => const ActivePlanScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (c, s) => const NotificationsScreen(),
      ),
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
    ],
  );
});
