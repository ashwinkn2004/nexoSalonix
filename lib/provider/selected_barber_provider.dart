// lib/provider/selected_barber_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salonix/models/barber_model.dart';

final selectedBarberProvider = StateProvider<BarberModel?>((ref) => null);
