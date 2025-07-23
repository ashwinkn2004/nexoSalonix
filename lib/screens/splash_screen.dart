import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salonix/consts.dart';
import 'package:salonix/provider/auth_provider.dart';
import 'package:salonix/screens/welcome_screen.dart';
import 'package:salonix/screens/home_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;

    Navigator.of(context).pushReplacement(
      user != null
          ? MaterialPageRoute(builder: (_) => const HomeScreen())
          : PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 1200),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const WelcomeScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    final slideOut =
                        Tween<Offset>(
                          begin: Offset.zero,
                          end: const Offset(0.0, -1.0),
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          ),
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
              color: Color(0xFF32373D),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildSplashContent(context);
  }
}
