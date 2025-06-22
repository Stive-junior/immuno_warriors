/// Model for storing Gemini AI responses locally in Immuno Warriors.
import 'package:hive/hive.dart';

part 'gemini_response.g.dart';

@HiveType(typeId: 15)
class GeminiResponse extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String type;
  @HiveField(2)
  final String content;
  @HiveField(3)
  final String timestamp;

  GeminiResponse({
    required this.id,
    required this.type,
    required this.content,
    required this.timestamp,
  });

  factory GeminiResponse.fromJson(Map<String, dynamic> json) {
    return GeminiResponse(
      id: json['id'] as String,
      type: json['type'] as String,
      content: json['content'] as String,
      timestamp: json['timestamp'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'content': content,
      'timestamp': timestamp,
    };
  }
}