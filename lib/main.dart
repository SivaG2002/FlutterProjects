// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'front.dart'; // Your starting screen
import 'landing.dart';
import 'login.dart';
import 'signup.dart';
import 'forgotpassword.dart';
import 'reset.dart';
import 'home.dart';
import 'women.dart';
import 'settings.dart';
import 'profile.dart';
import 'notify.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true, // Modern Material design
      ),
      initialRoute: '/front', // Start with Front screen
      routes: {
        '/front': (context) => const Front(),
        '/landing': (context) => const Landing(),
        '/login': (context) => const Login(),
        '/signup': (context) => const SignUp(),
        '/forgotpassword': (context) => const ForgotPassword(),
        '/reset': (context) => const ResetPassword(),
        '/home': (context) => const Home(),
        '/women': (context) => const Women(),
        '/settings': (context) => const Settings(),
        '/profile': (context) => const Profile(),
        '/notification': (context) => const Notifications(),
      },
    );
  }
}