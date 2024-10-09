import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:data_1/quiz_screen.dart';
import 'package:data_1/model/Area.dart';
import 'package:data_1/model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile.dart';
import 'draft.dart';
import 'dart:convert';

enum FilterOptions {
  sent,
  draft,
  allItems,
}

class HomePage extends StatefulWidget {
  // final User user;
  final String? userId;
  final User? user;

  const HomePage({Key? key, this.user, this.userId}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Area>> futureAreas = Future.value([]);
  List<Area> areas = [];
  PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    fetchArea();
    // widget.userId = this.userId;
    // Map<String, dynamic> userMap = json.decode(widget.user?.id ?? "N/A");
    // String? userIdValue = userMap['id'];
    // print(widget.userId);
    _getUserIdFromPrefs();

    // print('string');
    // areas = futureAreas.toList()
  }

  void _getUserIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    print("User ID from shared preferences: $userId");
  }

  @override
  Widget build(BuildContext context) {
    // print('ini user_id');

    // print(widget.userId);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 130,
              flexibleSpace: Container(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'images/bg.png', // Replace with your image path
                  width: 150,
                  height: 130,
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: Container(
          margin: EdgeInsets.only(top: 15),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  height: 270,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: PageView(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          'images/news.png', // Replace with your image path
                          fit: BoxFit.cover,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          'images/news2.png', // Replace with your image path
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                sliver: FutureBuilder<List<Area>>(
                  future: futureAreas,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasError) {
                      return SliverToBoxAdapter(
                        child: Center(child: Text('Error: ${snapshot.error}')),
                      );
                    } else if (snapshot.hasData) {
                      List<Area> areas = snapshot.data!;
                      return SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 15,
                          childAspectRatio: 1.15,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            String title =
                                areas.isNotEmpty ? areas[index].area_name : '';
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DraftPage(
                                      area: areas[index],
                                      items: [],
                                      userId:
                                          widget.userId, // Pass the user object
                                    ),
                                  ),
                                );
                              },
                              child: buildTable(title),
                            );
                          },
                          childCount: areas.length,
                        ),
                      );
                    } else {
                      return SliverToBoxAdapter(
                        child: Center(child: Text('No data available')),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (int index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                  name: "widget.user.name",
                  email: "widget.user.email",
                  company: "widget.user.companyCode",
                  role: "widget.user.role",
                  onUpdateProfile:
                      (updatedName, updatedEmail, updatedCompany, updatedRole) {
                    // Logic to update the profile
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildTable(String title) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black45.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 19),
        textAlign: TextAlign.left,
      ),
    );
  }

Future<void> fetchArea() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String areasJson = prefs.getString('areas') ?? '';
      print(areas);

      if (areasJson.isNotEmpty) {
        // Add this check
        List<Area> areasFromLocalStorage = areasFromJson(areasJson);
        setState(() {
          futureAreas = Future.value(areasFromLocalStorage);
        });
      }
      else{
        print("area kosong");
      }
    } catch (e) {
      throw Exception('Failed to fetch areas: $e');
    }
  }


  List<Area> areasFromJson(String json) {
    final List<dynamic> parsedJson = jsonDecode(json);
    return parsedJson.map((json) => Area.fromJson(json)).toList();
  }
}
