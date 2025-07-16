import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salonix/screens/register_screen.dart';
import 'package:salonix/social_buttons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = 1.sh;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final blurHeight =
        statusBarHeight + 20.h; // More than just status bar for visible blur

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F7),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background image
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: double.infinity,
              height: screenHeight * 0.4,
              child: Image.asset('assets/login.jpg', fit: BoxFit.cover),
            ),
          ),

          // 2. Gradient overlay
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

          // 3. BLUR the top part before SafeArea
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: blurHeight,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: Colors.black.withOpacity(0.05), // Optional dark tint
                ),
              ),
            ),
          ),

          // 4. SAFEAREA starts here
          SafeArea(
            child: Stack(
              children: [
                // Main content at 36% from top
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
                          onTap: () {},
                        ),
                        SizedBox(height: 8.h),
                        SocialButton(
                          asset: "assets/google.png",
                          text: "Continue With Google",
                          onTap: () {},
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
                                color: const Color(0XFFF0F0F0BF),
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
                                color: const Color(0XFFF0F0F0BF),
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
                              // TODO: Navigate to password screen
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
                                        const RegisterScreen(),
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
