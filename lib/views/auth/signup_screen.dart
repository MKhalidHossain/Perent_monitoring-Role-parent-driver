import 'package:bbpool/config/image_path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:bbpool/config/app_colors.dart';
import 'package:bbpool/providers/auth_provider.dart';
import 'package:bbpool/providers/select_user_type_provider.dart';
import 'package:bbpool/routes/app_routes.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final selectUserTypeProvider = Provider.of<SelectUserTypeProvider>(context, listen: false);

    // Get role from multiple sources with priority
    String role = '';
    try {
      // Priority 1: From SelectUserTypeProvider getSelectedRole()
      final selectedRole = selectUserTypeProvider.getSelectedRole();
      if (selectedRole != null) {
        role = selectedRole;
      } else {
        // Priority 2: From arguments
        final args = ModalRoute.of(context)?.settings.arguments;
        if (args is String) {
          role = args;
        } else {
          // Priority 3: From authProvider
          role = authProvider.role;
        }
      }
    } catch (e) {
      role = authProvider.role;
    }

    // Debug prints for role parsing
    debugPrint('=== ROLE PARSING DEBUG ===');
    debugPrint('Role from SelectUserTypeProvider.getSelectedRole(): ${selectUserTypeProvider.getSelectedRole()}');
    debugPrint('Role from arguments: ${ModalRoute.of(context)?.settings.arguments}');
    debugPrint('Role from authProvider: ${authProvider.role}');
    debugPrint('Final parsed role: $role');
    debugPrint('Role type: ${role.runtimeType}');
    debugPrint('========================');

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0E6F0),
              Color(0xFFC0C8D8),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // Back Button
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: AppColors.textSecondary,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Top Content (Safe Rides, Happy Kids, Confident Parents)
                        _buildTopContent(context),

                        // Spacer to push the form card to the bottom
                        const Expanded(
                          child: SizedBox.shrink(),
                        ),

                        // Signup Form Card
                        _buildSignupFormCard(context, authProvider, role),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Text(
            'Safe Rides.',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          )
              .animate()
              .fadeIn(delay: 200.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0),

          Text(
            'Happy Kids.',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: const Color(0xFFA0B0C8),
              fontWeight: FontWeight.bold,
            ),
          )
              .animate()
              .fadeIn(delay: 400.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0),

          Text(
            'Confident Parents.',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          )
              .animate()
              .fadeIn(delay: 600.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0),

          // Children Illustration
          Image.asset(
            ImagePath.onboarding3,
            width: double.infinity,
            height: 100,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSignupFormCard(BuildContext context, AuthProvider authProvider, String role) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: AppColors.textSecondary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),

                // Role Display (for debugging)
                if (role.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF2196F3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: Color(0xFF2196F3),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Registering as: ${role.toUpperCase()}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF2196F3),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Social Login Buttons
                _buildSocialLoginButtons(context, authProvider),

                const SizedBox(height: 20),

                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: const Color(0xFFC0C0C0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'or',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFFC0C0C0),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: const Color(0xFFC0C0C0),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Name Field
                TextFormField(
                  onChanged: authProvider.updateName,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: const TextStyle(color: Color(0xFFA0A0A0)),
                    prefixIcon: const Icon(Icons.person_outline, color: Color(0xFFA0A0A0)),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Username Field
                TextFormField(
                  onChanged: authProvider.updateUsername,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'jakir2',
                    labelStyle: const TextStyle(color: Color(0xFFA0A0A0)),
                    hintStyle: const TextStyle(color: AppColors.textPrimary),
                    prefixIcon: const Icon(Icons.person_outline, color: Color(0xFFA0A0A0)),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Email Field
                TextFormField(
                  onChanged: authProvider.updateEmail,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'bbpool@gmail.com',
                    labelStyle: const TextStyle(color: Color(0xFFA0A0A0)),
                    hintStyle: const TextStyle(color: AppColors.textPrimary),
                    prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFFA0A0A0)),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Password Field
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return TextFormField(
                      onChanged: authProvider.updatePassword,
                      obscureText: !authProvider.isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Color(0xFFA0A0A0)),
                        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFA0A0A0)),
                        suffixIcon: IconButton(
                          onPressed: () {
                            authProvider.togglePasswordVisibility();
                          },
                          icon: Icon(
                            authProvider.isPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFFA0A0A0),
                          ),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Confirm Password Field
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return TextFormField(
                      onChanged: authProvider.updateConfirmPassword,
                      obscureText: !authProvider.isConfirmPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: const TextStyle(color: Color(0xFFA0A0A0)),
                        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFA0A0A0)),
                        suffixIcon: IconButton(
                          onPressed: () {
                            authProvider.toggleConfirmPasswordVisibility();
                          },
                          icon: Icon(
                            authProvider.isConfirmPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFFA0A0A0),
                          ),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // Error Message
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return authProvider.errorMessage.isNotEmpty
                        ? Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.error),
                      ),
                      child: Text(
                        authProvider.errorMessage,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    )
                        : const SizedBox.shrink();
                  },
                ),

                // Signup Button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: AppColors.gradientButton,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          // Ensure role is set before registration
                          if (role.isNotEmpty) {
                            authProvider.updateRole(role);
                            debugPrint('Role set in authProvider: $role');
                          }

                          // Debug print API body data
                          debugPrint('=== API BODY DEBUG ===');
                          debugPrint('Name: ${authProvider.name}');
                          debugPrint('Username: ${authProvider.username}');
                          debugPrint('Email: ${authProvider.email}');
                          debugPrint('Password: ${authProvider.password}');
                          debugPrint('Role: ${authProvider.role}');
                          debugPrint('====================');

                          await authProvider.register();
                          if (authProvider.isLoggedIn && context.mounted) {
                            Navigator.of(context).pushReplacementNamed(AppRoutes.otpVerification);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          disabledBackgroundColor: Colors.transparent,
                        ),
                        child: authProvider.isLoading
                            ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: AppColors.textWhite,
                            strokeWidth: 2.5,
                          ),
                        )
                            : const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textWhite,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.login),
                      child: Text(
                        'Login',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                // Add some bottom padding for safety
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLoginButtons(BuildContext context, AuthProvider authProvider) {
    return Column(
      children: [
        // Google Sign In
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: TextButton(
            onPressed: () async {
              await authProvider.googleSignIn();
              if (authProvider.isLoggedIn) {
                Navigator.of(context).pushReplacementNamed(AppRoutes.home);
              }
            },
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF4285F4),
                        Color(0xFF34A853),
                        Color(0xFFFBBC05),
                        Color(0xFFEA4335)
                      ],
                      stops: [0.0, 0.33, 0.66, 1.0],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'G',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Continue with Google',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Apple Sign In
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: TextButton(
            onPressed: () async {
              await authProvider.appleSignIn();
              if (authProvider.isLoggedIn) {
                Navigator.of(context).pushReplacementNamed(AppRoutes.home);
              }
            },
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.apple,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Continue with Apple ID',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
