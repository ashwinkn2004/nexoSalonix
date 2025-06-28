import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salonix/consts.dart';
import 'package:salonix/screens/welcome_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1200),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const WelcomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final slideOut =
                Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(0.0, -1.0),
                ).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                );

            return Stack(
              children: [
                child,
                SlideTransition(
                  position: slideOut,
                  child: buildSplashContent(context),
                ),
              ],
            );
          },
        ),
      );
    });
  }

  Widget buildSplashContent(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4B860),
      body: SafeArea(
        child: Center(
          child: Text(
            'salonix',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              fontSize: Responsive.screenHeight(context) * 0.06,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildSplashContent(context); // Initial UI
  }
}
