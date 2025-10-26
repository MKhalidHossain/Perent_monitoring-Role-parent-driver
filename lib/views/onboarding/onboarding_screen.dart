import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:bbpool/config/app_colors.dart';
import 'package:bbpool/providers/onboarding_provider.dart';
import 'package:bbpool/routes/app_routes.dart';
import 'package:bbpool/services/storage_service.dart';
import 'package:bbpool/widgets/common_widgets.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  void _navigateAfterOnboarding(BuildContext context) async {
    // Check if onboarding was completed before
    if (StorageService.isOnboardingCompleted()) {
      // User has seen onboarding before, go to login
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    } else {
      // First time user, go to select user type
      Navigator.of(context).pushReplacementNamed(AppRoutes.selectUserType);
    }
  }

  @override
  Widget build(BuildContext context) {
    final onboardingProvider = Provider.of<OnboardingProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
        

            // Page Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Consumer<OnboardingProvider>(
                    builder: (context, onboardingProvider, child) {
                      return Row(
                        children: List.generate(
                          onboardingProvider.pages.length,
                          (index) => Container(
                            width:
                                index == onboardingProvider.currentPage ? 24 : 8,
                            height: 4,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: index == onboardingProvider.currentPage
                                  ? AppColors.primary
                                  : AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      onboardingProvider.skipOnboarding();
                      _navigateAfterOnboarding(context);
                    },
                    child: Text(
                      'Skip >',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: PageView.builder(
                controller: PageController(),
                onPageChanged: (page) => onboardingProvider.goToPage(page),
                itemCount: onboardingProvider.pages.length,
                itemBuilder: (context, index) {
                  final page = onboardingProvider.pages[index];
                  return _buildOnboardingPage(context, page, index);
                },
              ),
            ),

            // Continue Button
            Container(
              padding: const EdgeInsets.all(20),
              child: Consumer<OnboardingProvider>(
                builder: (context, onboardingProvider, child) {
                  return CommonWidgets.buildGradientButton(
                    text: onboardingProvider.isLastPage
                        ? 'Get Started'
                        : 'Continue',
                    onPressed: () {
                      onboardingProvider.nextPage();
                      if (onboardingProvider.isLastPage) {
                        _navigateAfterOnboarding(context);
                      }
                    },
                  );
                },
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

  Widget _buildOnboardingPage(
      BuildContext context, OnboardingPage page, int index) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          // Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
          )
              .animate()
              .fadeIn(delay: 200.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0),

          const SizedBox(height: 20),

          // Description
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
          )
              .animate()
              .fadeIn(delay: 400.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0),

          const SizedBox(height: 60),

          // // Illustration
          // _buildIllustration(context, index).animate()
          //   .fadeIn(delay: 600.ms, duration: 800.ms)
          //   .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0)),
          Image.asset(page.imagePath),
        ],
        ),
      ),
    );
  }
}
