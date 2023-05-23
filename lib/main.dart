import 'package:flutter/material.dart';
import 'package:math/pages/onboared.dart' as first;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// for inserting data for myself purpose only
// import 'package:math/pages/insertion.dart' as second;
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(
    fileName: '.env',
  );
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MathMagic(),
    ),
  );
}

class MathMagic extends StatefulWidget {
  const MathMagic({super.key});

  @override
  _MathMagic createState() => _MathMagic();
}

class _MathMagic extends State<MathMagic> {
  bool _termsAndConditions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Math App'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2UXOm64ZMBelxMHItj0AI3XPjf9Ee8TkVXKd0Sazo1Q&ec=48665701',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome to Math App!',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Learn math in a fun and interactive way!',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CheckboxListTile(
              title: const Text(
                  'I agree to the terms and conditions of MathMagic'),
              value: _termsAndConditions,
              onChanged: (value) {
                setState(() {
                  _termsAndConditions = true;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_termsAndConditions == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const first.LoginPage(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Agree to the terms!')),
                  );
                }
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
