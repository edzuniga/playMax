import 'package:playmax_app_1/data/player_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'active_players_provider.g.dart';

@Riverpod(keepAlive: true)
class ActivePlayersList extends _$ActivePlayersList {
  @override
  List<PlayerModel> build() {
    return [];
  }

  //Agregar jugador inactivo al estado
  void addActivePlayer(PlayerModel player) {
    state = [...state, player];
  }

  //Agregar jugador inactivo al estado
  void addActivePlayerInFirstPlace(PlayerModel player) {
    state = [player, ...state];
  }

  //Remover el jugador
  void removeActivePlayer(PlayerModel player) {
    state.remove(player);
  }

  //borrar todo el listado
  void resetActivePlayersList() {
    state.clear();
  }
}
