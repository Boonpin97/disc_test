import 'package:flutter/material.dart';
import 'screens/intro_screen.dart';

void main() {
  runApp(const DiscTestApp());
}

class DiscTestApp extends StatelessWidget {
  const DiscTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DISC Personality Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const IntroScreen(),
    );
  }
}
