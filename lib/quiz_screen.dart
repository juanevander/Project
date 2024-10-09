import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:data_1/model/Question.dart';
import 'package:data_1/model/Answer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localstorage/localstorage.dart';
import 'package:image_picker/image_picker.dart';


class QuizScreen extends StatefulWidget {
  final String areaId;
  final String userId;

  const QuizScreen({Key? key, required this.areaId, required this.userId})
      : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String issueDescription = "";
  final LocalStorage storage = new LocalStorage('inspection_storage');
  List<Map<String, dynamic>> inspectionData = [];
  late PageController pageController;
  int currentPageIndex = 0;
  int? selectedAnswerIndex;
  List<Question> allQuestion = [];
  List<Answer> allAnswers = [];
  String? user_Id;
  String? location;
  String? imagePath; // Add location variable
  final TextEditingController _locationController = TextEditingController();


  @override
  void initState() {
    super.initState();
    pageController = PageController();
    fetchQuestionsSave();
    fetchQuestions();
    fetchAnswers();
    _getUserIdFromPrefs();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _getUserIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_Id = prefs.getString('userId');
    print("User ID from shared preferences: $user_Id");
  }

  void addInspectionsToLocalStorage(List<Map<String, dynamic>> inspectionData) {
    final inspection = json.encode(inspectionData);
    storage.setItem('inspection', inspection);
  }

  List<Answer> findAnswer(int idQuestion) {
    List<Answer> result = [];
    result = allAnswers
        .where((answers) => answers.question_id == idQuestion)
        .toList();
    return result;
  }

