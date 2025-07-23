import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salonix/screens/register_screen.dart';
import 'package:salonix/services/Authentication/auth_service.dart';
import 'package:lucide_icons/lucide_icons.dart';

// State provider for profile form
final profileFormProvider =
    StateNotifierProvider<ProfileFormNotifier, ProfileFormState>((ref) {
      return ProfileFormNotifier();
    });

class ProfileFormState {
  final String name;
  final String email;
  final String password;
  final String dob;
  final String city;
  final String phone;
  final String gender;
  final bool isLoading;

  ProfileFormState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.dob = '',
    this.city = '',
    this.phone = '',
    this.gender = '',
    this.isLoading = false,
  });

  ProfileFormState copyWith({
    String? name,
    String? email,
    String? password,
    String? dob,
    String? city,
    String? phone,
    String? gender,
    bool? isLoading,
  }) => ProfileFormState(
    name: name ?? this.name,
    email: email ?? this.email,
    password: password ?? this.password,
    dob: dob ?? this.dob,
    city: city ?? this.city,
    phone: phone ?? this.phone,
    gender: gender ?? this.gender,
    isLoading: isLoading ?? this.isLoading,
  );
}

class ProfileFormNotifier extends StateNotifier<ProfileFormState> {
  ProfileFormNotifier() : super(ProfileFormState());

  void update({
    String? name,
    String? email,
    String? password,
    String? dob,
    String? city,
    String? phone,
    String? gender,
    bool? isLoading,
  }) {
    // Only update if values have changed to avoid unnecessary state updates
    if (name != state.name ||
        email != state.email ||
        password != state.password ||
        dob != state.dob ||
        city != state.city ||
        phone != state.phone ||
        gender != state.gender ||
        isLoading != state.isLoading) {
      state = state.copyWith(
        name: name,
        email: email,
        password: password,
        dob: dob,
        city: city,
        phone: phone,
        gender: gender,
        isLoading: isLoading,
      );
    }
  }
}

class FillYourInfoScreen extends ConsumerStatefulWidget {
  final String email;
  const FillYourInfoScreen({super.key, required this.email});

  @override
  ConsumerState<FillYourInfoScreen> createState() => _FillYourInfoScreenState();
}

