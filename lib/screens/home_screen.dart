import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salonix/provider/saloon_provider.dart';
import 'package:salonix/widgets/saloon_card_widget.dart';

import '../widgets/location_header.dart';
import '../widgets/search_bar.dart' as custom_widgets;
import '../widgets/section_header.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    final salonsAsync = ref.watch(salonListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF32373D),
      body: Stack(
        children: [
          // Main content under SafeArea
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // Location header
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: const Color(0xFF32373D),
                  pinned: true,
                  elevation: 0,
                  toolbarHeight: screenHeight * 0.08,
                  flexibleSpace: const LocationHeader(),
                ),

                // Search bar
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: const Color(0xFF32373D),
                  pinned: true,
                  elevation: 0,
                  toolbarHeight: screenHeight * 0.085,
                  flexibleSpace: custom_widgets.SearchBar(),
                ),

                // Salon Sections
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.045,
                    ),
                    child: salonsAsync.when(
                      data: (salons) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.h),
                          SectionHeader(title: "Near You"),
                          SizedBox(height: screenHeight * 0.025),
                          HorizontalCardList(salons: salons),
                          SizedBox(height: screenHeight * 0.025),
                          SectionHeader(title: "Most Visited"),
                          SizedBox(height: screenHeight * 0.025),
                          HorizontalCardList(salons: salons),
                          SizedBox(height: screenHeight * 0.03),
                        ],
                      ),
                      loading: () => SizedBox(
                        height: screenHeight * 0.5,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      error: (error, stack) => SizedBox(
                        height: screenHeight * 0.5,
                        child: Center(
                          child: Text('Error loading salons: $error'),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Top blur effect (outside safe area)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: statusBarHeight + 12.h,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(color: Colors.black.withOpacity(0.05)),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
