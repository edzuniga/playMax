import 'package:playmax_app_1/data/player_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'active_players_provider.g.dart';

@riverpod
class ActivePlayers extends _$ActivePlayers {
  @override
  List<PlayerModel> build() {
    List<PlayerModel> activePlayersList = [];
    return activePlayersList;
  }

  //Fetch active player of the day
  Future<List<PlayerModel>> fetchActiveUsers() async {
/*
    //Agregar cada jugador obtenido al state de jugadores activos
    for (var jugador in res) {
      TimeOfDay inicio = stringToTimeOfDay(jugador['inicio']);
      TimeOfDay fin = stringToTimeOfDay(jugador['fin']);
      state.add(PlayerModel(
        idActiveUsers: jugador['id_active_users'],
        name: jugador['name'].toString(),
        start: inicio,
        end: fin,
        isActive: jugador['is_active'],
      ));
    }
    */

    return state;
  }

  void addPlayer(PlayerModel player) {
    state = [...state, player];
  }
}
