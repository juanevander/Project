import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Report'),
      ),
      backgroundColor: Colors.grey[200],
      body: Container(
        padding: EdgeInsets.all(20),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Text(
                    'Send at least one file ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes the shadow position
                        ),
                      ],
                    ),
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      shrinkWrap: true,
                      children: [
                        FileUploadButton(label: 'Upload File 1'),
                        FileUploadButton(label: 'Upload File 2'),
                        FileUploadButton(label: 'Upload File 3'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: (screenHeight / 2) - 24, // 24 is half the button height
              right: 16,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to notification screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationScreen(),
                    ),
                  );
                },
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  minimumSize: Size(120, 48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FileUploadButton extends StatelessWidget {
  final String label;

  const FileUploadButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          IconButton(
            icon: Icon(Icons.cloud_upload),
            onPressed: () {
              // Implement upload file functionality here
            },
          ),
          SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 24),
            Text(
              'Successfully',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
