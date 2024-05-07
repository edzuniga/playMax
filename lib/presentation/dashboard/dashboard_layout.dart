import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:playmax_app_1/presentation/providers/auth_state_provider.dart';

import 'package:playmax_app_1/config/routes.dart';
import 'package:playmax_app_1/presentation/dashboard/modals/new_player_modal.dart';
import 'package:playmax_app_1/presentation/providers/active_page_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardLayout extends ConsumerStatefulWidget {
  const DashboardLayout({required this.child, super.key});
  final Widget child;

  @override
  ConsumerState<DashboardLayout> createState() => _DashboardLayoutState();
}

typedef NavigationFunction = void Function(BuildContext context);

class _DashboardLayoutState extends ConsumerState<DashboardLayout> {
  bool _isTryingLogout = false;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _getRol();
  }

  void _getRol() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? rol = prefs.getInt('rol');
    if (rol != null) {
      switch (rol) {
        //Para admins y operadores
        case 1 || 2:
          ref.read(activePageProvider.notifier).setPageIndex(0);
          if (!mounted) return;
          _navigateTo(context, Routes.activePlayer);
          break;

        //Para display
        case 3:
          ref.read(activePageProvider.notifier).setPageIndex(2);
          if (!mounted) return;
          _navigateTo(context, Routes.display);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //Provider de la página activa
    int pageIndex = ref.watch(activePageProvider);

    return _isTryingLogout
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text(
                'Jugadores ACTIVOS / INACTIVOS',
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isFullScreen = !_isFullScreen;
                    });

                    _isFullScreen
                        ? SystemChrome.setEnabledSystemUIMode(
                            SystemUiMode.immersiveSticky)
                        : SystemChrome.setEnabledSystemUIMode(
                            SystemUiMode.edgeToEdge);
                  },
                  icon: _isFullScreen
                      ? const Icon(
                          Icons.fullscreen_exit,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.fullscreen,
                          color: Colors.white,
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 10,
                  ),
                  child: IconButton(
                    tooltip: 'Cerrar sesión',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white12,
                    ),
                    onPressed: () async {
                      setState(() {
                        _isTryingLogout = true;
                      });
                      ScaffoldMessengerState scaffoldMessenger =
                          ScaffoldMessenger.of(context);

                      await ref
                          .read(authStateProvider.notifier)
                          .tryLogout()
                          .then((trySignOutMessage) {
                        if (trySignOutMessage == 'loggedOut') {
                          setState(() {
                            _isTryingLogout = false;
                          });
                          _navigateTo(context, Routes.login);
                        } else {
                          setState(() {
                            _isTryingLogout = false;
                          });
                          scaffoldMessenger.clearSnackBars();
                          scaffoldMessenger.showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                'Ocurrió un error!! Pruebe más tarde -> $trySignOutMessage',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.logout_outlined,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            body: widget.child,
            floatingActionButton: pageIndex == 0
                ? FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () => showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const AlertDialog(
                        title: Text(
                          'Nuevo Jugador',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        scrollable: true,
                        content: NewPlayerModal(),
                      ),
                    ),
                    child: const Icon(Icons.person_add_alt_1),
                  )
                : null,
          );
  }

  void _navigateTo(BuildContext context, String pageName) {
    context.goNamed(pageName);
  }
}
