import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:bbpool/config/app_colors.dart';
import 'package:bbpool/providers/auth_provider.dart';
import 'package:bbpool/routes/app_routes.dart';
import 'package:email_otp/email_otp.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late EmailOTP myAuth;
  String userEmail = '';
  String otpCode = '';
  bool showSuccessModal = false;
  int resendCountdown = 60;
  bool canResend = false;

  @override
  void initState() {
    super.initState();
    myAuth = EmailOTP();
    _getUserEmail();
    _sendInitialOTP();
    _startResendTimer();
  }

  void _getUserEmail() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    userEmail = authProvider.email;
    debugPrint('User email for OTP: $userEmail');
  }

  void _sendInitialOTP() async {
    if (userEmail.isNotEmpty) {
      // Use static method to send OTP
      if (await EmailOTP.sendOTP(email: userEmail) == true) {
            debugPrint('User email for OTP: $userEmail');
            debugPrint('Initial OTP sent successfully');
      } else {
        debugPrint('Failed to send initial OTP');
      }
    }
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && resendCountdown > 0) {
        setState(() {
          resendCountdown--;
        });
        _startResendTimer();
      } else if (mounted) {
        setState(() {
          canResend = true;
        });
      }
    });
  }

  void _handleOTPComplete(String otp) async {
    otpCode = otp;
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Update OTP in provider
    authProvider.updateOtp(otp);
    
    // Verify OTP
    if (otp.length == 6) {
      await authProvider.verifyOtp(context);
      
      if (authProvider.model.isLoggedIn && mounted) {
        setState(() {
          showSuccessModal = true;
        });
      } else if (mounted && authProvider.errorMessage.isNotEmpty) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _handleVerifyClick() async {
    if (otpCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 6-digit OTP'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.updateOtp(otpCode);
    await authProvider.verifyOtp(context);
    
    if (authProvider.model.isLoggedIn && mounted) {
      setState(() {
        showSuccessModal = true;
      });
    } else if (mounted && authProvider.errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _handleResendOTP() async {
    if (!canResend) return;
    
    if (userEmail.isNotEmpty) {
      setState(() {
        canResend = false;
        resendCountdown = 60;
      });
      
      if (await EmailOTP.sendOTP(email: userEmail) == true) {
        debugPrint('Resent OTP to: $userEmail');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP resent successfully'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
      
      _startResendTimer();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.backgroundGradient,
            ),
            child: SafeArea(
              child: Column(
            children: [
              // Status Bar
        
              // Back Button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              // Background Content
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Phone Illustration
                      _buildPhoneIllustration(context)
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 800.ms)
                          .scale(
                              begin: const Offset(0.8, 0.8),
                              end: const Offset(1.0, 1.0)),
                    ],
                  ),
                ),
              ),

              // OTP Verification Modal
              Expanded(
                flex: 3,
                child: Container(
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

                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 20),
                              
                              // Title
                              const Text(
                                'Enter Verification Code',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 8),
                              
                              // Subtitle
                              Text(
                                'We sent a verification code to\n$userEmail',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 40),
                              
                              // OTP Input Fields
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: PinCodeTextField(
                                  appContext: context,
                                  length: 6,
                                  obscureText: false,
                                  animationType: AnimationType.fade,
                                  pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.box,
                                    borderRadius: BorderRadius.circular(10),
                                    fieldHeight: 60,
                                    fieldWidth: 45,
                                    activeFillColor: AppColors.cardBackground,
                                    activeColor: AppColors.primary,
                                    selectedColor: AppColors.primary,
                                    inactiveColor: AppColors.inputBorder,
                                    inactiveFillColor: AppColors.inputBackground,
                                  ),
                                  keyboardType: TextInputType.number,
                                  enableActiveFill: true,
                                  onCompleted: _handleOTPComplete,
                                  onChanged: (value) {
                                    otpCode = value;
                                  },
                                ),
                              ),
                              
                              const SizedBox(height: 40),
                              
                              // Verify Button
                              SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _handleVerifyClick,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Verify',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textWhite,
                                    ),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Resend OTP
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                 const Text(
                                    "Didn't receive the code? ",
                                    style:  TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: canResend ? _handleResendOTP : null,
                                    child: Text(
                                      canResend ? 'Resend' : 'Resend in ${resendCountdown}s',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: canResend ? AppColors.primary : AppColors.textSecondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Success Modal
      if (showSuccessModal) _buildSuccessModal(),
        ],
      ),
    );
  }

  Widget _buildSuccessModal() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          showSuccessModal = false;
                        });
                        // Navigate to login screen
                        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                      },
                      icon: const Icon(Icons.close),
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Success Icon
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer circles
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                    ),
                    // Inner checkmark
                    Container(
                      width: 80,
                      height: 80,
                      decoration:const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: AppColors.textWhite,
                        size: 50,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 30),
                
                // Title
                const Text(
                  'Success!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Message
                const Text(
                  'Congratulations! You have successfully verified the OTP',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 30),
                
                // Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showSuccessModal = false;
                      });
                      // Navigate to login screen
                      Navigator.of(context).pushReplacementNamed(
                        AppRoutes.login,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textWhite,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneIllustration(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 200,
      child: Stack(
        children: [
          // Phone
          Positioned(
            left: 50,
            top: 50,
            child: Container(
              width: 100,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF1A1A1A), width: 2),
              ),
              child: Stack(
                children: [
                  // Screen
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Container(
                      width: 84,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  // Home button
                  Positioned(
                    left: 40,
                    bottom: 8,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2C),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFF1A1A1A), width: 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Message bubbles
          Positioned(
            right: 20,
            top: 80,
            child: Container(
              width: 60,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF4A4A4A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 15,
                    top: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF87CEEB),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 15,
                    top: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF87CEEB),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 25,
                    top: 20,
                    child: Container(
                      width: 10,
                      height: 2,
                      decoration: BoxDecoration(
                        color: const Color(0xFF87CEEB),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating elements
          Positioned(
            left: 20,
            top: 100,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            right: 40,
            top: 150,
            child: Container(
              width: 15,
              height: 15,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            left: 30,
            top: 200,
            child: Container(
              width: 25,
              height: 25,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

}