class _FillYourInfoScreenState extends ConsumerState<FillYourInfoScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize email in state directly
    if (widget.email.isNotEmpty) {
      ref.read(profileFormProvider.notifier).update(email: widget.email);
    }
  }

  Future<void> _submitProfile(
    BuildContext context,
    ProfileFormState form,
    WidgetRef ref,
  ) async {
    final notifier = ref.read(profileFormProvider.notifier);

    // Validation
    if (form.name.trim().isEmpty ||
        form.email.trim().isEmpty ||
        form.password.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill all required fields (Name, Email, Password)",
          ),
          backgroundColor: const Color(0xFFF4B860),
        ),
      );
      return;
    }

    notifier.update(isLoading: true);

    try {
      final authService = AuthService();
      final user = await authService.registerWithEmail(
        form.email.trim(),
        form.password.trim(),
      );

      if (user == null) {
        throw Exception("Failed to create user account");
      }

      // Update Firebase Auth display name
      await user.updateDisplayName(form.name.trim());
      await user.reload();

      // Prepare user profile data
      final profileData = {
        'name': form.name.trim(),
        'email': form.email.trim(),
        'dob': form.dob.trim().isNotEmpty ? form.dob.trim() : null,
        'city': form.city.trim().isNotEmpty ? form.city.trim() : null,
        'phone': form.phone.trim().isNotEmpty ? form.phone.trim() : null,
        'gender': form.gender.trim().isNotEmpty ? form.gender.trim() : null,
        'uid': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Create user profile in Firestore
      await authService.updateUserProfile(profileData);

      notifier.update(isLoading: false);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile created successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to RegisterScreen after a short delay
      await Future.delayed(const Duration(milliseconds: 500));
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RegisterScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      notifier.update(isLoading: false);
      final errorMessage = switch (e.code) {
        'email-already-in-use' => "An account with this email already exists",
        'weak-password' => "Password is too weak",
        'invalid-email' => "Invalid email address",
        'network-request-failed' =>
          "Network error. Please check your connection",
        _ => e.message ?? "Authentication failed",
      };

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor:const Color(0xFFF4B860)),
        );
      }
    } catch (e) {
      notifier.update(isLoading: false);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to create profile"),
            backgroundColor: const Color(0xFFF4B860),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = 1.sh;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final avatarSize = 100.w;

    return Scaffold(
      backgroundColor: const Color(0xFF32373D),
      body: Stack(
        children: [
          // Simplified status bar without BackdropFilter for better performance
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: statusBarHeight,
            child: Container(color: const Color(0xFF32373D)),
          ),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 28.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back_rounded,
                                color: Color(0xFF4A5859),
                                size: 40,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Expanded(
                              child: Center(
                                child: Text(
                                  "Fill Your Profile",
                                  style: TextStyle(
                                    color: Color(0xFFF4B760),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 42.w),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.022),
                        const _AvatarWidget(),
                        SizedBox(height: screenHeight * 0.038),
                        // Use Consumer only for form fields to limit rebuilds
                        Consumer(
                          builder: (context, ref, child) {
                            final form = ref.watch(profileFormProvider);
                            final notifier = ref.read(
                              profileFormProvider.notifier,
                            );
                            return Column(
                              children: [
                                _ProfileInputField(
                                  hint: 'Name*',
                                  controllerValue: form.name,
                                  onChanged: (val) =>
                                      notifier.update(name: val),
                                ),
                                SizedBox(height: 16.h),
                                _ProfileInputField(
                                  hint: 'Email*',
                                  controllerValue: form.email,
                                  onChanged: (val) =>
                                      notifier.update(email: val),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                SizedBox(height: 16.h),
                                _ProfileInputField(
                                  hint: 'Password*',
                                  controllerValue: form.password,
                                  onChanged: (val) =>
                                      notifier.update(password: val),
                                  isPassword: true,
                                ),
                                SizedBox(height: 16.h),
                                _ProfileInputField(
                                  hint: 'Date Of Birth',
                                  controllerValue: form.dob,
                                  readOnly: true,
                                  trailingImage: 'assets/calander.png',
                                  onTap: () async {
                                    final now = DateTime.now();
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: now,
                                      firstDate: DateTime(now.year - 100),
                                      lastDate: now,
                                      builder: (context, child) => Theme(
                                        data: ThemeData.dark().copyWith(
                                          colorScheme: const ColorScheme.dark(
                                            primary: Color(0xFFF4B860),
                                            surface: Color(0xFF32373D),
                                          ),
                                        ),
                                        child: child!,
                                      ),
                                    );
                                    if (picked != null) {
                                      notifier.update(
                                        dob:
                                            "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}",
                                      );
                                    }
                                  },
                                ),
                                SizedBox(height: 16.h),
                                _ProfileInputField(
                                  hint: 'City',
                                  controllerValue: form.city,
                                  onChanged: (val) =>
                                      notifier.update(city: val),
                                  trailingImage: 'assets/location.png',
                                ),
                                SizedBox(height: 16.h),
                                _ProfileInputField(
                                  hint: 'Phone Number',
                                  controllerValue: form.phone,
                                  keyboardType: TextInputType.phone,
                                  onChanged: (val) =>
                                      notifier.update(phone: val),
                                ),
                                SizedBox(height: 16.h),
                                _ProfileInputField(
                                  hint: 'Gender',
                                  controllerValue: form.gender,
                                  readOnly: true,
                                  trailingIcon:
                                      Icons.keyboard_arrow_down_rounded,
                                  onTap: () async {
                                    final selected =
                                        await showModalBottomSheet<String>(
                                          context: context,
                                          backgroundColor: const Color(
                                            0xFF32373D,
                                          ),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(18),
                                            ),
                                          ),
                                          builder: (ctx) => Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                title: const Text(
                                                  'Male',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                onTap: () =>
                                                    Navigator.pop(ctx, 'Male'),
                                              ),
                                              ListTile(
                                                title: const Text(
                                                  'Female',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                onTap: () => Navigator.pop(
                                                  ctx,
                                                  'Female',
                                                ),
                                              ),
                                              ListTile(
                                                title: const Text(
                                                  'Other',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                onTap: () =>
                                                    Navigator.pop(ctx, 'Other'),
                                              ),
                                            ],
                                          ),
                                        );
                                    if (selected != null)
                                      notifier.update(gender: selected);
                                  },
                                ),
                                SizedBox(height: 38.h),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50.h,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: form.isLoading
                                          ? const Color(
                                              0xFFF4B860,
                                            ).withOpacity(0.6)
                                          : const Color(0xFFF4B860),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(28),
                                      ),
                                    ),
                                    onPressed: form.isLoading
                                        ? null
                                        : () => _submitProfile(
                                            context,
                                            form,
                                            ref,
                                          ),
                                    child: form.isLoading
                                        ? SizedBox(
                                            width: 20.w,
                                            height: 20.w,
                                            child:
                                                const CircularProgressIndicator(
                                                  color: Color(0xFF4A5859),
                                                  strokeWidth: 2,
                                                ),
                                          )
                                        : const Text(
                                            "GET START",
                                            style: TextStyle(
                                              color: Color(0xFF4A5859),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                            ),
                                          ),
                                  ),
                                ),
                                SizedBox(height: 18.h),
                              ],
                            );
                          },
                        ),
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

