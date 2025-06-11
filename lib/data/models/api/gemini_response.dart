// Model for storing Gemini AI responses locally in Immuno Warriors.
import 'package:hive/hive.dart';

part 'gemini_response.g.dart';

@HiveType(typeId: 15)
class GeminiResponse extends HiveObject {
  @HiveField(0)
  final String text;

  GeminiResponse({required this.text});

  factory GeminiResponse.fromJson(Map<String, dynamic> json) {
    return GeminiResponse(text: json['text'] as String);
  }

  Map<String, dynamic> toJson() => {'text': text};

  /// Validates if the response is non-empty.
  bool get isValid => text.trim().isNotEmpty;
}
