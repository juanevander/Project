import 'package:flutter/material.dart';
import 'package:data_1/model/Question.dart';
import 'package:data_1/model/Answer.dart';
import 'package:data_1/model/Area.dart';

class QuizScreen extends StatefulWidget {
  final Area area;

  const QuizScreen({Key? key, required this.area}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> questions = [];
  List<Answer> answers = [];
  late PageController pageController;
  Map<int, int> selectedAnswers = {}; // Selected answers for each question

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    fetchQuestionsAndAnswers();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<void> fetchQuestionsAndAnswers() async {
    try {
      final List<Question> fetchedQuestions = await Question.fetchQuestions();
      final List<Answer> fetchedAnswers = await Answer.fetchAnswers();

      questions = fetchedQuestions
          .where((question) => question.areaId == widget.area.id)
          .toList();

      answers = fetchedAnswers;

      setState(() {});
    } catch (e) {
      print('Failed to fetch questions and answers: $e');
    }
  }

  List<Answer> getAnswersForQuestion(int questionId) {
    return answers.where((answer) => answer.question_id == questionId).toList();
  }

  void goToNextQuestion() {
    if (pageController.page!.toInt() < questions.length - 1) {
      pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToPreviousQuestion() {
    if (pageController.page!.toInt() > 0) {
      pageController.previousPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void selectAnswer(int questionId, int answerIndex) {
    setState(() {
      selectedAnswers[questionId] = answerIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz: ${widget.area.area_name}'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: PageView.builder(
            controller: pageController,
            itemCount: questions.length,
            itemBuilder: (BuildContext context, int index) {
              final question = questions[index];
              final answersForQuestion = getAnswersForQuestion(question.id);

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question ${question.numbering.toString()}:',
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
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: answersForQuestion.length,
                        itemBuilder: (BuildContext context, int answerIndex) {
                          final answer = answersForQuestion[answerIndex];
                          final isSelected =
                              selectedAnswers.containsKey(question.id) &&
                                  selectedAnswers[question.id] == answerIndex;

                          return GestureDetector(
                            onTap: () => selectAnswer(question.id, answerIndex),
                            child: Card(
                              color: isSelected ? Colors.green : Colors.white,
                              child: ListTile(
                                title: Text(answer.answer),
                                subtitle:
                                    Text('Point: ${answer.point.toString()}'),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: goToPreviousQuestion,
            child: Text('Previous'),
          ),
          ElevatedButton(
            onPressed: goToNextQuestion,
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}
