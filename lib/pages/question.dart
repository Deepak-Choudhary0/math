import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:math/pages/discussion.dart' as second;
import 'package:math/pages/game.dart' as third;
import 'package:math/pages/profile.dart' as fourth;

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  List<String> questions = [
    'What is 7+3?',
    'What is 7*3?',
  ];
  List<List<String>> options = [
    ['10', '11', '23', '16'],
    ['10', '21', '11', '24'],
  ];
  List<int> answers = [
    10,
    21,
  ];
  int dataFetchCount = 0;
  int currentQuestionIndex = 0;
  bool isAnswered = false;
  String selectedOption = '';

  void checkAnswer(String selectedAnswer) {
    setState(() {
      isAnswered = true;
      selectedOption = selectedAnswer;
    });
  }

  void getData() async {
    var collection = FirebaseFirestore.instance.collection('questions');

    try {
      if (dataFetchCount == 0) {
        var querySnapshot = await collection.get();
        for (var queryDocumentSnapshot in querySnapshot.docs) {
          Map<String, dynamic> data = queryDocumentSnapshot.data();
          var $question = data['question'].toString();
          var $options = List<String>.from(data['options']);
          var $answer = int.parse(data['correctAnswer']);
          questions.add($question);
          options.add($options);
          answers.add($answer);
          dataFetchCount++;
        }
      } else {
        print("Already Fetched");
      }
    } catch (e) {
      if (e != "FormatException: 0.06") {
        print('Error fetching data: $e--');
      }
    }
  }

  void goToNextQuestion() {
    print(selectedOption.runtimeType);
    setState(() {
      isAnswered = false;
      selectedOption = '';
      currentQuestionIndex = (currentQuestionIndex + 1) % questions.length;
    });
    getData();
  }

  int _selectedIndex = 0;
  final List<GButton> _tabs = const [
    GButton(
      icon: Icons.home,
      text: "Home",
    ),
    GButton(
      icon: Icons.chat,
      text: "Ask Doubt",
    ),
    GButton(
      icon: Icons.games,
      text: "Games",
    ),
    GButton(
      icon: Icons.account_box_outlined,
      text: "Profile",
    ),
  ];
  void _onItemTapped(int index) {
    setState(
      () {
        _selectedIndex = index;
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const second.DoubtPage()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const third.MathGamePage()),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => fourth.ProfilePage()),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String currentQuestion = questions[currentQuestionIndex];
    List<String> currentOptions = options[currentQuestionIndex];
    int correctAnswer = answers[currentQuestionIndex];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 40.0,
            ),
            Text(
              currentQuestion,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            for (String option in currentOptions)
              Container(
                margin: const EdgeInsets.all(
                    10.0), // Set the margin around the button
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: isAnswered ? null : () => checkAnswer(option),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal:
                                20.0), // Set the padding inside the button
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(
                              10.0)), // Set the border radius of the button
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(
                            10.0), // Set the margin around the button
                        child: Column(
                          children: [
                            Text(option),
                            const SizedBox(height: 15.0),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                  ],
                ),
              ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: isAnswered ? goToNextQuestion : null,
              child: const Text('Next Question'),
            ),
            const SizedBox(height: 16.0),
            if (isAnswered)
              Text(
                int.parse(selectedOption) == correctAnswer
                    ? 'You got it right!'
                    : 'Oops! The correct answer is: $correctAnswer',
                style: TextStyle(
                  color: int.parse(selectedOption) == correctAnswer
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: GNav(
        backgroundColor: Colors.black,
        color: Colors.white,
        activeColor: Colors.white,
        tabBackgroundColor: Colors.grey.shade700,
        gap: 8,
        padding: const EdgeInsets.all(16),
        tabs: _tabs,
        selectedIndex: _selectedIndex,
        onTabChange: _onItemTapped,
      ),
    );
  }
}
