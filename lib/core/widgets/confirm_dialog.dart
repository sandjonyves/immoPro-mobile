import 'package:flutter/material.dart';

Future<bool?> confirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String cancelLabel = 'Annuler',
  String confirmLabel = 'Confirmer',
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(cancelLabel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
}
