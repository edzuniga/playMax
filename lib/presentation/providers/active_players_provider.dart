import 'package:flutter/material.dart';
import 'package:playmax_app_1/data/player_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
    final DateTime hoy = DateTime.now();
    final DateTime inicioDelDia = DateTime(hoy.year, hoy.month, hoy.day);
    final DateTime finDelDia =
        DateTime(hoy.year, hoy.month, hoy.day, 23, 59, 59);

    final supabase = Supabase.instance.client;
    final res = await supabase
        .from('active_players')
        .select()
        .gte('created_at', inicioDelDia)
        .lte('created_at', finDelDia);

    //Agregar cada jugador obtenido al state de jugadores activos
    for (var jugador in res) {
      final timePartsInicio = jugador['inicio'].toString().split(':');
      TimeOfDay inicio = TimeOfDay(
          hour: int.parse(timePartsInicio[0]),
          minute: int.parse(timePartsInicio[1]));
      final timePartsFin = jugador['fin'].toString().split(':');
      TimeOfDay fin = TimeOfDay(
          hour: int.parse(timePartsFin[0]), minute: int.parse(timePartsFin[1]));
      state.add(PlayerModel(
        idActiveUsers: jugador['id_active_users'],
        name: jugador['name'].toString(),
        start: inicio,
        end: fin,
        isActive: jugador['is_active'],
      ));
    }

    print(state);

    return state;
  }

  void addPlayer(PlayerModel player) {
    state = [...state, player];
  }
}
