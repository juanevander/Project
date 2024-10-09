import 'package:flutter/material.dart';
import 'login.dart';

class ResetSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    navigateToLoginPage(context); // Panggil fungsi untuk pindah ke halaman login

    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Success'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80,
            ),
            SizedBox(height: 16),
            Text(
              'Password has been reset successfully!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToLoginPage(BuildContext context) {
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }
}
