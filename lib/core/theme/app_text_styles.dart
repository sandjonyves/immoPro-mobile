import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  static TextStyle syneHeading(BuildContext context, {double size = 22}) {
    final dark = AppColors.isDark(context);
    return GoogleFonts.syne(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: dark ? AppColors.textPrimaryD : AppColors.textPrimaryL,
    );
  }

  static TextStyle syneTitle(BuildContext context, {double size = 16}) {
    final dark = AppColors.isDark(context);
    return GoogleFonts.syne(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: dark ? AppColors.textPrimaryD : AppColors.textPrimaryL,
    );
  }

  static TextStyle interBody(BuildContext context, {double size = 14}) {
    final dark = AppColors.isDark(context);
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: FontWeight.w400,
      color: dark ? AppColors.textSecondaryD : AppColors.textSecondaryL,
    );
  }

  static TextStyle interLabel(BuildContext context) {
    final dark = AppColors.isDark(context);
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: dark ? AppColors.textMutedD : AppColors.textMutedL,
    );
  }
}
