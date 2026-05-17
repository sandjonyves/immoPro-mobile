import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

enum AppButtonVariant { primary, secondary, ghost }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool loading;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final dark = AppColors.isDark(context);
    switch (variant) {
      case AppButtonVariant.primary:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: loading ? null : onPressed,
            child: loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(label),
          ),
        );
      case AppButtonVariant.secondary:
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: loading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor:
                  dark ? AppColors.primaryDark : AppColors.primaryLight,
              side: BorderSide(
                color: dark ? AppColors.primaryDark : AppColors.primaryLight,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusBtn),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(label),
          ),
        );
      case AppButtonVariant.ghost:
        return TextButton(
          onPressed: loading ? null : onPressed,
          child: Text(label),
        );
    }
  }
}
