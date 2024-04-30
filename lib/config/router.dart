import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playmax_app_1/config/routes.dart';
import 'package:playmax_app_1/presentation/auth/auth_layout.dart';
import 'package:playmax_app_1/presentation/auth/login_page.dart';
import 'package:playmax_app_1/presentation/auth/recovery_page.dart';
import 'package:playmax_app_1/presentation/dashboard/active_players_page.dart';
import 'package:playmax_app_1/presentation/dashboard/dashboard_layout.dart';
import 'package:playmax_app_1/presentation/dashboard/display_page.dart';

class RouterInitialConfig {
  // GoRouter configuration
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AuthLayout(child: child),
        routes: [
          GoRoute(
            name: Routes.login,
            path: '/',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const LoginPage(),
              transitionsBuilder:
                  ((context, animation, secondaryAnimation, child) =>
                      FadeTransition(
                        opacity: animation,
                        child: child,
                      )),
            ),
          ),
          GoRoute(
            name: Routes.recovery,
            path: '/recovery',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const RecoveryPage(),
              transitionsBuilder:
                  ((context, animation, secondaryAnimation, child) =>
                      FadeTransition(
                        opacity: animation,
                        child: child,
                      )),
            ),
          ),
        ],
      ),
      ShellRoute(
        builder: (context, state, child) => DashboardLayout(child: child),
        routes: [
          GoRoute(
            name: Routes.activePlayer,
            path: '/active_players',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const ActivePlayersPage(),
              transitionsBuilder:
                  ((context, animation, secondaryAnimation, child) =>
                      FadeTransition(
                        opacity: animation,
                        child: child,
                      )),
            ),
          ),
          GoRoute(
            name: Routes.display,
            path: '/display',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const DisplayPage(),
              transitionsBuilder:
                  ((context, animation, secondaryAnimation, child) =>
                      FadeTransition(
                        opacity: animation,
                        child: child,
                      )),
            ),
          ),
        ],
      ),
    ],
  );
}
