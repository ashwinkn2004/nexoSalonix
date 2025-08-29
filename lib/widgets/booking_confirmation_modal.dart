import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingConfirmedModal extends StatelessWidget {
  const BookingConfirmedModal({super.key});

  @override
  Widget build(BuildContext context) {
    final gold = const Color(0xFFF4B860);
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.4, // Expanded from 1/3 to 40% for bigger GIF
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFF4A5859),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        children: [
          Text(
            "booking confirmed",
            style: TextStyle(
              color: gold,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 10.h),

          // MASSIVE, CENTERED, BEAUTIFUL GIF
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/done.gif',
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
          ),

          SizedBox(height: 4.h),

          Text(
            "thanks, your booking has been confirmed",
            style: TextStyle(
              color: gold.withOpacity(0.85),
              fontWeight: FontWeight.w400,
              fontSize: 13.sp,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 10.h),

          SizedBox(
            width: double.infinity,
            height: 40.h,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
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
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
