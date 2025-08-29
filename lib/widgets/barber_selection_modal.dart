import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salonix/models/barber_model.dart';
import 'package:salonix/provider/selected_barber_provider.dart';
import 'package:salonix/widgets/time_slot_modal.dart';

class BarberSelectionModal extends ConsumerWidget {
  final String serviceCategory;
  final DateTime selectedDate;

  const BarberSelectionModal({
    super.key,
    required this.serviceCategory,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedBarber = ref.watch(selectedBarberProvider);
    final barbers = _mockBarbers();
    final gold = const Color(0xFFF4B860);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        color: const Color(0xFF4A5859),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back, color: gold, size: 24.sp),
                  ),
                ),
                Text(
                  "select a barber",
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: gold,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Barber List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: barbers.length,
              itemBuilder: (context, index) {
                final barber = barbers[index];
                final isSelected = selectedBarber?.name == barber.name;

                return GestureDetector(
                  onTap: () =>
                      ref.read(selectedBarberProvider.notifier).state = barber,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF32373D),
                      border: Border.all(
                        color: isSelected ? gold : Colors.white,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            // Barber Image with border
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected ? gold : Colors.white,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: Image.asset(
                                  barber.imageUrl,
                                  width: 60.w,
                                  height: 60.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),

                            // Barber Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    barber.name,
                                    style: TextStyle(
                                      color: isSelected ? gold : Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "Starting From ₹${barber.startingPrice}",
                                    style: TextStyle(
                                      color: isSelected
                                          ? gold
                                          : const Color(0xFFF0F0F0),
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: isSelected ? gold : Colors.amber,
                                        size: 10.sp,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        "${barber.rating}  ${barber.reviews}+ Reviews",
                                        style: TextStyle(
                                          color: isSelected
                                              ? gold
                                              : Colors.white54,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Favorite icon top-right
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Icon(
                            barber.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isSelected ? gold : Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20.h),

            // Book Barber Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SizedBox(
                width: 315.w,
                height: 35.h,
                child: ElevatedButton(
                  onPressed: selectedBarber == null
                      ? null
                      : () {
                          Navigator.pop(context);
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) =>
                                TimeSlotModal(barber: selectedBarber!),
                          );
                        },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (states) => states.contains(MaterialState.disabled)
                          ? const Color(0xFFE6C87C)
                          : gold,
                    ),
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
                      color: selectedBarber != null
                          ? Colors.white
                          : Colors.white54,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
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

  // Sample barber list
  List<BarberModel> _mockBarbers() {
    return [
      BarberModel(
        name: "John Doe",
        imageUrl: "assets/welcome.jpg",
        rating: 4.5,
        reviews: 4500,
        startingPrice: 150,
        isFavorite: false,
      ),
      BarberModel(
        name: "Alex Smith",
        imageUrl: "assets/welcome.jpg",
        rating: 4.6,
        reviews: 3200,
        startingPrice: 180,
        isFavorite: false,
      ),
      BarberModel(
        name: "Emily James",
        imageUrl: "assets/welcome.jpg",
        rating: 4.4,
        reviews: 2900,
        startingPrice: 160,
        isFavorite: false,
      ),
    ];
  }
}
