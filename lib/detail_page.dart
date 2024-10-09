import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Report {
  String location;
  String imageUrl;
  List<DailyInspection> dailyInspections;

  Report({
    required this.location,
    required this.imageUrl,
    required this.dailyInspections,
  });
}

class DailyInspection {
  String question;
  String answer;
  String issue;

  DailyInspection({
    required this.question,
    required this.answer,
    required this.issue,
  });
}

class DetailPage extends StatelessWidget {
  final List<Report> reports;

  DetailPage({required this.reports});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page'),
      ),
      body: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
          Report report = reports[index];
          return ExpansionTile(

            children: [
              ListTile(
                title: Text(report.location),
                trailing: IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: () {
                    _showImageDialog(context, report);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showImageDialog(BuildContext context, Report report) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(report.location),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(report.imageUrl),
              SizedBox(height: 8),

              Column(
                children: report.dailyInspections.map((inspection) {
                  return _buildQuestionAndAnswer(
                    inspection.question,
                    inspection.answer,
                    inspection.issue,
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuestionAndAnswer(
    String question,
    String answer,
    String issue,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question),
        SizedBox(height: 4),

        SizedBox(height: 4),
        Text('Issue: $issue'),
        SizedBox(height: 8),
      ],
    );
  }
}

void main() {
  List<Report> dummyReports = [
    Report(

        ),
      ],
    ),
    Report(

  ];

  runApp(MyApp(reports: dummyReports));
}

class MyApp extends StatelessWidget {
  final List<Report> reports;

  MyApp({required this.reports});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DetailPage(reports: reports),
    );
  }
}
