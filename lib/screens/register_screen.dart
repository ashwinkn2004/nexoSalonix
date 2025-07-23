import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:salonix/consts.dart';
import 'package:salonix/provider/register_form_provider.dart';
import 'package:salonix/register_input.dart';
import 'package:salonix/screens/fill_your_info_screen.dart';
import 'package:salonix/screens/home_screen.dart';
import 'package:salonix/services/Authentication/auth_service.dart';
import 'package:salonix/social_icon.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool rememberMe = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    setState(() => isLoading = true);
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
        return;
      }

      final result = await AuthService().handleSignIn(email, password);

      if (result['success'] == true && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['error'] ?? 'Login failed')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _handleSocialLogin(String provider) async {
    setState(() => isLoading = true);
    try {
      Map<String, dynamic>? result;

      if (provider == 'google') {
        result = await AuthService().signInWithGoogle();
      } else if (provider == 'facebook') {
        result = await AuthService().signInWithFacebook();
      }

      if (result != null && mounted) {
        // Check if it's a new user (optional)
        final isNewUser = result['isNewUser'] ?? false;

        // Navigate to HomeScreen after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Facebook login failed')),
          
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = 1.sh;
    final state = ref.watch(registerFormProvider);
    final notifier = ref.read(registerFormProvider.notifier);
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final blurHeight = statusBarHeight + 20.h;

    return Scaffold(
      backgroundColor: const Color(0xFF32373D),
      body: Stack(
        children: [
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
          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 16.h,
                  left: 16.w,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: const Color(0xFF4A5859),
                      size: 40.sp,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 38.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.096),
                        SizedBox(
                          width: 269.w,
                          height: 96.h,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Login \nto Salonix',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: const Color(0xFFF4B860),
                                fontWeight: FontWeight.w600,
                                fontSize: 60.sp,
                                height: 1.7,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.07),

                        // Email input
                        RegisterInput(
                          icon: Icons.email_outlined,
                          hint: 'Email',
                          obscureText: false,
                          editingController: emailController,
                        ),
                        SizedBox(height: screenHeight * 0.015),

                        // Password input
                        RegisterInput(
                          icon: Icons.lock_outline_rounded,
                          hint: 'Password',
                          obscureText: !state.showPassword1,
                          editingController: passwordController,
                          suffixIcon: IconButton(
                            icon: Icon(
                              state.showPassword1
                                  ? LucideIcons.eyeOff
                                  : LucideIcons.eye,
                              color: Colors.black,
                              size: 20.sp,
                            ),
                            onPressed: notifier.toggleShowPassword1,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.025),

                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: Checkbox(
                                  value: rememberMe,
                                  onChanged: (val) {
                                    setState(() {
                                      rememberMe = val ?? false;
                                    });
                                  },
                                  side: const BorderSide(
                                    color: Color(0xFF4A5859),
                                    width: 1.3,
                                  ),
                                  activeColor: const Color(0xFFF4B860),
                                  checkColor: const Color(0xFF4A5859),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              SizedBox(
                                width: 128.w,
                                height: 21.h,
                                child: Text(
                                  'Remember me',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                    color: const Color(0xFF4A5859),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.035),

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
                            onPressed: isLoading ? null : _handleSignIn,
                            child: Text(
                              "SIGN IN",
                              style: TextStyle(
                                color: const Color(0xFF4A5859),
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.1),

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
                        SizedBox(height: 35.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SocialIcon(
                              asset: "assets/facebook.png",
                              onTap: () => _handleSocialLogin('facebook'),
                            ),
                            SizedBox(width: 18.w),
                            SocialIcon(
                              asset: "assets/google.png",
                              onTap: () => _handleSocialLogin('google'),
                            ),
                            SizedBox(width: 18.w),
                            SocialIcon(
                              asset: "assets/apple.png",
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Apple login coming soon'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 36.h),

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
                        SizedBox(height: 26.h),
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
