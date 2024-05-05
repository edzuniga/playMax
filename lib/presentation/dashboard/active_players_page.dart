import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:playmax_app_1/data/player_model.dart';
import 'package:playmax_app_1/presentation/dashboard/modals/erase_player_modal.dart';
import 'package:playmax_app_1/presentation/dashboard/modals/update_player_modal.dart';
import 'package:playmax_app_1/presentation/functions/get_formatted_time_function.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class ActivePlayersPage extends ConsumerStatefulWidget {
  const ActivePlayersPage({super.key});

  @override
  ConsumerState<ActivePlayersPage> createState() => _ActivePlayersPageState();
}

class _ActivePlayersPageState extends ConsumerState<ActivePlayersPage> {
  late List<PlayerModel> jugadoresGlobal;
  late List<PlayerModel> jugadoresInactivos;

  final stream = supabase
      .from('active_players')
      .stream(primaryKey: ['id_active_users'])
      .gte(
        'created_at',
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      )
      .order('fin', ascending: true);

  @override
  void initState() {
    super.initState();
    jugadoresGlobal = [];
    jugadoresInactivos = [];
  }

  @override
  void dispose() {
    //Dispose any timer to avoid memory leak
    for (var jugador in jugadoresGlobal) {
      jugador.disposeTimer();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
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
              child: Text('Ocurrió un error al querer cargar los jugadores!!'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('Aún no ha agregado jugadores el día de hoy!!'),
            );
          } else {
            List<Map<String, dynamic>> jugadoresMap = snapshot.data!;
            //Borrar listados de jugadores
            jugadoresGlobal.clear();
            jugadoresInactivos.clear();
            for (var jugador in jugadoresMap) {
              //Poblar el listado
              if (jugador['is_active'] == true) {
                jugadoresGlobal.add(PlayerModel.fromJson(jugador));
              } else {
                jugadoresInactivos.add(PlayerModel.fromJson(jugador));
              }
            }

            //*--------LÓGICA PARA AGREGARLE EL TIMER A CADA JUGADOR
            void setupTimer(PlayerModel player) {
              //?need to convert each TimeOfDay to DateTime to compare them
              DateTime now = DateTime.now();
              DateTime endDateTime = DateTime(now.year, now.month, now.day,
                  player.end.hour, player.end.minute);

              //?calculate difference (cuánto le queda con respecto
              //? a la hora ACTUAL)
              int secondsToEnd = endDateTime.difference(now).inSeconds;
              if (secondsToEnd > 0) {
                player.timer
                    ?.cancel(); //Cancelar cualquier timer que haya en ese jugador
                player.timer = Timer(Duration(seconds: secondsToEnd),
                    () => updatePlayerStatus(player));
              }
            }

            for (var jugador in jugadoresGlobal) {
              setupTimer(jugador);
            }

            //*---------LÓGICA PARA AGREGARLE EL TIMER A CADA JUGADOR

            return Row(
              children: [
                SizedBox(
                  width: screenSize.width * 0.45,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Usuarios Activos',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: jugadoresGlobal.length,
                          itemBuilder: (BuildContext ctx, int i) {
                            PlayerModel jugador = jugadoresGlobal[i];

                            String formattedStartTime =
                                FormattedTime.getFormattedTime(jugador.start);

                            String formattedEndTime =
                                FormattedTime.getFormattedTime(jugador.end);

                            //Condición para solamente elegir a los activos
                            return Slidable(
                              endActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                    borderRadius: BorderRadius.circular(5),
                                    onPressed: (context) {
                                      _erasePlayer(context, jugador);
                                    },
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                  ),
                                  SlidableAction(
                                    borderRadius: BorderRadius.circular(5),
                                    onPressed: (context) {
                                      _updatePlayer(context, jugador);
                                    },
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
                                    leading: Icon(
                                      Icons.person,
                                      color: jugador.isActive
                                          ? Colors.green
                                          : Colors.red,
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
                                    trailing: Icon(
                                      Icons.check_circle,
                                      color: jugador.isActive
                                          ? Colors.green
                                          : Colors.red,
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
                const VerticalDivider(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Usuarios sin tiempo',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: jugadoresInactivos.length,
                          itemBuilder: (BuildContext ctx, int i) {
                            PlayerModel jugadorInactivo = jugadoresInactivos[i];

                            String formattedStartTime =
                                FormattedTime.getFormattedTime(
                                    jugadorInactivo.start);

                            String formattedEndTime =
                                FormattedTime.getFormattedTime(
                                    jugadorInactivo.end);

                            //Condición para solamente elegir a los activos
                            return Padding(
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
                                    jugadorInactivo.name,
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
        },
      ),
    );
  }

  _erasePlayer(BuildContext context, PlayerModel player) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text(
          'Borrar Jugador',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        scrollable: true,
        content: ErasePlayerModal(
          playerInfo: player,
        ),
      ),
    );
  }

  _updatePlayer(BuildContext context, PlayerModel player) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text(
          'Editar Jugador',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        scrollable: true,
        content: UpdatePlayerModal(
          jugadorRecibido: player,
        ),
      ),
    );
  }

  Future<void> updatePlayerStatus(PlayerModel player) async {
    try {
      await supabase.from('active_players').update({
        'is_active': false,
      }).eq('id_active_users', player.idActiveUsers!);
      setState(() {
        jugadoresInactivos.insert(0, player);
        jugadoresGlobal.remove(player);
      });
      if (!mounted) return;
    } on PostgrestException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Ocurrió un error al intentar editar al jugador -> ${e.message}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ));
    }
  }
}
