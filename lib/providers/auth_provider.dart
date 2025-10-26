import 'package:bbpool/viewmodels/auth_viewmodel.dart';
import 'package:bbpool/models/auth_model.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final AuthViewModel _viewModel = AuthViewModel();

  AuthViewModel get viewModel => _viewModel;
  AuthModel get model => _viewModel.model;

  // Getters for easy access
  bool get isLoading => _viewModel.isLoading;
  bool get isLoggedIn => _viewModel.isLoggedIn;
  get currentUser => _viewModel.currentUser;
  String get errorMessage => _viewModel.errorMessage;

  // Form getters
  String get email => _viewModel.email;
  String get password => _viewModel.password;
  String get confirmPassword => _viewModel.confirmPassword;
  String get name => _viewModel.name;
  String get username => _viewModel.username;
  String get phone => _viewModel.phone;
  String get otp => _viewModel.otp;
  String get role => _viewModel.role;

  // Validation getters
  bool get isEmailValid => _viewModel.isEmailValid;
  bool get isPasswordValid => _viewModel.isPasswordValid;
  bool get isNameValid => _viewModel.isNameValid;
  bool get isUsernameValid => _viewModel.isUsernameValid;
  bool get isPhoneValid => _viewModel.isPhoneValid;
  bool get isOtpValid => _viewModel.isOtpValid;
  
  // UI state getters
  bool get isPasswordVisible => _viewModel.isPasswordVisible;
  bool get isConfirmPasswordVisible => _viewModel.isConfirmPasswordVisible;

  AuthProvider() {
    _viewModel.initialize();
  }

  // Delegate methods to ViewModel
  Future<void> login(BuildContext context) async {
    await _viewModel.login(context);
    notifyListeners();
  }

  Future<void> register() async {
    await _viewModel.register();
    notifyListeners();
  }

  Future<void> sendOtp() async {
    await _viewModel.sendOtp();
    notifyListeners();
  }

  Future<void> verifyOtp(BuildContext context) async {
    await _viewModel.verifyOtp(context);
    notifyListeners();
  }

  Future<void> googleSignIn() async {
    await _viewModel.googleSignIn();
    notifyListeners();
  }

  Future<void> appleSignIn() async {
    await _viewModel.appleSignIn();
    notifyListeners();
  }

  Future<void> logout() async {
    await _viewModel.logout();
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    await _viewModel.checkAuthStatus();
    notifyListeners();
  }

  // Update form fields
  void updateEmail(String value) {
    _viewModel.updateEmail(value);
    notifyListeners();
  }

  void updatePassword(String value) {
    _viewModel.updatePassword(value);
    notifyListeners();
  }

  void updateConfirmPassword(String value) {
    _viewModel.updateConfirmPassword(value);
    notifyListeners();
  }

  void updateName(String value) {
    _viewModel.updateName(value);
    notifyListeners();
  }

  void updateUsername(String value) {
    _viewModel.updateUsername(value);
    notifyListeners();
  }

  void updatePhone(String value) {
    _viewModel.updatePhone(value);
    notifyListeners();
  }

  void updateOtp(String value) {
    _viewModel.updateOtp(value);
    notifyListeners();
  }

  void updateRole(String value) {
    _viewModel.updateRole(value);
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _viewModel.togglePasswordVisibility();
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _viewModel.toggleConfirmPasswordVisibility();
    notifyListeners();
  }

  void clearForm() {
    _viewModel.clearForm();
    notifyListeners();
  }

  void updateError(String error) {
    _viewModel.updateError(error);
    notifyListeners();
  }
}
