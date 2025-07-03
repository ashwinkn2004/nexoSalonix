import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salonix/widgets/saloon_card_widget.dart';

import '../widgets/location_header.dart';
import '../widgets/search_bar.dart' as custom_widgets;
import '../widgets/section_header.dart';
import '../widgets/bottom_nav_bar.dart';
import '../consts.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = Responsive.screenHeight(context);
    final screenWidth = Responsive.screenWidth(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF32373D),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: const Color(0xFF32373D),
                pinned: true,
                elevation: 0,
                toolbarHeight: screenHeight * 0.08,
                flexibleSpace: const LocationHeader(),
              ),
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: const Color(0xFF32373D),
                pinned: true,
                elevation: 0,
                toolbarHeight: screenHeight * 0.085,
                flexibleSpace: custom_widgets.SearchBar(),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.045,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      SectionHeader(title: "Near You"),
                      SizedBox(height: screenHeight * 0.025),
                      HorizontalCardList(),
                      SizedBox(height: screenHeight * 0.015),
                      SectionHeader(title: "Most Visited"),
                      SizedBox(height: screenHeight * 0.017),
                      HorizontalCardList(),
                      SizedBox(height: screenHeight * 0.024),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBottomNavBar(),
      ),
    );
  }
}
