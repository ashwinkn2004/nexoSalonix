import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:salonix/provider/home_screen_provider.dart';

class LocationHeader extends ConsumerWidget {
  const LocationHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location =
        ref.watch(locationProvider).valueOrNull ??
        {'city': 'Unknown', 'state': 'Unknown'};

    return Padding(
      padding: EdgeInsets.only(left: 28.w, right: 28.w, top: 30.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 30.h,
                color: const Color(0xFFF0F0F0),
              ),
              SizedBox(width: 6.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location['city']!,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFF0F0F0),
                      fontSize: 11.sp,
                    ),
                  ),
                  Text(
                    location['state']!,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFF0F0F0),
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Icon(
            LucideIcons.settings,
            size: 23.h,
            color: const Color(0xFFF0F0F0),
          ),
        ],
      ),
    );
  }
}