class _AvatarWidget extends StatelessWidget {
  const _AvatarWidget();

  @override
  Widget build(BuildContext context) {
    final avatarSize = 100.w;
    return Stack(
      children: [
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: const BoxDecoration(
            color: Color(0xFF4A5859),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person, color: Colors.white54, size: 44),
        ),
        Positioned(
          bottom: 6,
          right: 6,
          child: Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              color: const Color(0xFF82A0A2),
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Icon(Icons.edit, color: Color(0xFF4A5859), size: 25),
          ),
        ),
      ],
    );
  }
}

class _ProfileInputField extends ConsumerStatefulWidget {
  final String hint;
  final String controllerValue;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final IconData? trailingIcon;
  final String? trailingImage;
  final TextInputType? keyboardType;
  final bool isPassword;

  const _ProfileInputField({
    required this.hint,
    required this.controllerValue,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.trailingIcon,
    this.trailingImage,
    this.keyboardType,
    this.isPassword = false,
  });

  @override
  ConsumerState<_ProfileInputField> createState() => _ProfileInputFieldState();
}

class _ProfileInputFieldState extends ConsumerState<_ProfileInputField> {
  late final TextEditingController _controller;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.controllerValue);
    _obscureText = widget.isPassword;
  }

  @override
  void didUpdateWidget(covariant _ProfileInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controllerValue != _controller.text) {
      _controller.text = widget.controllerValue;
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.readOnly && widget.onTap != null ? widget.onTap : null,
      child: AbsorbPointer(
        absorbing: widget.readOnly && widget.onTap != null,
        child: Container(
          width: double.infinity,
          height: 50.h,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: const Color(0xFF4A5859),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Row(
            children: [
              SizedBox(width: 15.w),
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.hint,
                    hintStyle: const TextStyle(
                      color: Colors.white60,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                    isDense: true,
                  ),
                  readOnly: widget.readOnly,
                  onChanged: widget.onChanged,
                  keyboardType: widget.keyboardType,
                  cursorColor: const Color(0xFFF4B860),
                  obscureText: widget.isPassword && _obscureText,
                ),
              ),
              if (widget.isPassword)
                IconButton(
                  icon: Icon(
                    _obscureText ? LucideIcons.eyeOff : LucideIcons.eye,
                    color: Colors.white70,
                    size: 21,
                  ),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                )
              else if (widget.trailingImage != null)
                Image.asset(
                  widget.trailingImage!,
                  width: 20.w,
                  height: 20.w,
                  color: Colors.white70,
                )
              else if (widget.trailingIcon != null)
                Icon(
                  widget.trailingIcon,
                  color: widget.hint == 'City'
                      ? const Color(0xFFF0F0F0)
                      : Colors.white70,
                  size: 21,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
