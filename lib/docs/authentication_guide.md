# Authentication System Guide

This guide explains how to use the authentication system in the BBPool app.

## Overview

The authentication system provides:
- Login with email/password
- Token management (access token and refresh token)
- User data persistence using SharedPreferences
- Automatic navigation based on authentication status
- Role-based access control

## Key Components

### 1. StorageService (`lib/services/storage_service.dart`)
Manages all SharedPreferences operations for authentication data.

**Key Methods:**
- `saveToken(String token)` - Save access token
- `getToken()` - Get access token
- `clearToken()` - Clear access token
- `saveRefreshToken(String refreshToken)` - Save refresh token
- `getRefreshToken()` - Get refresh token
- `saveUserData(Map<String, dynamic> userData)` - Save user data
- `getUserData()` - Get user data
- `clearAllUserData()` - Clear all authentication data
- `isLoggedIn()` - Check if user is logged in

### 2. AuthUtils (`lib/utils/auth_utils.dart`)
Utility class for authentication operations.

**Key Methods:**
- `isAuthenticated()` - Check if user is authenticated
- `getToken()` - Get current token
- `getUserRole()` - Get user role
- `getUserId()` - Get user ID
- `hasRole(String role)` - Check if user has specific role
- `isDriver()` - Check if user is driver
- `isPassenger()` - Check if user is passenger
- `getAuthHeaders()` - Get authorization headers for API calls

### 3. LoginResponseModel (`lib/models/login_response_model.dart`)
Model for login API response.

**Properties:**
- `accessToken` - JWT access token
- `refreshToken` - JWT refresh token
- `role` - User role (driver/passenger)
- `id` - User ID
- `email` - User email

### 4. AuthWrapper (`lib/widgets/auth_wrapper.dart`)
Widget that handles automatic navigation based on authentication status.

## Usage Examples

### 1. Login Process

```dart
// In your login screen
final authProvider = Provider.of<AuthProvider>(context);

// Update email and password
authProvider.updateEmail('user@example.com');
authProvider.updatePassword('password123');

// Perform login
await authProvider.login();

// Check if login was successful
if (authProvider.isLoggedIn) {
  // User is now logged in, navigation will be handled automatically
  print('Login successful!');
} else {
  // Show error message
  print('Login failed: ${authProvider.errorMessage}');
}
```

### 2. Check Authentication Status

```dart
// Check if user is authenticated
if (AuthUtils.isAuthenticated()) {
  print('User is logged in');
  print('Token: ${AuthUtils.getToken()}');
  print('Role: ${AuthUtils.getUserRole()}');
} else {
  print('User is not logged in');
}
```

### 3. Make Authenticated API Calls

```dart
// Get authorization headers
final headers = AuthUtils.getAuthHeaders();

// Use in HTTP request
final response = await http.get(
  Uri.parse('https://api.example.com/protected-endpoint'),
  headers: headers,
);
```

### 4. Role-Based Access Control

```dart
// Check user role
if (AuthUtils.isDriver()) {
  // Show driver-specific UI
  print('User is a driver');
} else if (AuthUtils.isPassenger()) {
  // Show passenger-specific UI
  print('User is a passenger');
}

// Check specific role
if (AuthUtils.hasRole('admin')) {
  // Show admin features
}
```

### 5. Logout Process

```dart
// Logout user
await authProvider.logout();

// Or manually clear all data
await AuthUtils.clearAuthData();
```

### 6. Get User Data

```dart
// Get stored user data
final userData = AuthUtils.getUserData();
if (userData != null) {
  print('User email: ${userData['email']}');
  print('User ID: ${userData['id']}');
  print('User verified: ${userData['is_verified']}');
}
```

## API Response Format

The login API should return the following format:

```json
{
  "success": true,
  "message": "User logged in successfully",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkPxVCJ9...",
    "role": "driver",
    "_id": "68f9c73283ee0aff417bad0f",
    "email": "user@example.com"
  }
}
```

## Navigation Flow

1. **App Start**: `AuthWrapper` checks authentication status
2. **If Logged In**: Navigate to `MainNavigationScreen` (Home)
3. **If Not Logged In**: Navigate to `LoginScreen`
4. **After Login**: Automatically navigate to Home
5. **After Logout**: Automatically navigate to Login

## Storage Keys

The following keys are used in SharedPreferences:

- `user_token` - Access token
- `refresh_token` - Refresh token
- `user_data` - User data (JSON string)
- `user_role` - User role
- `user_id` - User ID

## Error Handling

The authentication system handles errors gracefully:

- Network errors during login
- Invalid tokens
- Expired tokens
- Storage errors

Error messages are available through `authProvider.errorMessage`.

## Best Practices

1. **Always check authentication status** before making API calls
2. **Use AuthUtils.getAuthHeaders()** for authenticated requests
3. **Handle loading states** during authentication operations
4. **Clear sensitive data** on logout
5. **Validate tokens** before making API calls
6. **Use role-based access control** for different user types

## Demo Screen

A demo screen is available at `lib/views/demo/auth_demo_screen.dart` that shows:
- Current authentication status
- Token information
- User data
- Authentication actions (login, logout, clear data)

Add this route to your app routes to test the authentication system.
