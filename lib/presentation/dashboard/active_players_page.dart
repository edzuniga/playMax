import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:playmax_app_1/data/player_model.dart';
import 'package:playmax_app_1/presentation/providers/active_players_provider.dart';

class ActivePlayersPage extends ConsumerWidget {
  const ActivePlayersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Get the active players provider
    final activePlayersList = ref.watch(activePlayersProvider);
    //screen size
    Size screenSize = MediaQuery.of(context).size;

    return (kIsWeb)
        ? webScreen(activePlayersList, screenSize)
        : mobileScreen(activePlayersList);
  }

  //MOBILE SCREEN
  RefreshIndicator mobileScreen(List<PlayerModel> activePlayersList) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 2));
        //TODO construir el refresacamiento del listado
      },
      child: ListView.builder(
        itemCount: activePlayersList.length,
        itemBuilder: (BuildContext ctx, int i) {
          String formattedStartTime =
              _getFormattedTime(activePlayersList[i].start);
          String formattedEndTime = _getFormattedTime(activePlayersList[i].end);
          return Slidable(
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  borderRadius: BorderRadius.circular(5),
                  onPressed: (context) {},
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Borrar',
                ),
                SlidableAction(
                  borderRadius: BorderRadius.circular(5),
                  onPressed: (context) {},
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Editar',
                ),
              ],
            ),
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(activePlayersList[i].name),
              subtitle:
                  Text("Inicio: $formattedStartTime \nFin: $formattedEndTime"),
              trailing: (activePlayersList[i].isActive)
                  ? const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.highlight_remove_outlined,
                      color: Colors.red,
                    ),
            ),
          );
        },
      ),
    );
  }

  //WEB SCREEN
  Row webScreen(List<PlayerModel> activePlayersList, Size screenSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 10,
          ),
          width: screenSize.width * 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
                child: Text(
                  'Usuarios Activos',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold),
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
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            borderRadius: BorderRadius.circular(5),
                            onPressed: (context) {},
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Borrar',
                          ),
                          SlidableAction(
                            borderRadius: BorderRadius.circular(5),
                            onPressed: (context) {},
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Editar',
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black12,
                              ),
                              borderRadius: BorderRadius.circular(8)),
                          child: ListTile(
                            dense: true,
                            leading: const Icon(
                              Icons.person,
                              color: Colors.green,
                            ),
                            title: Text(
                              activePlayersList[i].name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const TextSpan(
                                      text: '\nFin:',
                                    ),
                                    TextSpan(
                                      text: ' $formattedEndTime',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                            ),

                            /*Text(
                                "Inicio: $formattedStartTime \nFin: $formattedEndTime"), */
                            trailing: const Icon(
                              Icons.check_circle,
                              color: Colors.green,
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
        SizedBox(height: screenSize.height, child: VerticalDivider()),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 10,
          ),
          width: screenSize.width * 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
                child: Text(
                  'Usuarios Inactivos',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold),
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
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            borderRadius: BorderRadius.circular(5),
                            onPressed: (context) {},
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Borrar',
                          ),
                          SlidableAction(
                            borderRadius: BorderRadius.circular(5),
                            onPressed: (context) {},
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Editar',
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black12,
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const TextSpan(
                                      text: '\nFin:',
                                    ),
                                    TextSpan(
                                      text: ' $formattedEndTime',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                            ),
                            trailing: const Icon(
                              Icons.highlight_remove_outlined,
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
}
