import 'package:bbpool/models/auth_model.dart';
import 'package:bbpool/models/user_model.dart';
import 'package:bbpool/services/api_service.dart';
import 'package:bbpool/services/token_manager.dart';
import 'package:bbpool/config/app_config.dart';
import 'package:bbpool/routes/app_routes.dart';
import 'package:bbpool/utils/role_navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel {
  AuthModel _model = AuthModel();

  AuthModel get model => _model;

  // Getters for easy access
  bool get isLoading => _model.isLoading;
  bool get isLoggedIn => _model.isLoggedIn;
  UserModel? get currentUser => _model.currentUser;
  String get errorMessage => _model.errorMessage;

  // Form getters
  String get email => _model.email;
  String get password => _model.password;
  String get confirmPassword => _model.confirmPassword;
  String get name => _model.name;
  String get username => _model.username;
  String get phone => _model.phone;
  String get otp => _model.otp;
  String get role => _model.role;

  // Validation getters
  bool get isEmailValid => _model.isEmailValid;
  bool get isPasswordValid => _model.isPasswordValid;
  bool get isNameValid => _model.isNameValid;
  bool get isUsernameValid => _model.isUsernameValid;
  bool get isPhoneValid => _model.isPhoneValid;
  bool get isOtpValid => _model.isOtpValid;

  // UI state getters
  bool get isPasswordVisible => _model.isPasswordVisible;
  bool get isConfirmPasswordVisible => _model.isConfirmPasswordVisible;

  // Initialize and check auth status
  Future<void> initialize(BuildContext context) async {
    await checkAuthStatus(context);
  }

  // Check if user is already logged in
  Future<void> checkAuthStatus(BuildContext context) async {
    try {
      _updateModel(_model.copyWith(isLoading: true));

      // Check if user is logged in using TokenManager
      final isLoggedIn = await TokenManager.isLoggedIn();

      if (isLoggedIn) {
        // Get user data from TokenManager
        final userData = await TokenManager.getUserData();

        if (userData != null) {
          // Create UserModel from stored data
          final user = UserModel.fromJson(userData);

          _updateModel(_model.copyWith(
            currentUser: user,
            isLoggedIn: true,
            isLoading: false,
          ));

          debugPrint('User authenticated from stored data');
        } else {
          await logout(context);
        }
      } else {
        _updateModel(_model.copyWith(isLoading: false));
        debugPrint('No stored authentication found');
      }
    } catch (e) {
      debugPrint('Error checking auth status: $e');
      _updateModel(_model.copyWith(
        errorMessage: 'Error checking auth status: ${e.toString()}',
        isLoading: false,
      ));
    }
  }

  // Login
  Future<void> login(BuildContext context) async {
    if (!_validateLoginForm()) return;

    _updateModel(_model.copyWith(isLoading: true, errorMessage: ''));

    try {
      debugPrint('=== LOGIN REQUEST ===');
      debugPrint('Email: ${_model.email}');
      debugPrint('Password: ${_model.password}');
      debugPrint('====================');

      final response = await ApiService.login(
        email: _model.email,
        password: _model.password,
      );

      debugPrint('=== LOGIN RESPONSE ===');
      debugPrint('Success: ${response.success}');
      debugPrint('Message: ${response.message}');
      debugPrint('Data: ${response.data}');
      debugPrint('======================');

      if (response.success && response.data != null) {
        // Save user data using TokenManager
        await TokenManager.saveUserData(response.data!.toJson());

        debugPrint('=== TOKEN SAVE SUCCESS ===');
        debugPrint('Access Token: ${response.data!.accessToken}');
        debugPrint('Refresh Token: ${response.data!.refreshToken}');
        debugPrint('User Role: ${response.data!.role}');
        debugPrint('User ID: ${response.data!.id}');
        debugPrint('User Email: ${response.data!.email}');
        debugPrint('========================');

        // Create UserModel from login response
        final user = UserModel.fromJson(response.data!.toJson());

        _updateModel(_model.copyWith(
          currentUser: user,
          isLoggedIn: true,
          isLoading: false,
          errorMessage: '',
        ));

        debugPrint('✅ Login successful - user data saved to SharedPreferences');

        // Navigate based on user role using helper
        // RoleNavigationHelper.navigateToDashboard(context, response.data!.role);
        if(user.role == 'parent' ){
          Navigator.pushNamed(context, AppRoutes.parentDashboard);
        } if(user.role == 'driver' ){
          Navigator.pushNamed(context, AppRoutes.driverDashboard);
        }
      } else {
        _updateModel(_model.copyWith(
          errorMessage: response.message,
          isLoading: false,
        ));
        debugPrint('Login failed: ${response.message}');
      }
    } catch (e) {
      debugPrint('Login error: $e');
      _updateModel(_model.copyWith(
        errorMessage: 'Login failed: ${e.toString()}',
        isLoading: false,
      ));
    }
  }

  // Register
  Future<void> register() async {
    if (!_validateRegisterForm()) return;

    _updateModel(_model.copyWith(isLoading: true, errorMessage: ''));

    try {
      // Debug print the registration data
      debugPrint('Registration data:');
      debugPrint('Name: ${_model.name}');
      debugPrint('Username: ${_model.username}');
      debugPrint('Email: ${_model.email}');
      debugPrint('Password: ${_model.password}');
      debugPrint('Role: ${_model.role}');

      final response = await ApiService.register(
        name: _model.name,
        username: _model.username,
        email: _model.email,
        password: _model.password,
        role: _model.role,
      );

      debugPrint('Registration response:');
      debugPrint('Success: ${response.success}');
      debugPrint('Message: ${response.message}');
      debugPrint('Data: ${response.data}');
      if (response.success && response.data != null) {
        _updateModel(_model.copyWith(
          currentUser: response.data,
          isLoggedIn: true,
          isLoading: false,
        ));

        // Save token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            AppConfig.userTokenKey, 'dummy_token'); // Replace with actual token
        await prefs.setString(
            AppConfig.userDataKey, response.data!.toJson().toString());
      } else {
        _updateModel(_model.copyWith(
          errorMessage: response.message,
          isLoading: false,
        ));
      }
    } catch (e) {
      debugPrint('Registration error: $e');
      _updateModel(_model.copyWith(
        errorMessage: 'Registration failed: ${e.toString()}',
        isLoading: false,
      ));
    }
  }

  // Send OTP
  Future<void> sendOtp() async {
    if (_model.email.isEmpty) {
      _updateModel(_model.copyWith(errorMessage: 'Please enter your email'));
      return;
    }

    _updateModel(_model.copyWith(isLoading: true, errorMessage: ''));

    try {
      final response = await ApiService.sendOtp(email: _model.email);

      if (response.success) {
        _updateModel(_model.copyWith(isLoading: false));
      } else {
        _updateModel(_model.copyWith(
          errorMessage: response.message,
          isLoading: false,
        ));
      }
    } catch (e) {
      _updateModel(_model.copyWith(
        errorMessage: 'Failed to send OTP: ${e.toString()}',
        isLoading: false,
      ));
    }
  }

  // Verify OTP
  Future<void> verifyOtp(BuildContext context) async {
    if (_model.otp.length != AppConfig.otpLength) {
      _updateModel(_model.copyWith(errorMessage: 'Please enter a valid OTP'));
      return;
    }

    _updateModel(_model.copyWith(isLoading: true, errorMessage: ''));

    try {
      debugPrint('=== API OTP VERIFICATION ===');
      debugPrint('Email: ${_model.email}');
      debugPrint('OTP: ${_model.otp}');
      debugPrint('===========================');

      final response = await ApiService.verifyEmail(
        email: _model.email,
        otp: _model.otp,
      );

      debugPrint('OTP Verification Response:');
      debugPrint('Success: ${response.success}');
      debugPrint('Message: ${response.message}');
      debugPrint('Data: ${response.data}');

      if (response.success) {
        // OTP verification successful, navigate to login screen
        _updateModel(_model.copyWith(
          isLoading: false,
          errorMessage: '',
        ));

        // Navigate to login screen after successful OTP verification
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        debugPrint('OTP verification successful - navigating to login');
      } else {
        _updateModel(_model.copyWith(
          errorMessage: response.message,
          isLoading: false,
        ));
        debugPrint('OTP verification failed: ${response.message}');
      }
    } catch (e) {
      debugPrint('OTP verification error: $e');
      _updateModel(_model.copyWith(
        errorMessage: 'OTP verification failed: ${e.toString()}',
        isLoading: false,
      ));
    }
  }

  // Google Sign In
  Future<void> googleSignIn() async {
    _updateModel(_model.copyWith(isLoading: true, errorMessage: ''));

    try {
      // Implement Google Sign In logic here
      // For now, simulate success
      await Future.delayed(const Duration(seconds: 2));

      // Mock user data
      final mockUser = UserModel(
        id: 'google_user_123',
        email: _model.email,
        name: 'Google User',
        username: 'google_user',
        phone: '+1234567890',
        role: 'driver',
        isVerified: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _updateModel(_model.copyWith(
        currentUser: mockUser,
        isLoggedIn: true,
        isLoading: false,
      ));
    } catch (e) {
      _updateModel(_model.copyWith(
        errorMessage: 'Google Sign In failed: ${e.toString()}',
        isLoading: false,
      ));
    }
  }

  // Apple Sign In
  Future<void> appleSignIn() async {
    _updateModel(_model.copyWith(isLoading: true, errorMessage: ''));

    try {
      // Implement Apple Sign In logic here
      // For now, simulate success
      await Future.delayed(const Duration(seconds: 2));

      // Mock user data
      final mockUser = UserModel(
        id: 'apple_user_123',
        email: _model.email,
        name: 'Apple User',
        username: 'apple_user',
        phone: '+1234567890',
        role: 'parent',
        isVerified: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _updateModel(_model.copyWith(
        currentUser: mockUser,
        isLoggedIn: true,
        isLoading: false,
      ));
    } catch (e) {
      _updateModel(_model.copyWith(
        errorMessage: 'Apple Sign In failed: ${e.toString()}',
        isLoading: false,
      ));
    }
  }

  // Logout
  Future<void> logout(BuildContext context) async {
    try {
      // Clear all user data using TokenManager
      bool isLogOut = await TokenManager.clearUserData();

      _updateModel(_model.copyWith(
        currentUser: null,
        isLoggedIn: false,
        errorMessage: '',
      ));

      if (isLogOut) {
        debugPrint('User logged out successfully');

        Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.splash, (Route<dynamic> route) => false);
      } else {
        debugPrint('Logout failed');
      }
    } catch (e) {
      debugPrint('Logout error: $e');
      _updateModel(_model.copyWith(
        errorMessage: 'Logout failed: ${e.toString()}',
      ));
    }
  }

  // Form validation
  bool _validateLoginForm() {
    if (_model.email.isEmpty) {
      _updateModel(_model.copyWith(errorMessage: 'Please enter your email'));
      return false;
    }
    if (_model.password.isEmpty) {
      _updateModel(_model.copyWith(errorMessage: 'Please enter your password'));
      return false;
    }
    return true;
  }

  bool _validateRegisterForm() {
    if (_model.name.isEmpty) {
      _updateModel(_model.copyWith(errorMessage: 'Please enter your name'));
      return false;
    }
    if (_model.username.isEmpty) {
      _updateModel(_model.copyWith(errorMessage: 'Please enter your username'));
      return false;
    }
    if (_model.email.isEmpty) {
      _updateModel(_model.copyWith(errorMessage: 'Please enter your email'));
      return false;
    }
    if (_model.password.isEmpty) {
      _updateModel(_model.copyWith(errorMessage: 'Please enter your password'));
      return false;
    }
    if (_model.password != _model.confirmPassword) {
      _updateModel(_model.copyWith(errorMessage: 'Passwords do not match'));
      return false;
    }
    if (_model.role.isEmpty) {
      _updateModel(_model.copyWith(errorMessage: 'Please select a role'));
      return false;
    }
    return true;
  }

  // Update form fields
  void updateEmail(String value) {
    _updateModel(_model.copyWith(
      email: value,
      isEmailValid: _isEmailValid(value),
    ));
  }

  void updatePassword(String value) {
    _updateModel(_model.copyWith(
      password: value,
      isPasswordValid: value.length >= AppConfig.minPasswordLength,
    ));
  }

  void updateConfirmPassword(String value) {
    _updateModel(_model.copyWith(confirmPassword: value));
  }

  void updateName(String value) {
    _updateModel(_model.copyWith(
      name: value,
      isNameValid: value.isNotEmpty,
    ));
  }

  void updateUsername(String value) {
    _updateModel(_model.copyWith(
      username: value,
      isUsernameValid: value.isNotEmpty,
    ));
  }

  void updatePhone(String value) {
    _updateModel(_model.copyWith(
      phone: value,
      isPhoneValid: value.isNotEmpty,
    ));
  }

  void updateOtp(String value) {
    _updateModel(_model.copyWith(
      otp: value,
      isOtpValid: value.length == AppConfig.otpLength,
    ));
  }

  void updateRole(String value) {
    _updateModel(_model.copyWith(role: value));
  }

  void togglePasswordVisibility() {
    _updateModel(_model.copyWith(isPasswordVisible: !_model.isPasswordVisible));
  }

  void toggleConfirmPasswordVisibility() {
    _updateModel(_model.copyWith(
        isConfirmPasswordVisible: !_model.isConfirmPasswordVisible));
  }

  // Clear form
  void clearForm() {
    _updateModel(_model.copyWith(
      email: '',
      password: '',
      confirmPassword: '',
      name: '',
      username: '',
      phone: '',
      otp: '',
      role: '',
      errorMessage: '',
      isPasswordVisible: false,
      isConfirmPasswordVisible: false,
    ));
  }

  // Update error message
  void updateError(String error) {
    _updateModel(_model.copyWith(errorMessage: error));
  }

  // Private helper methods
  void _updateModel(AuthModel newModel) {
    _model = newModel;
  }

  bool _isEmailValid(String email) {
    return email.isNotEmpty &&
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
