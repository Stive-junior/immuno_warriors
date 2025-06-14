import 'package:hive/hive.dart';
import '../../../domain/entities/research_entity.dart';

part 'research_model.g.dart';

@HiveType(typeId: 12)
class ResearchModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final int researchCost;
  @HiveField(4)
  final List<String> prerequisites;
  @HiveField(5)
  final Map<String, dynamic> effects;
  @HiveField(6)
  final int level;
  @HiveField(7)
  final bool isUnlocked;

  ResearchModel({
    required this.id,
    required this.name,
    required this.description,
    required this.researchCost,
    required this.prerequisites,
    required this.effects,
    required this.level,
    required this.isUnlocked,
  });

  factory ResearchModel.fromJson(Map<String, dynamic> json) {
    return ResearchModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      researchCost: json['cost'] as int,
      prerequisites: (json['prerequisites'] as List<dynamic>).cast<String>(),
      effects: json['effects'] as Map<String, dynamic>,
      level: json['level'] as int,
      isUnlocked: json['isUnlocked'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'cost': researchCost,
    'prerequisites': prerequisites,
    'effects': effects,
    'level': level,
    'isUnlocked': isUnlocked,
  };

  factory ResearchModel.fromEntity(ResearchEntity entity) {
    return ResearchModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      researchCost: entity.researchCost,
      prerequisites: entity.prerequisites,
      effects: entity.effects,
      level: entity.level,
      isUnlocked: entity.isUnlocked,
    );
  }

  ResearchEntity toEntity() {
    return ResearchEntity(
      id: id,
      name: name,
      description: description,
      researchCost: researchCost,
      prerequisites: prerequisites,
      effects: effects,
      level: level,
      isUnlocked: isUnlocked,
    );
  }

  /// Validates research cost for UI display.
  bool get isValid => researchCost >= 0 && id.isNotEmpty;
}
