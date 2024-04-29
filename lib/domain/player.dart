abstract class Player {
  Player({
    required this.name,
    required this.start,
    required this.end,
    this.isActive = true,
  });
  final String name;
  final DateTime start;
  final DateTime end;
  final bool isActive;
}
