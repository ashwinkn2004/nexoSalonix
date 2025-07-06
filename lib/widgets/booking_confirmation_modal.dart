import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salonix/screens/home_screen.dart';

class BookingConfirmedModal extends StatelessWidget {
  const BookingConfirmedModal({super.key});

  @override
  Widget build(BuildContext context) {
    final gold = const Color(0xFFF4B860);

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFF2D313A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "booking confirmed",
            style: TextStyle(
              color: gold,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 36.h),

          // Placeholder for GIF (replace with your own asset or network image)
          SizedBox(
            height: 180.h,
            width: 180.h,
            child: Image.asset('assets/done.gif', fit: BoxFit.contain),
          ),

          SizedBox(height: 36.h),

          Text(
            "thanks, your booking has been confirmed",
            style: TextStyle(color: gold.withOpacity(0.8), fontSize: 13.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),

          // Close Button
          SizedBox(
            width: double.infinity,
            height: 40.h,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => const HomeScreen()
                ));
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: gold,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
                elevation: 0,
              ),
              child: Text(
                "close",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
