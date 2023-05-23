import 'package:flutter/material.dart';
import 'package:math/pages/signup.dart' as first;
import 'package:math/pages/question.dart' as second;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
  // _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";

  void validateAndSave() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form is invalid')),
      );
    }
    _formKey.currentState!.save();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email,
          //"123@gmail.com", // email: _emailController.toString(),
          password: _password,
          //"123456", // password: _passwordController.toString());
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', _email);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Success')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => second.QuestionPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(
              height: 150.0,
            ),
            // input field for email
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) =>
                  value!.isEmpty ? 'Email cannot be blank' : null,
              onSaved: (value) {
                _email = value.toString();
              },
            ),
            // input field for password
            TextFormField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) =>
                  value!.isEmpty ? 'Password cannot be blank' : null,
              onSaved: (value) => _password = value.toString(),
            ),
            ElevatedButton(
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () async {
                validateAndSave();
                await _handleLogin();
                print(_email);
                print(_password);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: const Text(
                'SignUp',
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const first.RegistrationPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
