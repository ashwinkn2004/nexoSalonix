import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salonix/consts.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final double navSpacing = media.size.width * 0.27;
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
        child: Center(
          child: Row(
            children: [
              Expanded(
                child: _buildNavItem(
                  context,
                  icon: Icons.home,
                  label: 'home',
                  isSelected: true,
                ),
              ),
              SizedBox(width: navSpacing),
              Expanded(
                child: _buildNavItem(
                  context,
                  icon: Icons.search,
                  label: 'search',
                  isSelected: false,
                ),
              ),
              SizedBox(width: navSpacing),
              Expanded(
                child: _buildNavItem(
                  context,
                  icon: LucideIcons.userCircle2,
                  label: 'profile',
                  isSelected: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isSelected ? const Color(0xFFF4B860) : const Color(0xFFF0F0F0),
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
    );
  }
}
