abstract class AppUrl {
  static const String baseUrl = 'http://localhost:5001/api/v1';
  static const String login = '$baseUrl/users/login';
  static const String register = '$baseUrl/users/register';
  static const String sendOtp = '$baseUrl/auth/send-otp';
  static const String verifyEmail = '$baseUrl/users/verify-email';
  static const String profile =
      '$baseUrl/users/users'; // GET profile with user ID
  static const String updateProfile =
      '$baseUrl/users/update-profile'; // PUT update profile
  static const String googleSignIn = '$baseUrl/auth/google';
  static const String appleSignIn = '$baseUrl/auth/apple';
}
