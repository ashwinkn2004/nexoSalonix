import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../widgets/bottom_nav_bar.dart';
import 'login_screen.dart'; // your login screen

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> logout(BuildContext context) async {
    final auth = FirebaseAuth.instance;
    final hiveBox = await Hive.openBox('userBox');

    await auth.signOut();
    await hiveBox.clear(); // remove all user data

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF32373D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF32373D),
        title: const Text("Profile"),
        elevation: 0,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => logout(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          child: const Text(
            "Logout",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2, // Profile index
        onTap: (int value) {
          switch (value) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/bookings');
              break;
            case 2:
              // Already on Profile
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}
