import 'package:flutter_riverpod/flutter_riverpod.dart';

// Only manages visibility of password fields for UI
class RegisterFormState {
  final bool showPassword1;
  final bool showPassword2;
  RegisterFormState({this.showPassword1 = false, this.showPassword2 = false});
  RegisterFormState copyWith({bool? showPassword1, bool? showPassword2}) =>
      RegisterFormState(
        showPassword1: showPassword1 ?? this.showPassword1,
        showPassword2: showPassword2 ?? this.showPassword2,
      );
}

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  RegisterFormNotifier() : super(RegisterFormState());

  void toggleShowPassword1() =>
      state = state.copyWith(showPassword1: !state.showPassword1);
  void toggleShowPassword2() =>
      state = state.copyWith(showPassword2: !state.showPassword2);
}

final registerFormProvider =
    StateNotifierProvider<RegisterFormNotifier, RegisterFormState>(
      (ref) => RegisterFormNotifier(),
    );
