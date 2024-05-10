import 'package:audioplayers/audioplayers.dart';
import 'package:playmax_app_1/data/player_model.dart';
import 'package:playmax_app_1/presentation/providers/active_players_provider.dart';
import 'package:playmax_app_1/presentation/providers/inactive_players_provider.dart';
import 'package:playmax_app_1/presentation/providers/sound_alarm_provider.dart';
import 'package:playmax_app_1/presentation/providers/timers_management_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'supabase_instance.g.dart';

@Riverpod(keepAlive: true)
class SupabaseManagement extends _$SupabaseManagement {
  @override
  SupabaseClient build() {
    final supabaseClient = Supabase.instance.client;
    return supabaseClient;
  }

  Future<void> updatePlayerStatus(PlayerModel player) async {
    AudioPlayer soundAlarm = ref.read(soundAlarmProvider);

    try {
      await state.from('active_players').update({
        'is_active': false,
      }).eq('id_active_users', player.idActiveUsers!);
      //Actualizar los listados globales de players
      ref
          .read(inactivePlayersListProvider.notifier)
          .addInactivePlayerInFirstPlace(player);
      ref.read(activePlayersListProvider.notifier).removeActivePlayer(player);

      //Reproducir sonido del provider de sound alarm
    } on PostgrestException catch (e) {
      throw e.message;
    }
    await soundAlarm.play(AssetSource('sounds/playmax_alarm_mixdown.mp3'));
  }

  //Funciones con supabase
  //ADD PLAYER TO DB
  Future<String> wasPlayerCreated(PlayerModel player) async {
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
          updatePlayerStatus(nuevoPlayer);
        });
      }
    }

    try {
      var newPlayerInfo = await state
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
  Future<String> wasPlayerErased(PlayerModel player) async {
    //Borrar el timer actual del player que se está borrando
    ref
        .read(timerManagementProvider.notifier)
        .cancelTimer(player.idActiveUsers!);
    try {
      await state
          .from('active_players')
          .delete()
          .eq('id_active_users', player.idActiveUsers!);

      return 'success';
    } on PostgrestException catch (e) {
      return e.message;
    }
  }

  //UPDATE PLAYER IN DB
  Future<String> wasPlayerUpdated(PlayerModel player) async {
    final timerProvider = ref.read(timerManagementProvider.notifier);
    void setupTimer(int newPlayerId) {
      //need to convert each TimeOfDay to DateTime to compare them
      DateTime now = DateTime.now();
      DateTime endDateTime = DateTime(
          now.year, now.month, now.day, player.end.hour, player.end.minute);

      //calculate difference (cuánto le queda con respecto a la hora ACTUAL)
      int secondsToEnd = endDateTime.difference(now).inSeconds;

      //Set the timer in the provider conditioned to secondsToEnd
      if (secondsToEnd > 0) {
        timerProvider.setTimer(
            player.idActiveUsers!, Duration(seconds: secondsToEnd), () {
          updatePlayerStatus(player);
        });
      }
    }

    Map playerMap = player.toJson();
    try {
      await state
          .from('active_players')
          .update(playerMap)
          .eq('id_active_users', player.idActiveUsers!);
      //Cancelar el timer anterior
      timerProvider.cancelTimer(player.idActiveUsers!);
      //Agregar un nuevo timer con la nueva tiempo
      setupTimer(player.idActiveUsers!);
      return 'success';
    } on PostgrestException catch (e) {
      return e.message;
    }
  }
}
