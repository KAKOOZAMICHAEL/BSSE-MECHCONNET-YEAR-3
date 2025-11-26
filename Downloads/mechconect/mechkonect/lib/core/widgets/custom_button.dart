import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_text_styles.dart';

enum ButtonType { primary, secondary, outline, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Widget buttonContent = isLoading
        ? SizedBox(
            height: AppDimensions.iconSizeMD,
            width: AppDimensions.iconSizeMD,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == ButtonType.primary ? Colors.white : AppColors.primary,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: AppDimensions.iconSizeMD),
                const SizedBox(width: AppDimensions.spacingSM),
              ],
              Text(
                text,
                style: _getTextStyle(isDark),
              ),
            ],
          );

    final buttonWidget = _buildButton(context, isDark, buttonContent);
    
    if (isFullWidth && width == null) {
      return SizedBox(
        width: double.infinity,
        height: height ?? AppDimensions.buttonHeightMedium,
        child: buttonWidget,
      );
    }
    
    if (width != null || height != null) {
      return SizedBox(
        width: width,
        height: height ?? AppDimensions.buttonHeightMedium,
        child: buttonWidget,
      );
    }
    
    return buttonWidget;
  }

  Widget _buildButton(BuildContext context, bool isDark, Widget content) {
    switch (type) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.primary,
            foregroundColor: textColor ?? Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingLG,
              vertical: AppDimensions.spacingMD,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            ),
          ),
          child: content,
        );

      case ButtonType.secondary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.secondary,
            foregroundColor: textColor ?? Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingLG,
              vertical: AppDimensions.spacingMD,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            ),
          ),
          child: content,
        );

      case ButtonType.outline:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: backgroundColor ?? AppColors.primary,
              width: 1.5,
            ),
            foregroundColor: textColor ?? (backgroundColor ?? AppColors.primary),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingLG,
              vertical: AppDimensions.spacingMD,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            ),
          ),
          child: content,
        );

      case ButtonType.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: textColor ?? AppColors.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingMD,
              vertical: AppDimensions.spacingSM,
            ),
          ),
          child: content,
        );
    }
  }

  TextStyle _getTextStyle(bool isDark) {
    switch (type) {
      case ButtonType.primary:
      case ButtonType.secondary:
        return AppTextStyles.buttonLarge(color: textColor ?? Colors.white);
      case ButtonType.outline:
      case ButtonType.text:
        return AppTextStyles.buttonMedium(
          color: textColor ?? AppColors.primary,
        );
    }
  }
}

