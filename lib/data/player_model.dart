import 'package:playmax_app_1/domain/player.dart';

class PlayerModel extends Player {
  PlayerModel({
    required super.name,
    required super.start,
    required super.end,
    super.isActive,
  });
}
