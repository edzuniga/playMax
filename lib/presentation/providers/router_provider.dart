import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:playmax_app_1/presentation/providers/active_page_provider.dart';
import 'package:playmax_app_1/presentation/providers/auth_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:playmax_app_1/config/routes.dart';
import 'package:playmax_app_1/presentation/auth/export_auth_pages.dart';
import 'package:playmax_app_1/presentation/dashboard/export_dashboard_pages.dart';
import 'package:playmax_app_1/presentation/shared_screens/error_page.dart';
part 'router_provider.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    errorPageBuilder: (context, state) => CustomTransitionPage(
      child: ErrorPage(
        state: state,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(
        opacity: animation,
        child: child,
      ),
    ),
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
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(
                opacity: animation,
                child: child,
              ),
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
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(
                opacity: animation,
                child: child,
              ),
            ),
          ),
          GoRoute(
            name: Routes.display,
            path: '/display',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const DisplayPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(
                opacity: animation,
                child: child,
              ),
            ),
          ),
        ],
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      // Obtén el estado de autenticación desde el provider
      final isAuthenticated = ref.read(authStateProvider);

      //Rutas accesibles sin autenticación
      const accesibleRoutes = ['/login', '/recovery'];
      const unaccesibleRoutes = ['/active_players', '/display'];

      if (!isAuthenticated &&
          (accesibleRoutes.contains(state.matchedLocation))) {
        return null;
      }

      // Si el usuario no está autenticado y está intentando acceder a una ruta que requiere autenticación
      if (!isAuthenticated &&
          (unaccesibleRoutes.contains(state.matchedLocation))) {
        // Redirige al usuario a la pantalla de login
        return '/';
      }

      // Si el usuario está autenticado y trata de acceder a una ruta de autenticación
      if (isAuthenticated && accesibleRoutes.contains(state.matchedLocation)) {
        // Redirige al usuario al dashboard
        return '/active_players';
      }

      //Provider
      int activePage = ref.read(activePageProvider);

      //Lógica para manejar qué página pueden ver los usuarios, dependiendo su
      //tipo de rol
      if (isAuthenticated && activePage == 0 ||
          isAuthenticated && activePage == 1) {
        return '/active_players';
      }

      if (isAuthenticated && activePage == 3) {
        return '/display';
      }

      // No se necesita redirección
      return null;
    },
  );
}
