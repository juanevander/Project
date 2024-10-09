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

  static Future<List<Answer>> fetchAnswers() async {
    final response =
        await http.get(Uri.parse('http://192.168.89.71:80/api/answer'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      var getAnswersData = json.decode(response.body) as List;
      var listAnswers =
          getAnswersData.map((i) => Answer.fromJson(i)).toList();
      return listAnswers;
    } else {
      throw Exception('Failed to fetch in Answers');
    }
  }
}
