import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:data_1/homepage.dart';
import 'package:data_1/model/User.dart';
import 'package:data_1/model/Question.dart';
import 'package:data_1/model/Area.dart';
import 'package:data_1/model/Answer.dart';
import 'package:connectivity/connectivity.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.white],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/bg.png', // Ganti dengan path file logo yang sesuai
                    width: 300,
                    height: 100,
                  ),
                ],
              ),
              SizedBox(height: 32),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            child: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        obscureText: !_isPasswordVisible,
                      ),
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          navigateToResetPassword(context);
                        },
                        child: Text(
                          'Reset Password',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  bool isConnected = await _checkConnectivity();
                  if (isConnected) {
                    await login(
                        _usernameController.text, _passwordController.text);
                  } else {
                    // Implementasi tindakan ketika tidak terhubung ke internet
                    // Misalnya, tampilkan pesan atau berikan akses terbatas
                  }
                },
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 150, vertical: 23),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToHomePage(
      BuildContext context, User user, String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user.id.toString());

    Navigator.pushReplacementNamed(context, '/home', arguments: user);
  }

  void navigateToResetPassword(BuildContext context) {
    Navigator.pushNamed(context, '/resetPassword');
  }

  Future<void> login(String username, String password) async {
    String loginUrl = 'http://gmp.mandiricoal.net/api/apklogin';

    try {
      Map<String, String> requestData = {
        'email': username,
        'password': password,
      };

      http.Response response = await http.post(
        Uri.parse(loginUrl),
        body: requestData,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String accessToken = responseData['access_token'];
        User user = User.fromJson(responseData['user']);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        await prefs.setString('userId', user.id);
        await prefs.setString('userName', user.name);
        await prefs.setString('userEmail', user.email);
        await prefs.setString('userCompany', user.companyCode);
        await prefs.setString('userRole', user.role);
        await prefs.setBool('isLoggedIn', true); // Simpan status login

        // Fetch questions and answers
        List<Question> questions = await fetchAllQuestions();
        List<Answer> answers = await fetchAllAnswers();
        List<Area> areas = await fetchAllArea();
        print(areas);

        // Convert questions and answers to JSON strings
        String questionsJson =
            jsonEncode(questions.map((q) => q.toJson()).toList());
        String answersJson =
            jsonEncode(answers.map((a) => a.toJson()).toList());
        String areasJson = jsonEncode(areas.map((a) => a.toJson()).toList());

        // Save JSON strings to SharedPreferences
        await prefs.setString('questions', questionsJson);
        await prefs.setString('answers', answersJson);
        await prefs.setString('areas', areasJson);
        print(questions);
        print(answers);
        print(areas);
        navigateToHomePage(context, user, user.id);
      } else {
        showLoginErrorDialog(context);
      }
    } catch (error) {
      print(error);
      showLoginErrorDialog(context);
    }
  }

  Future<bool> _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<List<Question>> fetchAllQuestions() async {
    final url = 'http://gmp.mandiricoal.net/api/question';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      final List<Question> questions =
          jsonData.map((json) => Question.fromJson(json)).toList();
      return questions;
    } else {
      throw Exception('Failed to fetch questions');
    }
  }

  Future<List<Answer>> fetchAllAnswers() async {
    final url = 'http://gmp.mandiricoal.net/api/answer';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      final List<Answer> answers = jsonData
          .map((json) => Answer.fromJson(json))
          // .where((answer) => answer.question_id == questionId)
          .toList();
      return answers;
    } else {
      throw Exception('Failed to fetch answers');
    }
  }

  Future<List<Area>> fetchAllArea() async {
    final url = 'http://gmp.mandiricoal.net/api/area';
    final response = await http.get(Uri.parse(url));
    print(response);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      final List<Area> areas =
          jsonData.map((json) => Area.fromJson(json)).toList();
      // print(areas);
      return areas;
    } else {
      throw Exception('Failed to fetch areas');
    }
  }

  void showLoginErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Username or password is incorrect.'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
