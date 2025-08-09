import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    ref.refresh(locationProvider); // ✅ Refresh to fetch location
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = ref.watch(locationProvider).valueOrNull;

    return Scaffold(
      backgroundColor: const Color(0xFF2D2F36),
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
              Text(
                'Select A Location',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search Places',
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.search, color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF44484F),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              _LocationTile(
                icon: Icons.my_location,
                title: 'Use Current Location',
                subtitle: currentLocation != null
                    ? '${currentLocation['city']}, ${currentLocation['state']}'
                    : 'Detecting...',
                onTap: _useCurrentLocation,
              ),
              SizedBox(height: 12.h),
              _AddNewAddressTile(
                icon: Icons.add,
                title: 'Add Address',
                subtitle: '',
                onTap: () {
                  // TODO: Navigate to add address screen
                },
              ),
              SizedBox(height: 20.h),
              Text(
                'Saved Addresses',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: ListView.builder(
                  itemCount: savedAddresses.length,
                  itemBuilder: (_, i) =>
                      _SavedAddressTile(address: savedAddresses[i]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddNewAddressTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AddNewAddressTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddAddressScreen(),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: const Color(0xFF3D434D),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20.h),
            SizedBox(width: 10.w),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subtitle.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Text(
                  subtitle,
                  style: TextStyle(color: Colors.white54, fontSize: 11.sp),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LocationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _LocationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: const Color(0xFF3D434D),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20.h),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.white54, fontSize: 11.sp),
                  ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.white70),
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
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF4D545C),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(Icons.location_pin, color: Colors.white70, size: 20.h),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address['label'] ?? 'Address',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
                Text(
                  '${address['line1'] ?? ''}, ${address['line2'] ?? ''}',
                  style: TextStyle(color: Colors.white60, fontSize: 11.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
