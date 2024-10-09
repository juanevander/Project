import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:data_1/quiz_screen.dart';
import 'package:data_1/model/Area.dart';
import 'package:data_1/model/User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'detail_page.dart';

enum FilterOptions {
  sent,
  draft,
  allItems,
}

class DraftPage extends StatefulWidget {
  final List<Report> items;
  final Area area;
  final String? userId;

  DraftPage({
    required this.items,
    required this.area,
    required this.userId,
  });

  @override
  _DraftPageState createState() => _DraftPageState();
}

class _DraftPageState extends State<DraftPage> {
  String searchQuery = '';


  void _showDetailsDialog(BuildContext context, ListItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Details"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Answer: ${item.buildTitle(context)}"),
              Text("Issue: ${item.buildSubtitle(context)}"),
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

  Future<List<DailyInspectionSummary>> fetchDailyInspectionSummary() async {
    print(widget.userId);
    final url = 'http://gmp.mandiricoal.net/api/daily+inspection+summary';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<DailyInspectionSummary> dailyInspectionSummaryList =
          data.map((item) => DailyInspectionSummary.fromJson(item)).toList();
      return dailyInspectionSummaryList
          .where((item) => item.user_id == widget.userId)
          .toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    _getUserIdFromPrefs();
    super.initState();
  }

  void _getUserIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    print("User ID from shared preferences: $userId");
  }

  void _navigateToDetailPage(BuildContext context, ListItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(
          reports: widget.items,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final String title = widget.area.area_name;
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        actions: [
          PopupMenuButton<FilterOptions>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: FilterOptions.sent,
                child: Text("Sent"),
              ),
              PopupMenuItem(
                value: FilterOptions.draft,
                child: Text("Draft"),
              ),
              PopupMenuItem(
                value: FilterOptions.allItems,
                child: Text("All Items"),
              ),
            ],
            onSelected: (value) {
              print("Selected filter: $value");
            },
            child: Icon(Icons.filter_list),
          ),
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () {
              saveInspectionData();
              print('Sync action');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<DailyInspectionSummary>>(
        future: fetchDailyInspectionSummary(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // return Center(child: Text('Error: ${snapshot.error}'));
            return FutureBuilder<List<Map<String, dynamic>>>(
              future: getUnsentInspectionData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final List<Map<String, dynamic>> unsentInspectionData =
                      snapshot.data!;

                  if (unsentInspectionData.isEmpty) {
                    return Center(
                        child: Text('Tidak ada data inspeksi yang tersimpan'));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: unsentInspectionData.length,
                    itemBuilder: (context, index) {
                      final inspection = unsentInspectionData[index];
                      return ListTile(
                        title: Text('Data Inspeksi #${index + 1}'),
                        subtitle: Text('Tanggal: ${inspection['tanggal']}'),
                      );
                    },
                  );
                } else {
                  return Center(
                      child: Text('Tidak ada data inspeksi yang tersimpan'));
                }
              },
            );
          } else if (snapshot.hasData) {
            final List<DailyInspectionSummary> dailyInspectionSummaryList =
                snapshot.data!;
            List<ListItem> filteredItems = dailyInspectionSummaryList
                .where((item) => item.user_id == widget.userId)
                .map((item) => MessageItem(item.id, item.date))
                .toList();

            if (searchQuery.isNotEmpty) {
              filteredItems = filteredItems
                  .where((item) => item
                      .buildTitle(context)
                      .toString()
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()))
                  .toList();
            }


            return ListView.builder(
              itemCount: filteredItems.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: 16,
                      bottom: 8,
                      left: 16,
                      right: 16,
                    ),
                    child: Text(
                      widget.area.area_name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  );
                }

                if (index <= filteredItems.length) {
                  final item = filteredItems[index - 1];


              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
      floatingActionButton: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: [Color(0xFF42A5F5), Color(0xFF2979FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizScreen(
                  areaId: widget.area.id.toString(),
                  userId: widget.userId.toString(),
                ),
              ),
            );
          },
          tooltip: 'Create',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

abstract class ListItem {
  Widget buildTitle(BuildContext context);
  Widget buildSubtitle(BuildContext context);
}

class MessageItem implements ListItem {
  final String sender;
  final DateTime date;

  MessageItem(this.sender, this.date);

  @override
  Widget buildTitle(BuildContext context) => Text(sender);

  @override
  Widget buildSubtitle(BuildContext context) {
    final formattedDate =
        DateFormat('dd MMMM yyyy, EEEE', 'en_US').format(date);
    return Text(formattedDate);
  }
}

class DailyInspectionSummary {
  final String id;
  final DateTime date;
  final String user_id;

  DailyInspectionSummary({
    required this.id,
    required this.date,
    required this.user_id,
  });

  factory DailyInspectionSummary.fromJson(Map<String, dynamic> json) {
    return DailyInspectionSummary(
      id: json['id'],
      date: DateTime.parse(json['created_at']),
      user_id: json['user_id'],
    );
  }
}
