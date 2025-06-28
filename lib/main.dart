import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salonix/screens/splash_screen.dart';
import 'package:salonix/consts.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: const Color(0xFFF9F7F7),
      primaryColor: const Color(0xFF3F72AF),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF3F72AF),
        background: const Color(0xFFF9F7F7),
      ),
      textTheme: TextTheme(
        headlineSmall: TextStyle(
          fontSize: Responsive.fontSize(context, 0.18),
          fontWeight: FontWeight.w700,
          color: Color(0xFF32373D),
        ),
        titleMedium: TextStyle(
          fontSize: Responsive.fontSize(context, 0.08),
          fontWeight: FontWeight.w600,
          color: const Color(0xFFF4B860),
        ),
        bodyMedium: TextStyle(
          fontSize: Responsive.fontSize(context, 0.10),
          color: const Color(0xFF112D4E),
        ),
        labelSmall: TextStyle(fontSize: Responsive.fontSize(context, 0.073)),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const SplashScreen(),
    );
  }
}
