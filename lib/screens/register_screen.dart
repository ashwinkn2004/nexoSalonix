import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salonix/provider/register_form_provider.dart';
import 'package:salonix/register_input.dart';
import 'package:salonix/screens/fill_your_info_screen.dart';
import 'package:salonix/social_icon.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = 1.sh;
    final state = ref.watch(registerFormProvider);
    final notifier = ref.read(registerFormProvider.notifier);

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF32373D),
        body: Stack(
          children: [
            // Back arrow
            Positioned(
              top: 16.h,
              left: 16.w,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFF4A5859),
                  size: 40.sp,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            // Main Content
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 38.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.096),
                    // Responsive Title with FittedBox
                    SizedBox(
                      width: 269.w,
                      height: 96.h,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Create Your\nAccount',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: const Color(0xFFF4B860),
                            fontWeight: FontWeight.w600,
                            fontSize: 60.sp, // Large for FittedBox, scales down
                            height: 1.7,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.07),

                    // Email
                    RegisterInput(
                      icon: Icons.email_outlined,
                      hint: 'Email',
                      obscureText: false,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    // Password
                    RegisterInput(
                      icon: Icons.lock_outline_rounded,
                      hint: 'Password',
                      obscureText: !state.showPassword1,
                      suffixIcon: IconButton(
                        icon: Icon(
                          state.showPassword1
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white70,
                          size: 20.sp,
                        ),
                        onPressed: notifier.toggleShowPassword1,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    // Confirm Password
                    RegisterInput(
                      icon: Icons.lock_outline_rounded,
                      hint: 'Password',
                      obscureText: !state.showPassword2,
                      suffixIcon: IconButton(
                        icon: Icon(
                          state.showPassword2
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white70,
                          size: 20.sp,
                        ),
                        onPressed: notifier.toggleShowPassword2,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.07),
                    // Sign Up Button
                    SizedBox(
                      width: 315.w,
                      height: 45.h,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFF4B860),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        onPressed: () {

                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => const FillYourInfoScreen()));

                        },
                        child: Text(
                          "SIGN UP",
                          style: TextStyle(
                            color: const Color(0xFF4A5859),
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // Divider with "or continue with"
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.white.withOpacity(0.45),
                            thickness: 1.2,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text(
                            "or continue with",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w600,
                              fontSize: 20.sp,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.white.withOpacity(0.45),
                            thickness: 1.2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 22.h),
                    // Social Icon Buttons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialIcon(asset: "assets/facebook.png", onTap: () {}),
                        SizedBox(width: 18.w),
                        SocialIcon(asset: "assets/google.png", onTap: () {}),
                        SizedBox(width: 18.w),
                        SocialIcon(asset: "assets/apple.png", onTap: () {}),
                      ],
                    ),
                    SizedBox(height: 36.h),
                    // Bottom Signup Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already Have An Account? ",
                          style: TextStyle(
                            color: const Color(0xFFF4B860),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            "Signin",
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
                    SizedBox(height: 26.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
