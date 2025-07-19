import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterInput extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController editingController;

  const RegisterInput({
    super.key,
    required this.icon,
    required this.hint,
    required this.obscureText,
    this.suffixIcon,
    required this.editingController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: editingController,
      obscureText: obscureText,
      style: TextStyle(
        color: Colors.white,
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white, size: 21.sp),
        suffixIcon: suffixIcon,
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: const Color(0xFF4A5859),
        contentPadding: EdgeInsets.symmetric(vertical: 18.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: const Color(0xFFF4B860), width: 1.5),
        ),
      ),
    );
  }
}
