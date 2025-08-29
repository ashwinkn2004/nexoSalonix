import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salonix/provider/home_screen_provider.dart';
import 'package:salonix/provider/saloon_provider.dart';
import 'package:salonix/screens/profile_screen.dart';
import 'package:salonix/widgets/saloon_card_widget.dart';
import '../widgets/location_header.dart';
import '../widgets/search_bar.dart' as custom_widgets;
import '../widgets/section_header.dart';
import '../widgets/bottom_nav_bar.dart';
import 'dart:ui';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocationPermission();
    });
  }

  Future<void> _checkLocationPermission() async {
    final hasPermission = await ref.read(locationPermissionProvider.future);
    if (hasPermission) {
      ref.refresh(locationProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final salonsAsync = ref.watch(salonListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF32373D),
      body: Stack(
        children: [
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: const Color(0xFF32373D),
                  pinned: true,
                  elevation: 0,
                  toolbarHeight: 60.h,
                  flexibleSpace: const LocationHeader(),
                ),
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: const Color(0xFF32373D),
                  pinned: true,
                  elevation: 0,
                  toolbarHeight: 70.h,
                  flexibleSpace: const custom_widgets.SearchBar(),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: salonsAsync.when(
                      data: (salons) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.h),
                          const SectionHeader(title: "Near You"),
                          SizedBox(height: 15.h),
                          HorizontalCardList(salons: salons),
                          SizedBox(height: 15.h),
                          const SectionHeader(title: "Most Visited"),
                          SizedBox(height: 15.h),
                          HorizontalCardList(salons: salons),
                          SizedBox(height: 20.h),
                        ],
                      ),
                      loading: () => SizedBox(
                        height: 200.h,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      error: (error, stack) => SizedBox(
                        height: 200.h,
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
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (int index) {
          if (index == 0) return;
          switch (index) {
            case 1:
              Navigator.pushNamed(context, '/bookings');
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
              break;
          }
        },
      ),
    );
  }
}
