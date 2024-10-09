import 'package:flutter/material.dart';
import 'package:data_1/draft.dart'; // Update with your draft.dart file path
import 'package:data_1/profile.dart'; // Update with your profile.dart file path
import 'package:data_1/model/Area.dart'; // Update with your Area.dart file path

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Area>> futureAreas;
  List<Area> areas = [];
  PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    futureAreas = Area.fetchArea();
    // areas = futureAreas.toList()
  }

  String name = '';
  String email = '';
  String company = '';
  String role = '';

  @override
  Widget build(BuildContext context) {
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
                                      area: areas[
                                          index], // Pass the selected area
                                      items: [],
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
                  name: name,
                  email: email,
                  company: company,
                  role: role,
                  onUpdateProfile:
                      (updatedName, updatedEmail, updatedCompany, updatedRole) {
                    name = updatedName;
                    email = updatedEmail;
                    company = updatedCompany;
                    role = updatedRole;
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
}
