import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bbpool/config/app_config.dart';

class OnboardingProvider with ChangeNotifier {
  int _currentPage = 0;
  bool _isLastPage = false;

  int get currentPage => _currentPage;
  bool get isLastPage => _isLastPage;

  final List<OnboardingPage> pages = [
    OnboardingPage(
      title: "Connect and easily manage\nyour child's school runs",
      description: "Easily chat, manage schedules, and build\ntrusted carpools with your school community.",
      imagePath: 'assets/images/onboarding1.png', // Update path as needed
    ),
    OnboardingPage(
      title: "Track Every Ride in\nReal-Time",
      description: "Stay informed with live GPS tracking, ETA updates,\nand instant ride alerts.",
      imagePath: 'assets/images/onboarding2.png', // Update path as needed
    ),
    OnboardingPage(
      title: "Safe Rides.\nHappy Kids.\nConfident Parents.",
      description: "Your child's safety is our top priority with verified drivers\nand real-time monitoring.",
      imagePath: 'assets/images/onboarding3.png', // Update path as needed
    ),
  ];

  void initialize() {
    updatePageStatus();
  }

  void nextPage() {
    if (_currentPage < pages.length - 1) {
      _currentPage++;
      updatePageStatus();
      notifyListeners();
    } else {
      completeOnboarding();
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      updatePageStatus();
      notifyListeners();
    }
  }

  void skipOnboarding() {
    completeOnboarding();
  }

  void goToPage(int page) {
    if (page >= 0 && page < pages.length) {
      _currentPage = page;
      updatePageStatus();
      notifyListeners();
    }
  }

  void updatePageStatus() {
    _isLastPage = _currentPage == pages.length - 1;
  }

  Future<void> completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConfig.onboardingCompletedKey, true);
      debugPrint('Onboarding marked as completed');
      // Navigation will be handled by the UI
    } catch (e) {
      debugPrint('Error completing onboarding: $e');
    }
  }

  OnboardingPage get currentPageData => pages[_currentPage];
}

class OnboardingPage {
  final String title;
  final String description;
  final String imagePath;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}
