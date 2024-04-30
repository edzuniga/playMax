import 'package:flutter/material.dart';
import 'package:playmax_app_1/data/player_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'active_players_provider.g.dart';

@riverpod
class ActivePlayers extends _$ActivePlayers {
  @override
  List<PlayerModel> build() {
    List<PlayerModel> activePlayersList = [
      PlayerModel(
        name: 'Edgardo Zúniga',
        start: const TimeOfDay(hour: 17, minute: 10),
        end: TimeOfDay.now(),
      ),
      PlayerModel(
          name: 'Julia Martínez',
          start: const TimeOfDay(hour: 17, minute: 10),
          end: TimeOfDay.now(),
          isActive: false),
    ];
    return activePlayersList;
  }

  void addPlayer(PlayerModel player) {
    state = [...state, player];
  }
}
