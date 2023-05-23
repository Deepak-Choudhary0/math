import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:math/pages/question.dart' as first;
import 'package:math/pages/game.dart' as third;
import 'package:math/pages/profile.dart' as fourth;
import 'package:math/pages/chatgpt.dart';

class DoubtPage extends StatefulWidget {
  const DoubtPage({super.key});
  @override
  _DoubtPageState createState() => _DoubtPageState();
}

class _DoubtPageState extends State<DoubtPage> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _replyController = TextEditingController();
  final List<Map<String, String>> _doubts = [];

  int _selectedIndex = 1;
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
        if (index == 0) {
          // Navigate to the home page.
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => first.QuestionPage()),
          );
        } else if (index == 1) {
          // Navigate to the settings page.
        } else if (index == 2) {
          // Navigate to the settings page.
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => third.MathGamePage()),
          );
        } else if (index == 3) {
          // Navigate to the settings page.
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 40.0,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _questionController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(16.0),
                          labelText: 'Ask your question',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a question';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _replyController.text =
                                await getResponse(_questionController.text);
                            setState(() {
                              _doubts.add({
                                'question': _questionController.text,
                                'reply': _replyController.text,
                              });
                              _questionController.clear();
                              _replyController.clear();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Question submitted')),
                            );
                          }
                        },
                        child: const Text("Submit"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                if (_doubts.isEmpty)
                  const Text(
                    'No doubts yet. Ask a question to get started!',
                    textAlign: TextAlign.center,
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var doubt in _doubts)
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  doubt['question'].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(doubt['reply'].toString()),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
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
