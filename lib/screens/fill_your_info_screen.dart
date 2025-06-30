import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FillYourInfoScreen extends ConsumerWidget {
  const FillYourInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = 1.sh;
    final avatarSize = 86.w;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF32373D),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.046),
                // Back arrow + Title Row
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
                    SizedBox(width: 42.w), // To balance arrow offset
                  ],
                ),
                SizedBox(height: screenHeight * 0.022),

                // Avatar with edit button
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
                          color: const Color(0xFFF4B860),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit,
                          color: const Color(0xFF4A5859),
                          size: 18.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.038),

                // --- FORM FIELDS ---
                _ProfileInputField(hint: 'Name', icon: Icons.person_outline),
                SizedBox(height: 16.h),
                _ProfileInputField(hint: 'Email', icon: Icons.email_outlined),
                SizedBox(height: 16.h),
                _ProfileInputField(
                  hint: 'Date Of Birth',
                  icon: LucideIcons.calendar,
                  trailing: true,
                  onTap: () {
                    // TODO: Open date picker
                  },
                ),
                SizedBox(height: 16.h),
                _ProfileInputField(
                  hint: 'City',
                  icon: Icons.location_on_outlined,
                  trailing: true,
                  onTap: () {
                    // TODO: Open city picker (if needed)
                  },
                ),
                SizedBox(height: 16.h),
                _ProfileInputField(
                  hint: 'Phone Number',
                  icon: Icons.phone_android_rounded,
                ),
                SizedBox(height: 16.h),
                _ProfileInputField(
                  hint: 'Gender',
                  icon: Icons.keyboard_arrow_down_rounded,
                  isDropdown: true,
                  onTap: () {
                    // TODO: Open gender select
                  },
                ),
                SizedBox(height: 38.h),

                // --- GET START Button ---
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
                    onPressed: () {},
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
    );
  }
}

// --- Profile Input Field Widget ---
class _ProfileInputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool isDropdown;
  final bool trailing;
  final VoidCallback? onTap;

  const _ProfileInputField({
    required this.hint,
    required this.icon,
    this.isDropdown = false,
    this.trailing = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // For dropdown/date, open selector
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
            Icon(icon, color: Colors.white70, size: 20.sp),
            SizedBox(width: 15.w),
            Expanded(
              child: Text(
                hint,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.93),
                  fontWeight: FontWeight.w500,
                  fontSize: 15.sp,
                ),
              ),
            ),
            if (trailing || isDropdown)
              Icon(
                isDropdown
                    ? Icons.keyboard_arrow_down_rounded
                    : LucideIcons.calendar,
                color: Colors.white70,
                size: 21.sp,
              ),
          ],
        ),
      ),
    );
  }
}
