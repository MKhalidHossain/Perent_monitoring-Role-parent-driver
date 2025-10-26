# BBPool - Role-Based Dashboard App

This Flutter application implements a role-based authentication system with separate dashboard screens for drivers and parents, following the MVC pattern with reusable widgets.

## Features

### Authentication System
- **Role-based login**: Users can login as either "driver" or "parent"
- **Automatic navigation**: After login, users are automatically directed to their role-specific dashboard
- **Persistent authentication**: User sessions are maintained using SharedPreferences

### Dashboard Screens

#### Driver Dashboard
- **Today's Rides**: Shows scheduled rides with departure/arrival times
- **Start Ride Button**: Allows drivers to start their rides
- **Monthly Statistics**: 
  - Rides Completed
  - On-Time Pickups
  - Distance Traveled
  - Children Dropped
  - Cancellations
  - Active Carpool Groups

#### Parent Dashboard
- **Today's Rides**: Shows child's scheduled rides
- **Track Ride Button**: Allows parents to track their child's ride
- **Monthly Statistics**:
  - Rides Completed
  - On-Time Pickups
  - Scheduled Rides
  - Active Carpool Groups

### Architecture

#### MVC Pattern Implementation
- **Models**: `UserModel`, `DashboardModel`, `RideModel`, `StatModel`
- **Views**: Dashboard screens, authentication screens
- **Controllers**: `AuthViewModel`, `DashboardViewModel`
- **Providers**: `AuthProvider`, `DashboardProvider` (using Provider pattern)

#### Reusable Widgets
- `DashboardHeader`: User profile header with credits display
- `TodayRidesSection`: Rides list with timeline visualization
- `MonthlyStatsSection`: Statistics grid display
- `BottomNavigation`: Navigation bar with role-specific options

## API Integration

The app expects user data in the following format:

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
    "role": "driver",
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

## Navigation Flow

1. **Splash Screen** → Checks authentication status
2. **Login Screen** → User authentication
3. **Auth Wrapper** → Routes based on user role
4. **Driver Dashboard** → For users with role "driver"
5. **Parent Dashboard** → For users with role "parent"

## Key Components

### Models
- `UserModel`: User data structure with role support
- `DashboardModel`: Dashboard data container
- `RideModel`: Individual ride information
- `StatModel`: Statistics display data

### Providers
- `AuthProvider`: Manages authentication state
- `DashboardProvider`: Manages dashboard data and actions

### Screens
- `DriverDashboardScreen`: Driver-specific dashboard
- `ParentDashboardScreen`: Parent-specific dashboard
- `AuthWrapper`: Role-based routing component

## Usage

1. **Login**: Users login with their credentials
2. **Role Detection**: System automatically detects user role from API response
3. **Dashboard Display**: Appropriate dashboard is shown based on role
4. **Navigation**: Bottom navigation provides access to different sections

## Customization

The app uses a consistent color scheme defined in `AppColors`:
- Primary: Purple (#8A2BE2)
- Secondary: Blue (#4A90E2)
- Success: Green (#4CAF50)
- Warning: Orange (#FF9800)
- Error: Red (#F44336)

## Dependencies

- `provider`: State management
- `shared_preferences`: Local storage
- `flutter_animate`: Animations
- Custom API service integration

## Future Enhancements

- Real-time ride tracking
- Push notifications
- Advanced filtering options
- Profile management
- Settings screen
- Calendar integration
- Group management
