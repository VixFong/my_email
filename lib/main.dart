import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'LoginPage/login_screen.dart';
import 'RegisterPage/register_screen.dart';
import 'EmailPage/email_page.dart';
import 'SettingPage/setting_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeFont = themeProvider.selectedFont;

    return MaterialApp(
      title: 'Email Service',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness:
            themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
        textTheme: themeProvider.getTextTheme(),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/email': (context) => EmailPage(
              folder: 'Inbox',
            ),
        '/settings': (context) => SettingsPage(onProfileImageChanged: (String ) {  },),
      },
    );
  }
}
