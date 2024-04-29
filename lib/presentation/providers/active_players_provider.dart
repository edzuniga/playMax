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
        start: DateTime(2024, 4, 29, 3, 20, 00),
        end: DateTime.now(),
      ),
      PlayerModel(
          name: 'Julia Martínez',
          start: DateTime(2024, 4, 29, 3, 20, 00),
          end: DateTime.now(),
          isActive: false),
    ];
    return activePlayersList;
  }

  void addPlayer(PlayerModel player) {
    state = [...state, player];
  }
}
