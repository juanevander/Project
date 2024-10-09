import 'package:flutter/material.dart';
import 'package:data_1/login.dart' as login;
import 'package:data_1/reset_password.dart';
import 'package:data_1/reset_password_success.dart';
import 'package:data_1/homepage.dart' as home;
import 'package:data_1/draft.dart';
import 'package:data_1/profile.dart';
import 'package:data_1/edit_profile.dart';
import 'package:data_1/model/Area.dart';
import 'package:data_1/model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString("userId");
  bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false; // Default to false

  runApp(MyApp(userId: userId, isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final String? userId;
  final bool isLoggedIn;
  const MyApp({Key? key, this.userId, required this.isLoggedIn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isLoggedIn
          ? home.HomePage(userId: userId)
          : login.LoginPage(), // Berdasarkan status login
      debugShowCheckedModeBanner: false, // Menghapus tulisan "Debug"
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFEDF1FF),
      ),
      initialRoute: '/',
      routes: {
        // '/': (context) => login.LoginPage(),
        '/resetPassword': (context) => ResetPasswordPage(),
        '/success': (context) => ResetSuccessPage(),
        '/home': (context) => home.HomePage(userId: userId),
        '/draft': (context) => DraftPage(
              userId: userId,
              items: [], // Isi dengan data draft yang sesuai
              area: Area(
                id: '',
                area_name: '',
                created_at: DateTime.now(),
                updated_at: DateTime.now(),
                status: '',
              ),
            ),
        '/profile': (context) => ProfilePage(
              name: '',
              email: '',
              company: '',
              role: '',
              onUpdateProfile:
                  (updatedName, updatedEmail, updatedCompany, updatedRole) {
                // Logika pembaruan profil di sini
              },
            ),
        '/editProfile': (context) => EditProfilePage(
              name: '',
              email: '',
              company: '',
              role: '',
            ),
      },
    );
  }
}
