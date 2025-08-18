import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quickzingo/pages/landing_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quickzingo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        useMaterial3: true,
        // Input decoration theme for text fields
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(
            color: Colors.black87, // Black placeholder text
          ),
          labelStyle: TextStyle(
            color: Colors.black87, // Black label text
          ),
          floatingLabelStyle: TextStyle(
            color: Colors.black87, // Black floating label when focused
          ),
        
        ),
        // Text selection theme for cursor and selection
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black87, // Black cursor
          selectionColor: Colors.black26, // Selection highlight color
          selectionHandleColor: Colors.black87, // Selection handle color
        ),
        // Text theme for general text styling
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      home: const LandingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}