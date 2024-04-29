import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:playmax_app_1/presentation/dashboard/modals/new_player_modal.dart';
import 'package:playmax_app_1/presentation/providers/active_players_provider.dart';

class ActivePlayersPage extends ConsumerWidget {
  const ActivePlayersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Get the active players provider
    final activePlayersList = ref.watch(activePlayersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jugadores Activos'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
        },
        child: ListView.builder(
          itemCount: activePlayersList.length,
          itemBuilder: (BuildContext ctx, int i) {
            return ListTile(
              leading: const Icon(Icons.person),
              title: Text(activePlayersList[i].name),
              subtitle: Text(
                  "Inicio: ${activePlayersList[i].start} \nFin: ${activePlayersList[i].end}"),
              trailing: (activePlayersList[i].isActive)
                  ? const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.highlight_remove_outlined,
                      color: Colors.red,
                    ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Nuevo Jugador'),
            scrollable: true,
            content: const NewPlayerModal(),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Agregar jugador'),
              )
            ],
          ),
        ),
        child: const Icon(Icons.person_add_alt_1),
      ),
      bottomNavigationBar: BottomNavigationBar(items: const [
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
      ]),
    );
  }
}
