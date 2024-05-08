import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:playmax_app_1/data/player_model.dart';
import 'package:playmax_app_1/presentation/providers/active_players_provider.dart';
import 'package:playmax_app_1/presentation/providers/inactive_players_provider.dart';
import 'package:playmax_app_1/presentation/providers/timers_management_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseManager {
  static final SupabaseManager _instance = SupabaseManager._internal();
  late final SupabaseClient supabaseClient;

  factory SupabaseManager() {
    return _instance;
  }

  SupabaseManager._internal() {
    supabaseClient = Supabase.instance.client;
  }

  //Supabase methods
  //ADD PLAYER TO DB
  Future<String> wasPlayerCreated(PlayerModel player, WidgetRef ref) async {
    Map playerMap = player.toJson();
    void setupTimer(int newPlayerId) {
      //need to convert each TimeOfDay to DateTime to compare them
      DateTime now = DateTime.now();
      DateTime endDateTime = DateTime(
          now.year, now.month, now.day, player.end.hour, player.end.minute);

      //calculate difference (cuánto le queda con respecto a la hora ACTUAL)
      int secondsToEnd = endDateTime.difference(now).inSeconds;

      //Nuevo player model para enviarlo
      PlayerModel nuevoPlayer = player.copyWith(idActiveUsers: newPlayerId);

      //Set the timer in the provider conditioned to secondsToEnd
      if (secondsToEnd > 0) {
        ref
            .read(timerManagementProvider.notifier)
            .setTimer(newPlayerId, Duration(seconds: secondsToEnd), () {
          _updatePlayerStatus(nuevoPlayer, ref);
        });
      }
    }

    try {
      var newPlayerInfo = await supabaseClient
          .from('active_players')
          .insert(playerMap)
          .select('id_active_users');
      int idNewlyPlayer = newPlayerInfo.first['id_active_users'];
      //crear el timer para el jugador recién creado
      setupTimer(idNewlyPlayer);
      return 'success';
    } on PostgrestException catch (e) {
      return e.message;
    }
  }

  //ERASE PLAYER FROM DB
  Future<String> wasPlayerErased(PlayerModel player, WidgetRef ref) async {
    //Borrar el timer actual del player que se está borrando
    ref
        .read(timerManagementProvider.notifier)
        .cancelTimer(player.idActiveUsers!);
    try {
      await supabaseClient
          .from('active_players')
          .delete()
          .eq('id_active_users', player.idActiveUsers!);

      return 'success';
    } on PostgrestException catch (e) {
      return e.message;
    }
  }

  Future<void> _updatePlayerStatus(PlayerModel player, WidgetRef ref) async {
    try {
      await supabaseClient.from('active_players').update({
        'is_active': false,
      }).eq('id_active_users', player.idActiveUsers!);
      //Actualizar los listados globales de players
      ref
          .read(inactivePlayersListProvider.notifier)
          .addInactivePlayerInFirstPlace(player);
      ref.read(activePlayersListProvider.notifier).removeActivePlayer(player);

      // await _play();
    } on PostgrestException catch (e) {
      throw e.message;
    }
  }
}