  void goToPreviousQuestion() {
    if (currentPageIndex == 1) {
      setState(() {
        location = inspectionData[currentPageIndex - 1]['location'] ?? '';
        _locationController.text = location!;
      });
    }

    if (currentPageIndex > 0) {
      pageController.animateToPage(
        currentPageIndex - 1,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }


  void goToNextQuestion() {
    if (currentPageIndex == 0) {
      setState(() {
        inspectionData[currentPageIndex]['location'] = location;
      });
    }

    if (currentPageIndex < inspectionData.length - 1) {

      pageController.animateToPage(
        currentPageIndex + 1,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }


  void selectAnswer(int answerIndex, int question_id) {
    // Find the issue description associated with the current question
    String issueDescription = "";
    for (var issue in issues) {
      if (issue['question_id'] == question_id) {
        issueDescription = issue['description'];
        break;
      }
    }

    setState(() {
      // Update the selectedAnswerIndex
      selectedAnswerIndex = answerIndex;

      // Create the data map with the appropriate values
      Map<String, dynamic> data = {
        "question_id": question_id,
        "answer_id": answerIndex,
        "created_at": DateTime.now().toIso8601String(),
        "user_id": user_Id,

      };

      // Update inspectionData with the new data

      // Call the submitIssue function with the appropriate parameters

      if (currentPageIndex < inspectionData.length) {
        inspectionData[currentPageIndex] = data;
      } else {
        inspectionData.add(data);
      }
      print(inspectionData[1]);
    });
  }


  }

  Future<void> saveInspectionData() async {
    final url = 'http://gmp.mandiricoal.net/api/store-inspections';

    try {
      if (inspectionData.length > 0) {
        List<Map<String, dynamic>> dataToSend = inspectionData.sublist(1);
        String jsonInspection = jsonEncode(dataToSend);
        print(dataToSend);

        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonInspection,
        );

        if (response.statusCode == 200) {
          print('Data inspeksi berhasil dikirim ke server');
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('inspection_data', jsonInspection);
          Navigator.pop(context, inspectionData);
        } else {
          print('Gagal mengirim data inspeksi ke server');
          print(jsonInspection);


      } else {
        print('Tidak ada data inspeksi yang akan dikirim :');
      }
    } catch (e) {
      List<Map<String, dynamic>> dataToSend = inspectionData.sublist(1);
      String jsonInspection = jsonEncode(dataToSend);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('unsent_inspection_data', jsonInspection);
      // getAllUnsentInspectionData();
      Navigator.pop(context, inspectionData);
      print("disimpan ke local");
      print('Terjadi kesalahan saat mengirim data inspeksi: $e');

      // // Simpan data inspeksi ke penyimpanan lokal jika terjadi kesalahan
      // final prefs = await SharedPreferences.getInstance();
      // prefs.setString('unsent_inspection_data', jsonInspection);
    }
  }

  Future<void> _confirmDeleteImage() async {
    return showDialog<void>(
      context: context,

      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Delete Image',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text('Are you sure you want to delete the image?'),
                SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(width: 16.0),
                    ElevatedButton(
                      child: Text('Delete'),
                      onPressed: () {
                        _removeImage();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Inspection'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          if (allQuestion.length > 0) {
            return SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: allQuestion.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return _buildLocationPage();
                    } else {
                      final question = allQuestion[index - 1];
                      selectedAnswerIndex =
                          inspectionData[index - 1]['answer_id'] as int?;

                      return Card(
                        child: ListView(
                          padding: EdgeInsets.all(16.0),
                          children: [
                            Text(
                              'Question ${index}:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(question.question),
                            SizedBox(height: 16.0),
                            Text(
                              'Answers:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Builder(builder: (BuildContext context) {
                              final List<Answer> answers =
                                  findAnswer(question.id);
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: answers.length,
                                itemBuilder:
                                    (BuildContext context, int answerIndex) {
                                  final answer = answers[answerIndex];
                                  final isSelected =
                                      inspectionData[currentPageIndex]
                                              ['answer_id'] ==
                                          answer.id;
                                  return GestureDetector(
                                    onTap: () =>
                                        selectAnswer(answer.id, question.id),
                                    child: Card(
                                      color: isSelected
                                          ? Colors.green
                                          : Colors.white,
                                      child: ListTile(
                                        title: Text(answer.answer),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                            SizedBox(height: 16.0),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {

                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(120, 30),
                                    primary: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    textStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    child: Text('Text your Issue'),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  onPageChanged: (int pageIndex) {
                    setState(() {
                      currentPageIndex = pageIndex;
                      selectedAnswerIndex =
                          inspectionData[currentPageIndex]['answer_id'] as int?;
                    });
                  },
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: goToPreviousQuestion,
            child: Text('Previous'),
            style: ElevatedButton.styleFrom(
              primary: Colors.redAccent[300],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (currentPageIndex == inspectionData.length - 1) {
                saveInspectionData();
              } else {
                goToNextQuestion();
              }
            },
            child: Text(
              currentPageIndex == inspectionData.length - 1 ? 'Submit' : 'Next',
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.green[500],
            ),
          ),
        ],
      ),
    );
  }


      setState(() {
        this.imageBytes = imageBytes;
        inspectionData[currentPageIndex]['image_bytes'] = imageBytes;
        // Also set the imagePath if you're using it for deletion later
        imagePath = pickedImage.path;
      });

      setState(() {
        allQuestion = filteredQuestions;
      });
    } else {
      print("Pertanyaan Kosong");
    }
  }

  Future<void> fetchAnswers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String answersJson = prefs.getString('answers') ?? '';
      final List<Answer> questionsFromLocalStorage =
          answersFromJson(answersJson);
      // final List<Answer> answers = await Answer.fetchAllAnswers();
      setState(() {
        allAnswers = questionsFromLocalStorage;
      });
    } catch (e) {
      throw Exception('Failed to fetch answers: $e');
    }
  }

  List<Question> questionsFromJson(String json) {
    final List<dynamic> parsedJson = jsonDecode(json);
    return parsedJson.map((json) => Question.fromJson(json)).toList();
  }

  List<Answer> answersFromJson(String json) {
    final List<dynamic> parsedJson = jsonDecode(json);
    return parsedJson.map((json) => Answer.fromJson(json)).toList();
  }

  Future<List<Question>> fetchQuestionsSave() async {
    final prefs = await SharedPreferences.getInstance();
    final String questionsJson = prefs.getString('questions') ?? '';

    if (questionsJson.isNotEmpty) {
      final List<Question> questionsFromLocalStorage =
          questionsFromJson(questionsJson);

      final List<Question> questions =
          questionsFromLocalStorage.where((question) {
        return question.areaId == widget.areaId;
      }).toList();

      inspectionData = List.generate(
          questions.length, (_) => {'question_id': null, 'answer_id': 0});
      return questions;
    } else {
      throw Exception('No questions available'); // Add a throw statement
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: QuizScreen(areaId: 'area_id', userId: 'user_id'),
  ));
}
