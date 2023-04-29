import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:my_todo/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Todo App",
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            toolbarHeight: 150,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black),
      ),
      home: AnimatedSplashScreen(
        nextScreen: HomeScreen(),
        splash: Image.asset('assets/images/todo.png'),
        duration: 3000,
        backgroundColor: Colors.grey.shade900,
        splashIconSize: 250,
      ),
    );
  }
}
