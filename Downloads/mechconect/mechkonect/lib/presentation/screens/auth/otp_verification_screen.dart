import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phone;

  const OtpVerificationScreen({
    super.key,
    required this.phone,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _resendTimer = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    _focusNodes[0].requestFocus();
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _resendTimer--;
        if (_resendTimer <= 0) {
          _canResend = true;
        }
      });
      if (_resendTimer > 0) {
        _startResendTimer();
      }
    });
  }

  void _onOtpChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // Auto-submit when all fields are filled
    if (index == 5 && value.length == 1) {
      final otp = _controllers.map((c) => c.text).join();
      if (otp.length == 6) {
        _verifyOtp(otp);
      }
    }
  }

  Future<void> _verifyOtp(String otp) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Get registration data from provider (set during registration)
    final registrationData = authProvider.pendingRegistrationData;
    
    final success = await authProvider.verifyOtp(otp, registrationData: registrationData);

    if (!mounted) return;

    if (success && authProvider.isAuthenticated) {
      context.go('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'OTP verification failed'),
          backgroundColor: AppColors.error,
        ),
      );
      // Clear OTP fields
      for (var controller in _controllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  Future<void> _handleResend() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loginWithPhone(widget.phone);

    setState(() {
      _resendTimer = 60;
      _canResend = false;
    });
    _startResendTimer();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP resent successfully'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimensions.spacingXXL),
            Icon(
              Icons.phone_android,
              size: 64,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppDimensions.spacingLG),
            Text(
              'Enter Verification Code',
              style: AppTextStyles.h2(isDark: isDark),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingSM),
            Text(
              'We sent a 6-digit code to\n${widget.phone}',
              style: AppTextStyles.bodyMedium(isDark: isDark),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingXXL),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: AppTextStyles.h3(isDark: isDark),
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMD,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMD,
                        ),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) => _onOtpChanged(index, value),
                  ),
                );
              }),
            ),
            const SizedBox(height: AppDimensions.spacingXL),
            CustomButton(
              text: 'Verify',
              onPressed: authProvider.isLoading
                  ? null
                  : () {
                      final otp = _controllers.map((c) => c.text).join();
                      if (otp.length == 6) {
                        _verifyOtp(otp);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter complete OTP'),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    },
              isLoading: authProvider.isLoading,
            ),
            const SizedBox(height: AppDimensions.spacingLG),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't receive code? ",
                  style: AppTextStyles.bodyMedium(isDark: isDark),
                ),
                if (_canResend)
                  TextButton(
                    onPressed: _handleResend,
                    child: const Text('Resend'),
                  )
                else
                  Text(
                    'Resend in $_resendTimer s',
                    style: AppTextStyles.bodySmall(isDark: isDark),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

