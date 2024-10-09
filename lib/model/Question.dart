import 'dart:convert';
import 'package:http/http.dart' as http;

class Question {
  final int id;
  final String question;
  final int weight;
  final String areaId;
  final String status;
  final int numbering;

  Question({
    required this.id,
    required this.question,
    required this.weight,
    required this.areaId,
    required this.status,
    required this.numbering,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      question: json['question'],
      weight: json['weight'],
      areaId: json['area_id'],
      status: json['status'],
      numbering: json['numbering'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'weight': weight,
      'area_id': areaId,
      'status': status,
      'numbering': numbering,
    };
  }

  static Future<List<Question>> fetchQuestions(String areaId) async {
    final url = 'http://gmp.mandiricoal.net/api/question/$areaId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      final List<Question> questions =
          jsonData.map((json) => Question.fromJson(json)).toList();
      return questions;
    } else {
      throw Exception('Failed to fetch questions');
    }
  }

  static Future<List<Question>> fetchAllQuestions() async {
    final url = 'http://gmp.mandiricoal.net/api/question';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      final List<Question> questions =
          jsonData.map((json) => Question.fromJson(json)).toList();
      return questions;
    } else {
      throw Exception('Failed to fetch questions');
    }
  }

  List<Question> questionsFromJson(String json) {
    final List<dynamic> parsedJson = jsonDecode(json);
    return parsedJson.map((json) => Question.fromJson(json)).toList();
  }
}
