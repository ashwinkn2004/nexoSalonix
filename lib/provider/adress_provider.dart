import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class AddressState {
  final String addressLine1;
  final String addressLine2;
  final String pinCode;
  final String city;
  final String phone;
  final String addressType;

  AddressState({
    this.addressLine1 = '',
    this.addressLine2 = '',
    this.pinCode = '',
    this.city = '',
    this.phone = '',
    this.addressType = 'Home',
  });

  // Add this toJson() method
  Map<String, dynamic> toJson() {
    return {
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'pinCode': pinCode,
      'city': city,
      'phone': phone,
      'addressType': addressType,
    };
  }

  AddressState copyWith({
    String? addressLine1,
    String? addressLine2,
    String? pinCode,
    String? city,
    String? phone,
    String? addressType,
  }) {
    return AddressState(
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      pinCode: pinCode ?? this.pinCode,
      city: city ?? this.city,
      phone: phone ?? this.phone,
      addressType: addressType ?? this.addressType,
    );
  }
}

class AddressNotifier extends StateNotifier<AddressState> {
  AddressNotifier() : super(AddressState());

  void updateCity(String city) {
    state = state.copyWith(city: city);
  }

  void updateAddressLine1(String line) {
    state = state.copyWith(addressLine1: line);
  }

  void updateAddressLine2(String line) {
    state = state.copyWith(addressLine2: line);
  }

  void updatePinCode(String pin) {
    state = state.copyWith(pinCode: pin);
  }

  void updatePhone(String value) {
    state = state.copyWith(phone: value);
  }

  void updateAddressType(String value) {
    state = state.copyWith(addressType: value);
  }
}

final addressProvider = StateNotifierProvider<AddressNotifier, AddressState>((ref) {
  return AddressNotifier();
});