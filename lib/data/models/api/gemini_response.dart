import 'package:hive/hive.dart';

part 'gemini_response.g.dart';


@HiveType(typeId: 1)
class GeminiResponse {
  @HiveField(0)
  final String text;

  GeminiResponse({required this.text});


  factory GeminiResponse.fromJson(Map<String, dynamic> json) {
    return GeminiResponse(text: json['text'] as String);
  }


  Map<String, dynamic> toJson() => {'text': text};
}