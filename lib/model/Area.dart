import 'dart:convert';
import 'package:http/http.dart' as http;

class Area {
  final String id;
  final String area_name;
  final DateTime created_at;
  final DateTime updated_at;
  final String? status;

  Area({
    required this.id,
    required this.area_name,
    required this.created_at,
    required this.updated_at,
    required this.status,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json['id'],
      area_name: json['area_name'],
      created_at: DateTime.parse(json['created_at']),
      updated_at: DateTime.parse(json['updated_at']),
      status: json['status'],
    );
  }

Map<String, dynamic> toJson() {
    return {
      'id': id,
      'area_name': area_name,
      'created_at': created_at.toIso8601String(),
      'updated_at':
          updated_at.toIso8601String(), // Tambahkan .toIso8601String()
      'status': status,
    };
  }

  static Future<List<Area>> fetchArea() async {
    final response =
        await http.get(Uri.parse('http://gmp.mandiricoal.net/api/area'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      var getAreasData = json.decode(response.body) as List;
      var listAreas = getAreasData.map((i) => Area.fromJson(i)).toList();
      return listAreas;
      // return jsonData.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch in areas');
    }
  }
}
