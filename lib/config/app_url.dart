abstract class AppUrl {
  // static const String baseUrl = 'http://10.10.5.95:5001/api/v1';
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

  // Parent endpoints
  static const String parentScheduledRides = '$baseUrl/parent/scheduled-rides';
  static const String parentCalendarRides = '$baseUrl/parent/calendar-rides';
  static const String parentCancelRide = '$baseUrl/parent/cancel-ride';
  static const String parentScheduleRide = '$baseUrl/parent/schedule-ride';
  static const String parentTrackRide = '$baseUrl/parent/track-ride';
  static const String parentRideDetails = '$baseUrl/parent/ride-details';

  // Child Info endpoints
  static const String addChildInfo = '$baseUrl/childInfo/add-child';
  static const String getChildInfo = '$baseUrl/childInfo/my-child-info';
  static String deleteChildInfo(String childId) => '$baseUrl/childInfo/delete-child-info/$childId';
  static String updateChildInfo(String childId) => '$baseUrl/childInfo/update-child-info/$childId';
}
