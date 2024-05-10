import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'sound_alarm_provider.g.dart';

@riverpod
class SoundAlarm extends _$SoundAlarm {
  @override
  AudioPlayer build() {
    return AudioPlayer();
  }

  void disposePlayer() {
    state.dispose();
  }
}
