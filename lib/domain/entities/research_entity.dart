class ResearchEntity {
  final String id;
  final String name;
  final String description;
  final int cost;
  final List<String> prerequisites;
  final Map<String, dynamic> effects;
  final int level;
   bool isUnlocked;

  ResearchEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
    required this.prerequisites,
    required this.effects,
    required this.level,
    required this.isUnlocked,
  });

  copyWith({required bool isUnlocked}) {
    this.isUnlocked = isUnlocked;
  }

}