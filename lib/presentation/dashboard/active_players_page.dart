import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:playmax_app_1/data/player_model.dart';
import 'package:playmax_app_1/presentation/dashboard/modals/erase_player_modal.dart';
import 'package:playmax_app_1/presentation/providers/active_players_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class ActivePlayersPage extends ConsumerStatefulWidget {
  const ActivePlayersPage({super.key});

  @override
  ConsumerState<ActivePlayersPage> createState() => _ActivePlayersPageState();
}

class _ActivePlayersPageState extends ConsumerState<ActivePlayersPage> {
  final stream = supabase
      .from('active_players')
      .stream(primaryKey: ['id_active_users']).gte(
    'created_at',
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Get the active players provider
    final activePlayersList = ref.watch(activePlayersProvider);
    //screen size
    Size screenSize = MediaQuery.of(context).size;

    return buildScreen(activePlayersList, screenSize);
  }

  //SCREEN
  Row buildScreen(List<PlayerModel> activePlayersList, Size screenSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          width: screenSize.width * 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 20,
                child: Text(
                  'Usuarios Activos',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                            'Ocurrió un error al querer cargar los jugadores!!'),
                      );
                    }

                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text(
                            'Aún no ha agregado jugadores el día de hoy!!'),
                      );
                    } else {
                      List<Map<String, dynamic>> jugadoresMap = snapshot.data!;
                      List<PlayerModel> jugadores = [];
                      for (var jugador in jugadoresMap) {
                        jugadores.add(PlayerModel.fromJson(jugador));
                      }
                      return ListView.builder(
                        itemCount: jugadores.length,
                        itemBuilder: (BuildContext ctx, int i) {
                          PlayerModel jugador = jugadores[i];

                          String formattedStartTime =
                              _getFormattedTime(jugador.start);
                          String formattedEndTime =
                              _getFormattedTime(jugador.end);

                          //Condición para solamente elegir a los activos
                          return Slidable(
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                  borderRadius: BorderRadius.circular(5),
                                  onPressed: _erase,
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                ),
                                SlidableAction(
                                  borderRadius: BorderRadius.circular(5),
                                  onPressed: (context) {},
                                  backgroundColor: Colors.deepPurple,
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white24,
                                    ),
                                    borderRadius: BorderRadius.circular(8)),
                                child: ListTile(
                                  dense: true,
                                  leading: const Icon(
                                    Icons.person,
                                    color: Colors.green,
                                  ),
                                  title: Text(
                                    jugador.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: RichText(
                                    text: TextSpan(
                                        text: 'Inicio:',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: ' $formattedStartTime',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const TextSpan(
                                            text: '\nFin:',
                                          ),
                                          TextSpan(
                                            text: ' $formattedEndTime',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ]),
                                  ),
                                  trailing: const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: screenSize.height, child: const VerticalDivider()),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          width: screenSize.width * 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 20,
                child: Text(
                  'Usuarios Inactivos',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: activePlayersList.length,
                  itemBuilder: (BuildContext ctx, int i) {
                    String formattedStartTime =
                        _getFormattedTime(activePlayersList[i].start);
                    String formattedEndTime =
                        _getFormattedTime(activePlayersList[i].end);

                    //Condición para solamente elegir a los activos
                    return Slidable(
                      startActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            borderRadius: BorderRadius.circular(5),
                            onPressed: (context) {},
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                          ),
                          SlidableAction(
                            borderRadius: BorderRadius.circular(5),
                            onPressed: (context) {},
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white24,
                              ),
                              borderRadius: BorderRadius.circular(8)),
                          child: ListTile(
                            dense: true,
                            leading: const Icon(
                              Icons.person,
                              color: Colors.red,
                            ),
                            title: Text(
                              activePlayersList[i].name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            subtitle: RichText(
                              text: TextSpan(
                                  text: 'Inicio:',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: ' $formattedStartTime',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const TextSpan(
                                      text: '\nFin:',
                                    ),
                                    TextSpan(
                                      text: ' $formattedEndTime',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                            ),
                            trailing: const Icon(
                              Icons.check_circle,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getFormattedTime(TimeOfDay time) {
    String amOrPm = 'am';
    String formattedHour = '${time.hour}';
    String formattedMinute = '${time.minute}';
    if (time.hour > 12) {
      formattedHour = (time.hour - 12).toString();
      amOrPm = 'pm';
    }
    if (time.minute < 10) {
      formattedMinute = '0${time.minute}';
    }
    return "$formattedHour:$formattedMinute$amOrPm";
  }

  _erase(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        title: Text(
          'Borrar Jugador',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        scrollable: true,
        content: ErasePlayerModal(
          playerUid: 'Prueba de envío de datos',
        ),
      ),
    );
  }
}
