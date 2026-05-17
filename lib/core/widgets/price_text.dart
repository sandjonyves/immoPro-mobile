import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';

class PriceText extends StatelessWidget {
  final double montant;
  final TextStyle? style;

  const PriceText({super.key, required this.montant, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      Formatters.prix(montant),
      style: style ?? AppTextStyles.syneTitle(context, size: 15),
    );
  }
}
