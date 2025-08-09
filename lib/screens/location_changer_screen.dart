import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:salonix/provider/home_screen_provider.dart';
import 'package:salonix/screens/add_new_address_screen.dart';
import 'package:salonix/screens/home_screen.dart';
import 'package:salonix/widgets/bottom_nav_bar.dart';

class SelectLocationScreen extends ConsumerStatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  ConsumerState<SelectLocationScreen> createState() =>
      _SelectLocationScreenState();
}

class _SelectLocationScreenState extends ConsumerState<SelectLocationScreen> {
  final user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> savedAddresses = [];

  @override
  void initState() {
    super.initState();
    _loadSavedAddresses();
  }

  Future<void> _loadSavedAddresses() async {
    if (user == null) return;
    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('addresses')
        .get();
    setState(() {
      savedAddresses = snap.docs.map((doc) => doc.data()).toList();
    });
  }

  void _useCurrentLocation() {
    ref.refresh(locationProvider);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = ref.watch(locationProvider).valueOrNull;

    return Scaffold(
      backgroundColor: const Color(0xFF32373D),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (int value) {},
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Image.asset(
                      'assets/arrow_drop_up.png',
                      height: 15.h,
                      width: 15.h,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Select A Location',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  hintText: 'Search Places',
                  hintStyle: TextStyle(color: Colors.white70, fontSize: 14.sp),
                  prefixIcon: Icon(Icons.search, color: Colors.white70, size: 20.h),
                  filled: true,
                  fillColor: const Color(0xFF4A5859),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              // Combined container for both options
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A5859),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  children: [
                    // Current Location Option
                    _buildLocationOption(
                      icon: Icons.location_on,
                      title: 'Use Current Location',
                      subtitle: currentLocation != null
                          ? '${currentLocation['city']}, ${currentLocation['state']}'
                          : 'Detecting...',
                      onTap: _useCurrentLocation,
                    ),
                    Divider(
                      color: Colors.white.withOpacity(0.1),
                      height: 1.h,
                      thickness: 1,
                    ),
                    // Add Address Option
                    _buildLocationOption(
                      icon: Icons.add,
                      title: 'Add Address',
                      subtitle: '',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddAddressScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: Text(
                  'Saved Addresses',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: ListView.builder(
                  itemCount: savedAddresses.length,
                  itemBuilder: (_, i) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: _SavedAddressTile(address: savedAddresses[i]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24.h),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle.isNotEmpty) SizedBox(height: 4.h),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12.sp,
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white70, size: 20.h),
          ],
        ),
      ),
    );
  }
}

class _SavedAddressTile extends StatelessWidget {
  final Map<String, dynamic> address;

  const _SavedAddressTile({required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF4D545C),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.mapPin, color: Colors.white, size: 20.h),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address['label'] ?? 'Address',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${address['line1'] ?? ''}, ${address['line2'] ?? ''}',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}