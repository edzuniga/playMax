import 'package:playmax_app_1/data/player_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'inactive_players_provider.g.dart';

@riverpod
class InactivePlayersList extends _$InactivePlayersList {
  @override
  List<PlayerModel> build() {
    return [];
  }

  //Agregar jugador inactivo al estado
  void addInactivePlayer(PlayerModel player) {
    state = [...state, player];
  }
}
