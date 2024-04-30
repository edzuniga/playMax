import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:playmax_app_1/config/routes.dart';
import 'package:playmax_app_1/presentation/dashboard/modals/new_player_modal.dart';
import 'package:playmax_app_1/presentation/providers/active_page_provider.dart';

class DashboardLayout extends ConsumerWidget {
  const DashboardLayout({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int pageIndex = ref.watch(activePageProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jugadores Activos'),
      ),
      body: child,
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const AlertDialog(
            title: Text('Nuevo Jugador'),
            scrollable: true,
            content: NewPlayerModal(),
          ),
        ),
        child: const Icon(Icons.person_add_alt_1),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (i) {
          ref.read(activePageProvider.notifier).setPageIndex(i);
          if (i == 0) {
            _navigateTo(context, Routes.activePlayer);
          } else if (i == 1) {
            _navigateTo(context, Routes.display);
          }
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.supervised_user_circle_outlined,
              ),
              label: 'Jugadores'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.monitor,
              ),
              label: 'Visualización'),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, String pageName) {
    context.goNamed(pageName);
  }
}
