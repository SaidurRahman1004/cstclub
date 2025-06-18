import 'package:cstclub/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    final textTheme = GoogleFonts.latoTextTheme(Theme.of(context).textTheme);

    
    final lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: Colors.blue, 
      textTheme: textTheme,
      scaffoldBackgroundColor: Colors.grey[50], 
    );

    
    final darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: Colors.blue, 
      textTheme: textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212), 
    );

    return MaterialApp(
      title: 'CST Club DPI',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system, 
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
    );
  }
}