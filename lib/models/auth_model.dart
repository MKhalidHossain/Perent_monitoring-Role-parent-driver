import 'package:bbpool/models/user_model.dart';

class AuthModel {
  final bool isLoading;
  final bool isLoggedIn;
  final UserModel? currentUser;
  final String errorMessage;

  // Form data
  final String email;
  final String password;
  final String confirmPassword;
  final String name;
  final String username;
  final String phone;
  final String otp;
  final String role;

  // Validation states
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isNameValid;
  final bool isUsernameValid;
  final bool isPhoneValid;
  final bool isOtpValid;
  
  // UI states
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;

  AuthModel({
    this.isLoading = false,
    this.isLoggedIn = false,
    this.currentUser,
    this.errorMessage = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.name = '',
    this.username = '',
    this.phone = '',
    this.otp = '',
    this.role = '',
    this.isEmailValid = false,
    this.isPasswordValid = false,
    this.isNameValid = false,
    this.isUsernameValid = false,
    this.isPhoneValid = false,
    this.isOtpValid = false,
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
  });

  AuthModel copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    UserModel? currentUser,
    String? errorMessage,
    String? email,
    String? password,
    String? confirmPassword,
    String? name,
    String? username,
    String? phone,
    String? otp,
    String? role,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isNameValid,
    bool? isUsernameValid,
    bool? isPhoneValid,
    bool? isOtpValid,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
  }) {
    return AuthModel(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      currentUser: currentUser ?? this.currentUser,
      errorMessage: errorMessage ?? this.errorMessage,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      name: name ?? this.name,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      otp: otp ?? this.otp,
      role: role ?? this.role,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isNameValid: isNameValid ?? this.isNameValid,
      isUsernameValid: isUsernameValid ?? this.isUsernameValid,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      isOtpValid: isOtpValid ?? this.isOtpValid,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible: isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
    );
  }
}
