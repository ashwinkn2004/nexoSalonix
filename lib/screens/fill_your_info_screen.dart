import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:salonix/screens/home_screen.dart';

final profileFormProvider =
    StateNotifierProvider<ProfileFormNotifier, ProfileFormState>((ref) {
      return ProfileFormNotifier();
    });

class ProfileFormState {
  final String name;
  final String email;
  final String dob;
  final String city;
  final String phone;
  final String gender;

  ProfileFormState({
    this.name = '',
    this.email = '',
    this.dob = '',
    this.city = '',
    this.phone = '',
    this.gender = '',
  });

  ProfileFormState copyWith({
    String? name,
    String? email,
    String? dob,
    String? city,
    String? phone,
    String? gender,
  }) => ProfileFormState(
    name: name ?? this.name,
    email: email ?? this.email,
    dob: dob ?? this.dob,
    city: city ?? this.city,
    phone: phone ?? this.phone,
    gender: gender ?? this.gender,
  );
}

class ProfileFormNotifier extends StateNotifier<ProfileFormState> {
  ProfileFormNotifier() : super(ProfileFormState());

  void update({
    String? name,
    String? email,
    String? dob,
    String? city,
    String? phone,
    String? gender,
  }) {
    state = state.copyWith(
      name: name,
      email: email,
      dob: dob,
      city: city,
      phone: phone,
      gender: gender,
    );
  }
}

class FillYourInfoScreen extends ConsumerWidget {
  const FillYourInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = 1.sh;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final avatarSize = 100.w;
    final form = ref.watch(profileFormProvider);
    final notifier = ref.read(profileFormProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF32373D),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: statusBarHeight,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            color: const Color(0xFF4A5859),
                            size: 40.sp,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "Fill Your Profile",
                              style: TextStyle(
                                color: const Color(0xFFF4B760),
                                fontWeight: FontWeight.w600,
                                fontSize: 24.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 42.w),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.022),
                    Stack(
                      children: [
                        Container(
                          width: avatarSize,
                          height: avatarSize,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A5859),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.white54,
                            size: 44.sp,
                          ),
                        ),
                        Positioned(
                          bottom: 6,
                          right: 6,
                          child: Container(
                            width: 28.w,
                            height: 28.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFF82A0A2),
                              borderRadius: BorderRadius.circular(7.w),
                            ),
                            child: Icon(
                              Icons.edit,
                              color: const Color(0xFF4A5859),
                              size: 25.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.038),

                    _ProfileInputField(
                      hint: 'Name',
                      controllerValue: form.name,
                      onChanged: (val) => notifier.update(name: val),
                    ),
                    SizedBox(height: 16.h),

                    _ProfileInputField(
                      hint: 'Email',
                      controllerValue: form.email,
                      onChanged: (val) => notifier.update(email: val),
                      keyboardType: TextInputType.emailAddress,
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
                      onChanged: (val) => notifier.update(city: val),
                      trailingImage: 'assets/location.png',
                    ),

                    SizedBox(height: 16.h),

                    _ProfileInputField(
                      hint: 'Phone Number',
                      controllerValue: form.phone,
                      keyboardType: TextInputType.phone,
                      onChanged: (val) => notifier.update(phone: val),
                    ),
                    SizedBox(height: 16.h),

                    _ProfileInputField(
                      hint: 'Gender',
                      controllerValue: form.gender,
                      readOnly: true,
                      trailingIcon: Icons.keyboard_arrow_down_rounded,
                      onTap: () async {
                        final selected = await showModalBottomSheet<String>(
                          context: context,
                          backgroundColor: const Color(0xFF32373D),
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
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () => Navigator.pop(ctx, 'Male'),
                              ),
                              ListTile(
                                title: const Text(
                                  'Female',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () => Navigator.pop(ctx, 'Female'),
                              ),
                              ListTile(
                                title: const Text(
                                  'Other',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () => Navigator.pop(ctx, 'Other'),
                              ),
                            ],
                          ),
                        );
                        if (selected != null) notifier.update(gender: selected);
                      },
                    ),
                    SizedBox(height: 38.h),

                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFF4B860),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HomeScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "GET START",
                          style: TextStyle(
                            color: const Color(0xFF4A5859),
                            fontWeight: FontWeight.w600,
                            fontSize: 17.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 18.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInputField extends StatefulWidget {
  final String hint;
  final String controllerValue;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final IconData? trailingIcon;
  final String? trailingImage;
  final TextInputType? keyboardType;

  const _ProfileInputField({
    required this.hint,
    required this.controllerValue,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.trailingIcon,
    this.trailingImage,
    this.keyboardType,
  });

  @override
  State<_ProfileInputField> createState() => _ProfileInputFieldState();
}

class _ProfileInputFieldState extends State<_ProfileInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.controllerValue);
  }

  @override
  void didUpdateWidget(covariant _ProfileInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controllerValue != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.controllerValue,
        selection: TextSelection.collapsed(
          offset: widget.controllerValue.length,
        ),
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
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.93),
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.hint,
                    hintStyle: TextStyle(
                      color: Colors.white60,
                      fontWeight: FontWeight.w400,
                      fontSize: 15.sp,
                    ),
                    isDense: true,
                  ),
                  readOnly: widget.readOnly,
                  onChanged: widget.onChanged,
                  keyboardType: widget.keyboardType,
                  cursorColor: const Color(0xFFF4B860),
                ),
              ),
              if (widget.trailingImage != null)
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
                  size: 21.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
