import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:math/pages/question.dart' as first;
import 'package:math/pages/discussion.dart' as second;
import 'package:math/pages/game.dart' as third;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    if (email != null) {
      setState(() {
        _email = email;
      });
    }
  }

  int _selectedIndex = 3;
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => first.QuestionPage()),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const second.DoubtPage()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const third.MathGamePage()),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  NetworkImage('https://picsum.photos/250?image=9'),
            ),
            SizedBox(height: 16),
            Text(
              'Email: $_email',
              style: TextStyle(fontSize: 18),
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
