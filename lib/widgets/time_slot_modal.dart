import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salonix/models/barber_model.dart';
import 'package:salonix/provider/time_slot_provider.dart';
import 'package:salonix/widgets/confirm_booking_modal.dart';

class TimeSlotModal extends ConsumerWidget {
  final BarberModel barber;

  const TimeSlotModal({super.key, required this.barber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gold = const Color(0xFFF4B860);
    final bgColor = const Color(0xFF4A5859);
    final innerCardColor = const Color(0xFF32373D);

    final selectedIndex = ref.watch(timeSlotProvider);
    final timeSlots = getAvailableTimeSlots();

    final selectedTime =
        (selectedIndex >= 0 && selectedIndex < timeSlots.length)
        ? timeSlots[selectedIndex]
        : null;

    final availability =
        (selectedIndex >= 0 && selectedIndex < timeSlots.length)
        ? isSlotAvailable(selectedIndex)
        : false;

    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(color: bgColor),
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
                Expanded(
                  child: Text(
                    "select time",
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: gold,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 24.w),
              ],
            ),
            SizedBox(height: 16.h),

            // Barber Card with Top-Right Heart Icon
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: gold, width: 1.5),
                    color: innerCardColor,
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: gold, width: 2),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.asset(
                            barber.imageUrl,
                            width: 55.w,
                            height: 55.w,
                            fit: BoxFit.cover,
                          ),
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
                            Row(
                              children: [
                                Icon(Icons.star, color: gold, size: 14.sp),
                                SizedBox(width: 4.w),
                                Text(
                                  "${barber.rating}  ${barber.reviews}+ Reviews",
                                  style: TextStyle(
                                    color: gold.withOpacity(0.8),
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    barber.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: gold,
                    size: 20.sp,
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Time Info
            Text(
              "available time slots",
              style: TextStyle(color: Colors.white60, fontSize: 12.sp),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      selectedTime != null
                          ? selectedTime.format(context)
                          : "--:--",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      selectedTime == null
                          ? "Please select a time"
                          : availability
                          ? "Available"
                          : "Not Available",
                      style: TextStyle(
                        color: selectedTime == null
                            ? Colors.white38
                            : availability
                            ? Colors.greenAccent
                            : Colors.redAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Time Slots Strip
            SizedBox(
              height: 60.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: timeSlots.length,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                itemBuilder: (context, index) {
                  final time = timeSlots[index];
                  final isSelected = index == selectedIndex;
                  final slotAvailable = isSlotAvailable(index);

                  return GestureDetector(
                    onTap: () {
                      ref.read(timeSlotProvider.notifier).state = index;
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 6.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (slotAvailable ? Colors.white : Colors.grey)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected
                              ? gold
                              : slotAvailable
                              ? Colors.white24
                              : Colors.redAccent.withOpacity(0.3),
                          width: 1.2,
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
            SizedBox(height: 28.h),

            // Book Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SizedBox(
                width: double.infinity,
                height: 40.h,
                child: ElevatedButton(
                  onPressed:
                      (selectedIndex != null &&
                          selectedIndex >= 0 &&
                          availability)
                      ? () {
                          final selectedTime = timeSlots[selectedIndex];
                          Navigator.pop(context);
                          Future.delayed(Duration.zero, () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (_) => ConfirmBookingModal(
                                barber: barber,
                                date: DateTime.now(),
                                time: selectedTime,
                              ),
                            );
                          });
                        }
                      : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((
                      states,
                    ) {
                      return (selectedIndex != null &&
                              selectedIndex >= 0 &&
                              availability)
                          ? const Color(0xFFF5B760)
                          : const Color(0xFFE6C87C);
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
                      color: Colors.white70,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}

// Dummy time slot generator
List<TimeOfDay> getAvailableTimeSlots() {
  return List.generate(12, (index) {
    return TimeOfDay(hour: 10 + index, minute: 0);
  });
}

// Dummy availability
bool isSlotAvailable(int index) {
  return index % 3 != 0;
}
