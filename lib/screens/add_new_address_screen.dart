import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:salonix/provider/adress_provider.dart';

class AddAddressScreen extends ConsumerStatefulWidget {
  const AddAddressScreen({super.key});

  @override
  ConsumerState<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends ConsumerState<AddAddressScreen> {
  bool isLoading = false;
  final List<String> addressTypes = ['Home', 'Work', 'Other'];

  Future<void> _fetchCurrentLocation() async {
    final notifier = ref.read(addressProvider.notifier);

    try {
      setState(() => isLoading = true);

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location permission denied")),
          );
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        notifier.updateCity(place.locality ?? '');
        notifier.updateAddressLine1(place.street ?? '');
        notifier.updatePinCode(place.postalCode ?? '');
        notifier.updateAddressLine2(
          "${place.subLocality ?? ''} ${place.administrativeArea ?? ''}",
        );

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Location updated.")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addressProvider);
    final notifier = ref.read(addressProvider.notifier);
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final blurHeight = statusBarHeight + 20.h;

    return Scaffold(
      backgroundColor: const Color(0xFF32373D),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: blurHeight,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(color: Colors.black.withOpacity(0.05)),
              ),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 16.h,
                  left: 16.w,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: const Color(0xFF4A5859),
                          size: 36.sp,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 50.w),
                      Text(
                        "Add Address",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFF4B860),
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 80.h),
                      _AddressTypeSelector(
                        initialType: state.addressType ?? 'Home',
                        types: addressTypes,
                        onChanged: notifier.updateAddressType,
                      ),
                      SizedBox(height: 12.h),
                      _LocationBox(
                        isLoading: isLoading,
                        onTap: _fetchCurrentLocation,
                      ),
                      SizedBox(height: 12.h),
                      _CustomField(
                        hint: "Address Line 01",
                        value: state.addressLine1,
                        onChanged: notifier.updateAddressLine1,
                      ),
                      _CustomField(
                        hint: "Address Line 02",
                        value: state.addressLine2,
                        onChanged: notifier.updateAddressLine2,
                      ),
                      _CustomField(
                        hint: "Pin Code",
                        value: state.pinCode,
                        onChanged: notifier.updatePinCode,
                        keyboardType: TextInputType.number,
                      ),
                      _CustomField(
                        hint: "City",
                        value: state.city,
                        onChanged: notifier.updateCity,
                      ),
                      _CustomField(
                        hint: "Phone Number",
                        value: state.phone,
                        onChanged: notifier.updatePhone,
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: .2.sh),
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  debugPrint(
                                    "Saving address: ${state.addressLine1}",
                                  );
                                },
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFFF4B860),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: Text(
                            "SAVE",
                            style: TextStyle(
                              color: const Color(0xFF2F2F2F),
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                    ],
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

class _AddressTypeSelector extends StatelessWidget {
  final String initialType;
  final List<String> types;
  final Function(String) onChanged;

  const _AddressTypeSelector({
    required this.initialType,
    required this.types,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onChanged,
      itemBuilder: (BuildContext context) {
        return types.map((String type) {
          return PopupMenuItem<String>(value: type, child: Text(type));
        }).toList();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFF4A5859),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Text(
              initialType,
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
            const Spacer(),
            const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _CustomField extends StatelessWidget {
  final String hint;
  final String value;
  final TextInputType? keyboardType;
  final void Function(String) onChanged;

  const _CustomField({
    required this.hint,
    required this.value,
    required this.onChanged,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: TextField(
        controller: TextEditingController(text: value),
        onChanged: onChanged,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFF4A5859),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _LocationBox extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _LocationBox({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFF4A5859),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Text(
              isLoading ? "Detecting location..." : "Use Current Location",
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
            const Spacer(),
            const Icon(Icons.location_on, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
