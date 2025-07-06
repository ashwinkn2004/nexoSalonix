import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salonix/provider/date_selection_provider.dart';

class DateSelectorModal extends ConsumerWidget {
  final void Function(DateTime selectedDate)? onContinue;

  const DateSelectorModal({super.key, this.onContinue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedDateIndexProvider);
    final selectedIndexNotifier = ref.read(selectedDateIndexProvider.notifier);

    return SizedBox(
      height: 234.h,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(
          left: 24.w,
          right: 24.w,
          top: 24.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              'select your date',
              style: TextStyle(
                color: const Color(0xFFF4B860),
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 30.h),

            // Date selector
            SizedBox(
              height: 56.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (context, index) {
                  final date = DateTime.now().add(Duration(days: index));
                  final dayAbbr = [
                    'MON',
                    'TUE',
                    'WED',
                    'THU',
                    'FRI',
                    'SAT',
                    'SUN',
                  ][date.weekday - 1];
                  final dayNum = date.day.toString().padLeft(2, '0');
                  final isTuesday = date.weekday == DateTime.tuesday;
                  final isSelected = selectedIndex == index;

                  Color bgColor = Colors.transparent;
                  if (isTuesday) {
                    bgColor = Colors.white;
                  } else if (isSelected) {
                    bgColor = const Color(0xFFF4B860);
                  }

                  return Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: GestureDetector(
                      onTap: () {
                        if (!isTuesday) {
                          selectedIndexNotifier.state = index;
                        }
                      },
                      child: Container(
                        height: 52.h,
                        width: 56.w,
                        decoration: BoxDecoration(
                          color: bgColor,
                          border: Border.all(
                            color: isTuesday ? Colors.white : Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                dayAbbr,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                dayNum,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 35.h),

            // Continue button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SizedBox(
                width: 315.w,
                height: 35.h,
                child: ElevatedButton(
                  onPressed: selectedIndex != null
                      ? () {
                          final selectedDate = DateTime.now().add(
                            Duration(days: selectedIndex),
                          );
                          if (onContinue != null) {
                            onContinue!(selectedDate);
                          } else {
                            Navigator.pop(context);
                          }
                        }
                      : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((
                      states,
                    ) {
                      if (states.contains(MaterialState.disabled)) {
                        return const Color(0xFFE6C87C);
                      }
                      return const Color(0xFFF4B860);
                    }),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    elevation: MaterialStateProperty.all(0),
                  ),
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      color: selectedIndex != null
                          ? Colors.black
                          : Colors.black54,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
