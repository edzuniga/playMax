import 'package:flutter/material.dart';
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
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _getRol();
  }

  void _getRol() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? rol = prefs.getInt('rol');
    if (rol != null && rol == 1) {
      setState(() {
        _isAdmin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> bottomItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.supervised_user_circle_outlined),
        label: 'Jugadores',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.monitor),
        label: 'Visualización',
      ),
    ];

    // Conditionally add an item if _isAdmin is true
    if (_isAdmin) {
      bottomItems.add(const BottomNavigationBarItem(
        icon: Icon(Icons.group),
        label: 'Usuarios',
      ));
    }

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

                      String trySignOutMessage = await ref
                          .read(authStateProvider.notifier)
                          .tryLogout();

                      if (trySignOutMessage == 'loggedOut') {
                        setState(() {
                          _isTryingLogout = false;
                        });
                        navigateTo(Routes.login);
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
            bottomNavigationBar: BottomNavigationBar(
              unselectedItemColor: Colors.grey,
              backgroundColor: Colors.deepPurple,
              selectedItemColor: Colors.white,
              currentIndex: pageIndex,
              onTap: (i) {
                ref.read(activePageProvider.notifier).setPageIndex(i);
                if (i == 0) {
                  _navigateTo(context, Routes.activePlayer);
                } else if (i == 1) {
                  _navigateTo(context, Routes.display);
                } else if (i == 2) {
                  _navigateTo(context, Routes.users);
                }
              },
              items: bottomItems,
            ),
          );
  }

  void _navigateTo(BuildContext context, String pageName) {
    context.goNamed(pageName);
  }

  void navigateTo(String name) {
    context.goNamed(name);
  }
}
