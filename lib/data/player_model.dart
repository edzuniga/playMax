import 'package:playmax_app_1/domain/player.dart';

class PlayerModel extends Player {
  PlayerModel({
    required super.name,
    required super.start,
    required super.end,
    super.isActive,
    required super.idActiveUsers,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) => PlayerModel(
        idActiveUsers: json["id_active_users"],
        name: json["name"],
        start: json["inicio"],
        end: json["fin"],
        isActive: json["is_active"],
      );
}
