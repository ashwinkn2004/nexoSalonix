import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salonix/consts.dart'; // Make sure Responsive.iconSize(context) is defined here

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final double navSpacing = media.size.width * 0.15;
    final double barHeight = media.size.height * 0.09;
    final EdgeInsets padding = EdgeInsets.symmetric(
      horizontal: media.size.width * 0.06,
    );

    return SafeArea(
      top: false,
      child: Container(
        height: barHeight,
        color: const Color(0xFF4A5859),
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(context, icon: Icons.home, label: 'home', index: 0),
            _buildNavItem(
              context,
              icon: Icons.search,
              label: 'search',
              index: 1,
            ),
            _buildNavItem(
              context,
              icon: LucideIcons.userCircle2,
              label: 'profile',
              index: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = widget.currentIndex == index;

    return GestureDetector(
      onTap: () => widget.onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected
                ? const Color(0xFFF4B860)
                : const Color(0xFFF0F0F0),
            size: Responsive.iconSize(context),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: 10.sp,
              color: isSelected
                  ? const Color(0xFFF4B860)
                  : const Color(0xFFF0F0F0),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
