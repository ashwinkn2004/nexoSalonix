import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final timeSlotProvider = StateProvider<int>(
  (ref) => 25,
); // default index for 12:30 PM

List<TimeOfDay> getAvailableTimeSlots() {
  return List.generate(
    48, // 24 hours × 2 (half-hour slots)
    (index) => TimeOfDay(hour: index ~/ 2, minute: index.isEven ? 0 : 30),
  );
}

bool isSlotAvailable(int index) {
  // Custom logic: for example, unavailable if divisible by 5
  return index % 5 != 0;
}
