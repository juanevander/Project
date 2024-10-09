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

  // static Future<List<Question>> fetchAllQuestions() async {
  //   final response = await http.get(Uri.parse('http://192.168.1.104:80/api/question'));
  //
  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> jsonData = json.decode(response.body);
  //     final List<dynamic> questionList = jsonData['questions'];
  //     return questionList.map((question) => Question.fromJson(question)).toList();
  //   } else {
  //     throw Exception('Failed to fetch questions');
  //   }
  // }
  static Future<List<Question>> fetchQuestions() async {
    final response =
        await http.get(Uri.parse('http://192.168.89.71:80/api/question'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      var getQuestionsData = json.decode(response.body) as List;
      var listQuestions =
          getQuestionsData.map((i) => Question.fromJson(i)).toList();
      return listQuestions;
      // return jsonData.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch in questions');
    }
  }
}
