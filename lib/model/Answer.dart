import 'dart:convert';
import 'package:http/http.dart' as http;

class Answer {
  final int id;
  final String answer;
  final int question_id;
  final int point;

  Answer({
    required this.id,
    required this.answer,
    required this.question_id,
    required this.point,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      answer: json['answer'],
      question_id: json['question_id'],
      point: json['point'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'answer': answer,
      'question_id': question_id,
      'point': point,
    };
  }

  static Future<List<Answer>> fetchAnswers(int questionId) async {
    final url = 'http://gmp.mandiricoal.net/api/answer/$questionId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      final List<Answer> answers = jsonData
          .map((json) => Answer.fromJson(json))
          .where((answer) => answer.question_id == questionId)
          .toList();
      return answers;
    } else {
      throw Exception('Failed to fetch answers');
    }
  }

  static Future<List<Answer>> fetchAllAnswers() async {
    final url = 'http://gmp.mandiricoal.net/api/answer';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      final List<Answer> answers = jsonData
          .map((json) => Answer.fromJson(json))
          // .where((answer) => answer.question_id == questionId)
          .toList();
      return answers;
    } else {
      throw Exception('Failed to fetch answers');
    }
  }
  List<Answer> answersFromJson(String json) {
    final List<dynamic> parsedJson = jsonDecode(json);
    return parsedJson.map((json) => Answer.fromJson(json)).toList();
  }
}
