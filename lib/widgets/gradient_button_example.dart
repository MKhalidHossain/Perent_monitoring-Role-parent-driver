import 'package:flutter/material.dart';
import 'package:bbpool/widgets/common_widgets.dart';

/// Example usage of the reusable gradient button
/// 
/// This button uses a linear gradient from #E9CCE2 to #909EDB
/// and can be used throughout the entire app.
class GradientButtonExample extends StatelessWidget {
  const GradientButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gradient Button Examples'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            
            // Basic usage - Full width button
            const Text(
              'Basic Usage (Full Width):',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            CommonWidgets.buildGradientButton(
              text: 'Continue',
              onPressed: () {
                debugPrint('Continue button pressed');
              },
            ),
            
            const SizedBox(height: 30),
            
            // Custom width button
            const Text(
              'Custom Width:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: CommonWidgets.buildGradientButton(
                text: 'Login',
                width: 200,
                onPressed: () {
                  debugPrint('Login button pressed');
                },
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Custom styling
            const Text(
              'Custom Styling:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            CommonWidgets.buildGradientButton(
              text: 'Sign Up',
              onPressed: () {
                debugPrint('Sign Up button pressed');
              },
              height: 50,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              textColor: Colors.white,
              borderRadius: 25,
            ),
            
            const SizedBox(height: 30),
            
            // Small button
            const Text(
              'Small Button:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: CommonWidgets.buildGradientButton(
                text: 'Skip',
                width: 100,
                height: 40,
                fontSize: 14,
                onPressed: () {
                  debugPrint('Skip button pressed');
                },
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Custom padding
            const Text(
              'Custom Padding:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            CommonWidgets.buildGradientButton(
              text: 'Get Started',
              onPressed: () {
                debugPrint('Get Started button pressed');
              },
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              borderRadius: 30,
            ),
          ],
        ),
      ),
    );
  }
}
