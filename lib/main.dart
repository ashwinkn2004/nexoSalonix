import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salonix/screens/splash_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // Set to your design's reference size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // Use .sp, .w, .h INSIDE the builder so ScreenUtil is initialized
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
              fontSize: 32.sp, // Use .sp, .w, .h here
              fontWeight: FontWeight.w700,
              color: const Color(0xFF32373D),
            ),
            titleMedium: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFF4B860),
            ),
            bodyMedium: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF112D4E),
            ),
            labelSmall: TextStyle(fontSize: 12.sp),
          ),
        );
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: const SplashScreen(),
        );
      },
    );
  }
}
