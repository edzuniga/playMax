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

  void addPlayer(PlayerModel player) {
    state = [...state, player];
  }
}
