import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salonix/models/barber_model.dart';
import 'package:salonix/provider/time_slot_provider.dart';
import 'package:intl/intl.dart';
import 'package:salonix/widgets/confirm_booking_modal.dart';

class TimeSlotModal extends ConsumerWidget {
  final BarberModel barber;

  const TimeSlotModal({super.key, required this.barber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gold = const Color(0xFFF4B860);
    final selectedIndex = ref.watch(timeSlotProvider);
    final timeSlots = getAvailableTimeSlots();
    final selectedTime = timeSlots[selectedIndex];
    final availability = isSlotAvailable(selectedIndex);

    return Container(
      padding: EdgeInsets.all(16.w),
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
                "select time",
                style: TextStyle(
                  fontSize: 18.sp,
                  color: gold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Barber Card
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: gold),
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
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12.sp,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: gold, size: 14.sp),
                          SizedBox(width: 4.w),
                          Text(
                            "${barber.rating}  ${barber.reviews}+ Reviews",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.favorite_border, color: Colors.white54),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // Time Slot Display
          Text(
            "available time slots",
            style: TextStyle(color: Colors.white60, fontSize: 12.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            selectedTime.format(context),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            availability ? "Available" : "Not Available",
            style: TextStyle(
              color: availability ? Colors.greenAccent : Colors.redAccent,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 16.h),

          // Timeline Picker
          SizedBox(
            height: 80.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: timeSlots.length,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemBuilder: (context, index) {
                final time = timeSlots[index];
                final isSelected = index == selectedIndex;
                final slotAvailable = isSlotAvailable(index);

                return GestureDetector(
                  onTap: () {
                    ref.read(timeSlotProvider.notifier).state = index;
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (slotAvailable ? Colors.white : Colors.grey)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: slotAvailable
                            ? Colors.white24
                            : Colors.redAccent.withOpacity(0.4),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        time.format(context),
                        style: TextStyle(
                          color: isSelected
                              ? Colors.black
                              : slotAvailable
                              ? Colors.white70
                              : Colors.redAccent,
                          fontSize: 13.sp,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 24.h),

          // Book Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SizedBox(
              width: double.infinity,
              height: 40.h,
              child: ElevatedButton(
                onPressed: (selectedIndex != null && availability)
                    ? () {
                        final selectedTime = timeSlots[selectedIndex];
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) => ConfirmBookingModal(
                            barber: barber,
                            date: DateTime.now(), // or your selected date
                            time: selectedTime,
                          ),
                        );
                      }
                    : null,

                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((
                    states,
                  ) {
                    if (selectedIndex != null && availability) {
                      return const Color(0xFFF5B760); // Active gold
                    } else {
                      return const Color(0xFFE6C87C); // Default muted gold
                    }
                  }),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  elevation: MaterialStateProperty.all(0),
                ),
                child: Text(
                  "book barber",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
