import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:salonix/models/saloon_models.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class SalonDetailsScreen extends StatefulWidget {
  final SalonModel salon;

  const SalonDetailsScreen({Key? key, required this.salon}) : super(key: key);

  @override
  State<SalonDetailsScreen> createState() => _SalonDetailsScreenState();
}

class _SalonDetailsScreenState extends State<SalonDetailsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final salon = widget.salon;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF2D313A),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28.sp,
                      ),
                    ),
                    Icon(Icons.settings, color: Colors.white54, size: 24.sp),
                  ],
                ),
                SizedBox(height: 12.h),
      
                // Salon Image Carousel
                Stack(
                  children: [
                    Container(
                      height: 355.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() => _currentPage = index);
                          },
                          itemCount: 3,
                          itemBuilder: (_, index) =>
                              Image.asset(salon.image, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10.w,
                      bottom: 10.h,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              "${salon.distance.toStringAsFixed(1)} km",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
      
                SizedBox(height: 10.h),
      
                // Dot Indicator
                Center(
                  child: AnimatedSmoothIndicator(
                    activeIndex: _currentPage,
                    count: 3,
                    effect: WormEffect(
                      dotHeight: 8.h,
                      dotWidth: 8.w,
                      activeDotColor: const Color(0xFFF4B860),
                      dotColor: Colors.white24,
                    ),
                  ),
                ),
      
                SizedBox(height: 20.h),
      
                // Salon Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          salon.name,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFF4B860),
                          ),
                        ),
                        Text(
                          salon.address,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 20.sp),
                        SizedBox(width: 4.w),
                        Text(
                          salon.rating.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
      
                // About Us
                Text(
                  "About Us",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFF4B860),
                  ),
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nisi odio ut tortor maecenas integer et odio. Sit sed congue risus, quis. Vel blandit rhoncus eget orci sagittis a.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp,
                      height: 1.5,
                    ),
                  ),
                ),
      
                SizedBox(height: 24.h),
      
                // Services
                Text(
                  "Select A Services",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFF4B860),
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  height: 80.h, // Increased for better spacing
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(width: 12.w),
                        _buildServiceChip("Hair", imageAsset: 'assets/hair.png'),
                        SizedBox(width: 16.w),
                        _buildServiceChip("Spa", imageAsset: 'assets/spa.png'),
                        SizedBox(width: 16.w),
                        _buildServiceChip(
                          "Nails",
                          imageAsset: 'assets/nails.png',
                        ),
                        SizedBox(width: 16.w),
                        _buildServiceChip(
                          "Skincare",
                          imageAsset: 'assets/hair.png',
                        ),
                        SizedBox(width: 16.w),
                        _buildServiceChip("More", imageAsset: 'assets/hair.png'),
                        SizedBox(width: 12.w),
                      ],
                    ),
                  ),
                ),
      
                SizedBox(height: 24.h),
      
                // Map Placeholder
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: SizedBox(
                    height: 200.h,
                    width: double.infinity,
                    child: FlutterMap(
                      options: MapOptions(
                        center: LatLng(
                          widget.salon.latitude,
                          widget.salon.longitude,
                        ),
                        zoom: 16.0,
                      ),
                      children: [
                        // ✅ Realistic OpenStreetMap tiles from Carto (no API key required)
                        TileLayer(
                          urlTemplate:
                              'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                          subdomains: ['a', 'b', 'c', 'd'],
                          userAgentPackageName: 'com.example.salonix',
                        ),
                        // Marker
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(
                                widget.salon.latitude,
                                widget.salon.longitude,
                              ),
                              width: 40,
                              height: 40,
                              child: Icon(
                                Icons.location_on,
                                color: Colors.redAccent,
                                size: 36.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
      
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  alignment: Alignment.center,
                  child: Text(
                    salon.address,
                    style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceChip(String label, {IconData? icon, String? imageAsset}) {
    return Padding(
      padding: EdgeInsets.only(right: 12.w),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Color(0xFFD9D9D9),
            radius: 22.r,
            child: imageAsset != null
                ? Image.asset(
                    imageAsset,
                    width: 22.w,
                    height: 22.h,
                    fit: BoxFit.contain,
                  )
                : Icon(icon, color: Colors.white, size: 20.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
