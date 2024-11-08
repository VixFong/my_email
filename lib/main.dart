import 'package:flutter/material.dart';
import 'LoginPage/login_screen.dart';
import 'RegisterPage/register_screen.dart';
import 'EmailPage/email_page.dart';

void main() {
  runApp(EmailApp());
}

class EmailApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Email Service',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/email': (context) => EmailPage(), 
      },
    );
  }
}
