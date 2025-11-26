import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';

class SosScreen extends StatelessWidget {
  const SosScreen({super.key});

  Future<void> _callEmergency(String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Services'),
        backgroundColor: AppColors.sosRed,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.sosRed.withOpacity(0.1),
              Colors.transparent,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingXL),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.sosRed,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.sosRed.withOpacity(0.5),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.emergency,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXXL),
                Text(
                  'Emergency Services',
                  style: AppTextStyles.h2(isDark: isDark),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spacingXL),
                CustomButton(
                  text: 'Call Police',
                  onPressed: () => _callEmergency('999'), // Update with actual number
                  backgroundColor: AppColors.sosRed,
                  isFullWidth: true,
                ),
                const SizedBox(height: AppDimensions.spacingMD),
                CustomButton(
                  text: 'Call Fire Brigade',
                  onPressed: () => _callEmergency('999'), // Update with actual number
                  backgroundColor: AppColors.sosRedDark,
                  isFullWidth: true,
                ),
                const SizedBox(height: AppDimensions.spacingXXL),
                Text(
                  'In case of emergency, use these numbers to contact emergency services.',
                  style: AppTextStyles.bodySmall(isDark: isDark),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

