import 'package:flutter/material.dart';
import '../theme/brutalist_theme.dart';
import 'brutalist_button.dart';

class ConfirmBottomSheet extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final BrutalistButtonVariant variant;

  const ConfirmBottomSheet({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'CONFIRM',
    this.cancelLabel = 'CANCEL',
    this.variant = BrutalistButtonVariant.danger,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'CONFIRM',
    String cancelLabel = 'CANCEL',
    BrutalistButtonVariant variant = BrutalistButtonVariant.danger,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: MonoColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      builder: (context) => ConfirmBottomSheet(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        variant: variant,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(MonoSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: MonoText.display.copyWith(
                color: MonoColors.amber,
                letterSpacing: 2,
              ),
            ),
            Gap.md,
            Text(
              message,
              style: MonoText.bodyLg.copyWith(color: MonoColors.textPrimary),
            ),
            Gap.xl,
            Row(
              children: [
                Expanded(
                  child: BrutalistButton(
                    label: cancelLabel,
                    variant: BrutalistButtonVariant.tonal,
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ),
                Gap.hBase,
                Expanded(
                  child: BrutalistButton(
                    label: confirmLabel,
                    variant: variant,
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ),
              ],
            ),
            Gap.base,
          ],
        ),
      ),
    );
  }
}
