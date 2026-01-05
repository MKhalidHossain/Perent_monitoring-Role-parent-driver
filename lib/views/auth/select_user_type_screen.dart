import 'package:bbpool/config/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:bbpool/config/app_colors.dart';
import 'package:bbpool/providers/select_user_type_provider.dart';
import 'package:bbpool/providers/auth_provider.dart';
import 'package:bbpool/routes/app_routes.dart';

class SelectUserTypeScreen extends StatelessWidget {
  const SelectUserTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Main Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      'Choose Your Role',
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                    )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 600.ms)
                        .slideY(begin: 0.3, end: 0),

                    const SizedBox(height: 16),

                    Text(
                      'Select how you\'ll be using BBPool',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    )
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 600.ms)
                        .slideY(begin: 0.3, end: 0),

                    const SizedBox(height: 48),

                    // User Type Cards
                    Consumer<SelectUserTypeProvider>(
                      builder: (context, provider, child) {
                        return Column(
                          children: List.generate(
                            provider.userTypes.length,
                            (index) {
                              final userType = provider.userTypes[index];
                              return _buildUserTypeCard(
                                context,
                                userType,
                                index,
                                provider,
                              );
                            },
                          ),
                        );
                      },
                    )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 600.ms)
                        .slideY(begin: 0.3, end: 0),

                    const SizedBox(height: 48),

                    // Continue Button
                    Consumer<SelectUserTypeProvider>(
                      builder: (context, provider, child) {
                        return Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: AppColors.gradientButton,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ElevatedButton(
                            onPressed: provider.selectedUserType != null ? () {
                              // Set the role in auth provider using getSelectedRole method
                              final authProvider = Provider.of<AuthProvider>(context, listen: false);
                              String? selectedRole = provider.getSelectedRole();
                              
                              if (selectedRole != null) {
                                authProvider.updateRole(selectedRole);
                                print('Role selected and set: $selectedRole');
                                Navigator.of(context).pushNamed(AppRoutes.signup, arguments: selectedRole);
                              } else {
                                print('No role selected');
                              }
                            } : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Continue',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppColors.textWhite,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        );
                      },
                    )
                        .animate()
                        .fadeIn(delay: 800.ms, duration: 600.ms)
                        .slideY(begin: 0.3, end: 0),
                  ],
                ),
              ),
            ),

            // Bottom Home Indicator
            Container(
              width: 134,
              height: 5,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: AppColors.textPrimary,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTypeCard(
    BuildContext context,
    dynamic userType,
    int index,
    SelectUserTypeProvider provider,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () => provider.selectUserType(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            // color: userType.isSelected ? const Color(0xFFF0F8FF) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: userType.isSelected
                  ? const Color(0xFFE9CCE2)
                  : const Color(0xFF363636),
              width: userType.isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(index == 0
                            ? IconPath.prentIcon
                            : IconPath.carIcon))),
              ),

              const SizedBox(width: 20),

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userType.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      userType.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                    ),
                  ],
                ),
              ),

              // Selection Indicator
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: userType.isSelected
                        ? const Color(0xFF6366F1)
                        : const Color(0xFFD1D5DB),
                    width: 2,
                  ),
                  color: userType.isSelected
                      ? const Color(0xFF6366F1)
                      : Colors.transparent,
                ),
                child: userType.isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
