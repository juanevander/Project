import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:data_1/quiz_screen.dart';
import 'model/Area.dart';

enum FilterOptions {
  sent,
  draft,
  allItems,
}

class DraftPage extends StatelessWidget {
  final List<ListItem> items;
  final Area area;

  const DraftPage({Key? key, required this.items, required this.area})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String title = area.area_name;

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
              print('Sync action');
            },
          ),
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: Text(
                area.area_name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            )
          : ListView.builder(
              itemCount: items.length + 1,
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
                      area.area_name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  );
                }

                final item = items[index - 1];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(0xffb0b0b4),
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: item.buildTitle(context),
                      subtitle: item.buildSubtitle(context),
                    ),
                    Divider(
                      color: Colors.grey.withOpacity(0.5),
                      indent: 72,
                      endIndent: 16,
                      thickness: 1,
                    ),
                  ],
                );
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
              MaterialPageRoute(builder: (context) => QuizScreen(area: area)),
            );
          },
          tooltip: 'Create',
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomAppBar(
        color: Color(0xfffffefe),
        elevation: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    // Navigate to Home page
                  },
                  child: Icon(
                    Icons.home,
                    size: 25,
                    color: Color(0xff4b4949),
                  ),
                ),
                Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff757373),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    // Navigate to Draft page
                  },
                  child: Icon(
                    Icons.dashboard,
                    size: 25,
                    color: Color(0xff4b4949),
                  ),
                ),
                Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff757373),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    // Navigate to Profile page
                  },
                  child: Icon(
                    Icons.person,
                    size: 25,
                    color: Color(0xff4b4949),
                  ),
                ),
                Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff757373),
                  ),
                ),
              ],
            ),
          ],
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
