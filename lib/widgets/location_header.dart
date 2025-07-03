import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LocationHeader extends StatelessWidget {
  const LocationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 28.w, right: 28.w, top: 18.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center, // <--- Important
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center, // <--- Important
            children: [
              Icon(
                Icons.location_on,
                size: 30.h,
                color: const Color(0xFFF0F0F0),
              ),
              SizedBox(width: 6.w), // Small space between icon and text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center, // <--- Important
                children: [
                  Text(
                    'location,',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFF0F0F0),
                      fontSize: 11.sp,
                      letterSpacing: 0.1,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'state',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFF0F0F0),
                      fontSize: 11.sp,
                      letterSpacing: 0.05,
                    ),
                    overflow: TextOverflow.ellipsis,
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
