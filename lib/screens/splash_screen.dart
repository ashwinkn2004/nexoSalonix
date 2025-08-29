import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    if (user == null) {
      // No Firebase user exists — clear Hive and go to WelcomeScreen with animation
      await ref.read(authProvider.notifier).logout();
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
      return;
    }

    // User exists in Firebase — check if UID is still valid
    try {
      await user.getIdToken(true); // Throws if account is deleted
      if (!mounted) return;
      // Update Hive to reflect logged-in state
      await ref.read(authProvider.notifier).login(user.uid);
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (e) {
      // UID is no longer valid — clear Hive and go to WelcomeScreen with animation
      print('User validation error: $e');
      await ref.read(authProvider.notifier).logout();
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
    }
  }

  Widget buildSplashContent(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4B860),
      body: SafeArea(
        child: Center(
          child: Text(
            'salonix',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              fontSize: MediaQuery.of(context).size.height * 0.06,
              fontStyle: FontStyle.italic,
              color: const Color(0xFF32373D),
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
