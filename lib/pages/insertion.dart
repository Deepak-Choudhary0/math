import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddQuestionPage extends StatefulWidget {
  const AddQuestionPage({super.key});

  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _option1Controller = TextEditingController();
  final TextEditingController _option2Controller = TextEditingController();
  final TextEditingController _option3Controller = TextEditingController();
  final TextEditingController _option4Controller = TextEditingController();
  final TextEditingController _correctAnswerController =
      TextEditingController();

  Future<void> _addQuestion() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference questionsRef = firestore.collection('questions');

    final Map<String, dynamic> questionData = {
      'question': _questionController.text,
      'options': [
        _option1Controller.text,
        _option2Controller.text,
        _option3Controller.text,
        _option4Controller.text,
      ],
      'correctAnswer': _correctAnswerController.text,
    };

    await questionsRef.add(questionData);

    _questionController.clear();
    _option1Controller.clear();
    _option2Controller.clear();
    _option3Controller.clear();
    _option4Controller.clear();
    _correctAnswerController.clear();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Question Added'),
        content: const Text('The question has been added to Firestore.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _option1Controller,
              decoration: const InputDecoration(labelText: 'Option 1'),
            ),
            TextField(
              controller: _option2Controller,
              decoration: const InputDecoration(labelText: 'Option 2'),
            ),
            TextField(
              controller: _option3Controller,
              decoration: const InputDecoration(labelText: 'Option 3'),
            ),
            TextField(
              controller: _option4Controller,
              decoration: const InputDecoration(labelText: 'Option 4'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _correctAnswerController,
              decoration: const InputDecoration(labelText: 'Correct Answer'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addQuestion,
              child: const Text('Add Question'),
            ),
          ],
        ),
      ),
    );
  }
}
