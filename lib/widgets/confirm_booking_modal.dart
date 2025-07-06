import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salonix/models/barber_model.dart';
import 'package:intl/intl.dart';
import 'package:salonix/widgets/booking_confirmation_modal.dart';

class ConfirmBookingModal extends StatelessWidget {
  final BarberModel barber;
  final DateTime date;
  final TimeOfDay time;

  const ConfirmBookingModal({
    super.key,
    required this.barber,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final gold = const Color(0xFFF4B860);
    final formattedDate = DateFormat("EEEE dd MMM yyyy").format(date);
    final formattedTime = time.format(context);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF2D313A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back, color: gold),
              ),
              SizedBox(width: 12.w),
              Text(
                "confirm booking",
                style: TextStyle(
                  fontSize: 18.sp,
                  color: gold,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Barber Box with all golden
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: gold, width: 1.5),
              color: Colors.black12,
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.asset(
                    barber.imageUrl,
                    width: 55.w,
                    height: 55.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        barber.name,
                        style: TextStyle(
                          color: gold,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "Starting From ₹${barber.startingPrice}",
                        style: TextStyle(color: gold, fontSize: 12.sp),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Icon(Icons.star, color: gold, size: 14.sp),
                          SizedBox(width: 4.w),
                          Text(
                            "${barber.rating}  ${barber.reviews}+ Reviews",
                            style: TextStyle(color: gold, fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.favorite_border, color: gold),
              ],
            ),
          ),

          SizedBox(height: 32.h),

          // Date & Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Date",
                style: TextStyle(
                  color: gold,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                formattedDate,
                style: TextStyle(
                  color: gold,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Time",
                style: TextStyle(
                  color: gold,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                formattedTime,
                style: TextStyle(
                  color: gold,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          SizedBox(height: 36.h),

          // Confirm Booking Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: SizedBox(
              width: double.infinity,
              height: 45.h,
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (context) => const BookingConfirmedModal(),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "confirm booking",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
