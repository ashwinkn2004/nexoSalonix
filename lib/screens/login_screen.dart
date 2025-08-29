import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salonix/screens/fill_your_info_screen.dart';
import 'package:salonix/screens/home_screen.dart';
import 'package:salonix/screens/register_screen.dart';
import 'package:salonix/services/Authentication/auth_service.dart';
import 'package:salonix/social_buttons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';

// Riverpod provider for AuthService
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = 1.sh;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final blurHeight = statusBarHeight + 20.h;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F7),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: double.infinity,
              height: screenHeight * 0.4,
              child: Image.asset('assets/login.jpg', fit: BoxFit.cover),
            ),
          ),

          // Gradient overlay
          Container(
            width: double.infinity,
            height: screenHeight,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x0032373D),
                  Color(0xFF32373D),
                  Color(0xFF32373D),
                ],
                stops: [0.0, 0.40, 1.0],
              ),
            ),
          ),

          // Blur the top part
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: blurHeight,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(color: Colors.black.withOpacity(0.05)),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: screenHeight * 0.35,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Let's You In",
                          style: TextStyle(
                            color: const Color(0xFFF4B860),
                            fontWeight: FontWeight.w600,
                            fontSize: 32.sp,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        SocialButton(
                          asset: "assets/facebook.png",
                          text: "Continue With Facebook",
                          onTap: () async {
                            try {
                              final authService = ref.read(authServiceProvider);
                              final result = await authService
                                  .signInWithFacebook();
                              if (result == null) return; // User cancelled

                              final user = result['user'] as User;
                              final isNewUser = result['isNewUser'] as bool;

                              if (isNewUser) {
                                // Navigate to RegisterScreen for new users
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FillYourInfoScreen(
                                      email: user.email ?? '',
                                      //name: user.displayName ?? '',
                                    ),
                                  ),
                                );
                              } else {
                                // Navigate to home screen for existing users
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/home',
                                );
                              }
                            } on PlatformException catch (e) {
                              String errorMessage;
                              switch (e.code) {
                                case 'account-exists-with-different-credential':
                                  errorMessage =
                                      'Account exists with a different sign-in method. Try another method.';
                                  break;
                                case 'invalid-credential':
                                  errorMessage =
                                      'Invalid Facebook credentials. Please try again.';
                                  break;
                                default:
                                  errorMessage = 'Facebook Sign-In failed"}';
                              }
                              print('Facebook Sign-In error');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    errorMessage,
                                    style: TextStyle(
                                      color: const Color(0xFF32373D),
                                    ),
                                  ),
                                  backgroundColor: const Color(0xFFF4B860),
                                  duration: const Duration(seconds: 5),
                                ),
                              );
                            } catch (e) {
                              print('Unexpected Facebook Sign-In error');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Unexpected error',
                                    style: TextStyle(
                                      color: const Color(0xFF32373D),
                                    ),
                                  ),
                                  backgroundColor: const Color(0xFFF4B860),

                                  duration: const Duration(seconds: 5),
                                ),
                              );
                            }
                          },
                        ),
                        SizedBox(height: 8.h),
                        SocialButton(
                          asset: "assets/google.png",
                          text: "Continue With Google",
                          onTap: () async {
                            try {
                              final authService = ref.read(authServiceProvider);
                              final result = await authService
                                  .signInWithGoogle();

                              if (result == null) return; // User cancelled

                              // Handle error (e.g., existing email-password account)
                              if (result.containsKey('error')) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      result['error'],
                                      style: TextStyle(
                                        color: const Color(0xFF32373D),
                                      ),
                                    ),
                                    backgroundColor: const Color(0xFFF4B860),
                                  ),
                                );
                                return;
                              }

                              final user = result['user'] as User;
                              final isNewUser = result['isNewUser'] as bool;

                              if (isNewUser) {
                                /*Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FillYourInfoScreen(
                                      email: user.email ?? '',
                                    ),
                                  ),
                                );*/
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  ),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  ),
                                );
                              }
                            } on PlatformException catch (e) {
                              String errorMessage;
                              switch (e.code) {
                                case 'sign_in_failed':
                                  errorMessage =
                                      'Google Sign-In failed. Please try again.';
                                  break;
                                case 'network_error':
                                  errorMessage =
                                      'Network error. Please check your internet connection.';
                                  break;
                                default:
                                  errorMessage = 'Google Sign-In failed';
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    errorMessage,
                                    style: TextStyle(
                                      color: const Color(0xFF32373D),
                                    ),
                                  ),
                                  backgroundColor: const Color(0xFFF4B860),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'An error occurred during Google Sign-In',
                                    style: TextStyle(
                                      color: const Color(0xFF32373D),
                                    ),
                                  ),
                                  backgroundColor: const Color(0xFFF4B860),
                                ),
                              );
                            }
                          },
                        ),
                        SizedBox(height: 8.h),
                        SocialButton(
                          asset: "assets/apple.png",
                          text: "Continue With Apple",
                          onTap: () {},
                        ),
                        SizedBox(height: 32.h),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: const Color(0xFFF0F0F0BF),
                                thickness: 2,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Text(
                                "or",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: const Color(0xFFF0F0F0BF),
                                thickness: 2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 22.h),
                        SizedBox(
                          width: double.infinity,
                          height: 44.h,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "SIGN IN WITH PASSWORD",
                              style: TextStyle(
                                color: const Color(0xFF4A5859),
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 22.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't Have An Account? ",
                              style: TextStyle(
                                color: const Color(0xFFF4B860),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const FillYourInfoScreen(email: ""),
                                  ),
                                );
                              },
                              child: Text(
                                "Signup",
                                style: TextStyle(
                                  color: const Color(0xFFF4B860),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
