import 'package:playmax_app_1/data/player_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'inactive_players_provider.g.dart';

@Riverpod(keepAlive: true)
class InactivePlayersList extends _$InactivePlayersList {
  @override
  List<PlayerModel> build() {
    return [];
  }

  //Agregar jugador inactivo al estado
  void addInactivePlayer(PlayerModel player) {
    state = [...state, player];
  }

  //Agregar jugador inactivo al estado
  void addInactivePlayerInFirstPlace(PlayerModel player) {
    state = [player, ...state];
  }

  //Remover el jugador
  void removeInactivePlayer(PlayerModel player) {
    state.remove(player);
  }

  //borrar todo el listado
  void resetInactivePlayersList() {
    state.clear();
  }
}
