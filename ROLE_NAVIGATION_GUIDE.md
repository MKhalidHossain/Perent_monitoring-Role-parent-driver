# Role-Based Navigation System

## Overview
This Flutter app implements a comprehensive role-based authentication and navigation system that automatically routes users to appropriate dashboard screens based on their role after successful login.

## How It Works

### 1. Login Process
When a user logs in successfully, the system:
1. Saves user data to local storage using `TokenManager`
2. Updates the authentication state
3. Checks the user's role from the API response
4. Navigates to the appropriate dashboard screen

### 2. Role Checking Logic
The system supports two main roles:
- **Driver**: Users who provide transportation services
- **Parent**: Users who book rides for their children

### 3. Navigation Flow
```
Login Screen → Auth ViewModel → Role Check → Dashboard Screen
```

## Implementation Details

### AuthViewModel Login Method
```dart
Future<void> login(BuildContext context) async {
  // ... authentication logic ...
  
  if (response.success && response.data != null) {
    // Save user data
    await TokenManager.saveUserData(response.data!.toJson());
    
    // Update model state
    _updateModel(_model.copyWith(
      currentUser: response.data,
      isLoggedIn: true,
      isLoading: false,
      errorMessage: '',
    ));
    
    // Navigate based on role
    RoleNavigationHelper.navigateToDashboard(context, response.data!.role);
  }
}
```

### RoleNavigationHelper Utility
A utility class that handles role-based navigation:

```dart
class RoleNavigationHelper {
  static void navigateToDashboard(BuildContext context, String role) {
    final userRole = role.toLowerCase();
    
    switch (userRole) {
      case 'driver':
        Navigator.of(context).pushReplacementNamed(AppRoutes.driverDashboard);
        break;
      case 'parent':
        Navigator.of(context).pushReplacementNamed(AppRoutes.parentDashboard);
        break;
      default:
        Navigator.of(context).pushReplacementNamed(AppRoutes.authWrapper);
        break;
    }
  }
}
```

### AuthWrapper Component
Provides fallback navigation for users with stored authentication:

```dart
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (!authProvider.isLoggedIn || authProvider.currentUser == null) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final userRole = authProvider.currentUser!.role.toLowerCase();
        
        switch (userRole) {
          case 'driver':
            return const DriverDashboardScreen();
          case 'parent':
            return const ParentDashboardScreen();
          default:
            // Handle unknown roles
            return const Scaffold(body: Center(child: Text('Unknown role')));
        }
      },
    );
  }
}
```

## API Response Format

The system expects user data in this format:

```json
{
  "success": true,
  "message": "User updated successfully",
  "data": {
    "avatar": {
      "url": "https://res.cloudinary.com/ddtuyxcsl/image/upload/v1761461073/avatar/zmhq9b960o7b3tfezp1u.jpg",
      "public_id": "avatar/zmhq9b960o7b3tfezp1u"
    },
    "_id": "68fd9fe330bd1ced79fef068",
    "name": "sadasdad",
    "email": "jakirhossain03222@gmail.com",
    "username": "Jakir333",
    "credit": null,
    "role": "driver",  // ← This determines navigation
    "fine": 0,
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "createdAt": "2025-10-26T04:13:23.772Z",
    "updatedAt": "2025-10-26T06:44:34.436Z",
    "__v": 0,
    "dateOfBirth": "1998-10-26T00:00:00.000Z",
    "phone": "01902313222"
  }
}
```

## Dashboard Screens

### Driver Dashboard (`/driver-dashboard`)
- **Features**: Today's rides, start ride functionality, driver statistics
- **Navigation**: Direct navigation after driver login
- **Stats**: Rides completed, on-time pickups, distance traveled, etc.

### Parent Dashboard (`/parent-dashboard`)
- **Features**: Child's rides, track ride functionality, parent statistics
- **Navigation**: Direct navigation after parent login
- **Stats**: Rides completed, on-time pickups, scheduled rides, etc.

## Testing

### Role Test Screen
A test screen is available at `/role-test` to verify role-based navigation:

```dart
// Navigate to test screen
Navigator.of(context).pushNamed(AppRoutes.roleTest);
```

The test screen provides buttons to test navigation for:
- Driver role
- Parent role
- Invalid role (fallback behavior)

## Error Handling

### Unknown Roles
If a user has an unknown role:
1. System logs the error
2. Navigates to AuthWrapper for fallback handling
3. Shows appropriate error message
4. Redirects to login screen

### Navigation Failures
- All navigation calls are wrapped in try-catch blocks
- Debug logs provide detailed information about navigation attempts
- Fallback navigation ensures users don't get stuck

## Debug Information

The system provides comprehensive debug logging:

```
🔍 Checking user role: driver
🚗 Navigating to Driver Dashboard
✅ Login successful - user data saved to SharedPreferences
```

## Usage Examples

### Basic Login with Role Navigation
```dart
// In login screen
await authProvider.login(context);
// Navigation happens automatically in the viewmodel
```

### Manual Role Check
```dart
// Check if role is valid
if (RoleNavigationHelper.isValidRole(userRole)) {
  RoleNavigationHelper.navigateToDashboard(context, userRole);
}
```

### Get Role Information
```dart
// Get display name
String displayName = RoleNavigationHelper.getRoleDisplayName('driver'); // "Driver"

// Get role icon
IconData icon = RoleNavigationHelper.getRoleIcon('parent'); // Icons.family_restroom
```

## Security Considerations

1. **Role Validation**: All roles are validated before navigation
2. **Case Insensitive**: Role checking is case-insensitive for robustness
3. **Fallback Handling**: Unknown roles are handled gracefully
4. **State Management**: Authentication state is properly managed and persisted

## Future Enhancements

1. **Role Permissions**: Add permission-based feature access
2. **Multi-Role Support**: Support users with multiple roles
3. **Role Switching**: Allow users to switch between roles
4. **Admin Dashboard**: Add support for admin role
5. **Role-Based UI**: Customize UI elements based on user role
