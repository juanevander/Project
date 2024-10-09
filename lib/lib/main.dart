import 'package:flutter/material.dart';
import 'login.dart';
import 'reset_password.dart';
import 'reset_password_success.dart';
import 'homepage.dart';
import 'draft.dart';
import 'profile.dart';
import 'edit_profile.dart';
import 'model/Area.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghapus tulisan "Debug"
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFEDF1FF),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/resetPassword': (context) => ResetPasswordPage(),
        '/success': (context) => ResetSuccessPage(),
        '/home': (context) => HomePage(),
        '/draft': (context) => DraftPage(
              items: [],
              area: Area(
                id: '',
                area_name: 'Front Loading OB',
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
