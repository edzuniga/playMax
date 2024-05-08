import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'timers_management_provider.g.dart';

@riverpod
class TimerManagement extends _$TimerManagement {
  @override
  Map<int, Timer> build() {
    return {};
  }

  void setTimer(int playerId, Duration duration, VoidCallback action) {
    state[playerId]?.cancel(); //Cancelar el timer anterior
    state = {
      ...state,
      playerId: Timer(duration, action),
    };
  }

  void cancelTimer(int playerId) {
    state[playerId]?.cancel();
    state.remove(playerId);
  }

  void disposeTimers() {
    //Cancelar todos los timers al deshacerse del Provider
    state.forEach((i, element) {
      element.cancel();
    });
  }
}
