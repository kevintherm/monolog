import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/brutalist_theme.dart';

class SetInputRow extends StatelessWidget {
  final int index;
  final TextEditingController repsController;
  final TextEditingController weightController;
  final VoidCallback onDelete;

  const SetInputRow({
    super.key,
    required this.index,
    required this.repsController,
    required this.weightController,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: MonoSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: MonoColors.amber.withValues(alpha: 0.15),
              border: Border.all(color: MonoColors.amber, width: 1),
            ),
            child: Text(
              '${index + 1}',
              style: MonoText.labelSm.copyWith(color: MonoColors.amber),
            ),
          ),
          Gap.hSm,

          Expanded(
            child: TextField(
              controller: repsController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
              style: MonoText.numberSm,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'REPS',
                hintStyle: MonoText.labelSm.copyWith(color: MonoColors.textMuted),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: MonoSpacing.sm,
                  vertical: MonoSpacing.sm,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: MonoSpacing.sm),
            child: Text('×', style: MonoText.h3.copyWith(color: MonoColors.textSecondary)),
          ),

          Expanded(
            child: TextField(
              controller: weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d{0,4}\.?\d{0,1}')),
              ],
              textAlign: TextAlign.center,
              style: MonoText.numberSm,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'KG',
                hintStyle: MonoText.labelSm.copyWith(color: MonoColors.textMuted),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: MonoSpacing.sm,
                  vertical: MonoSpacing.sm,
                ),
              ),
            ),
          ),

          Gap.hSm,

          GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: MonoColors.danger.withValues(alpha: 0.1),
                border: Border.all(color: MonoColors.danger.withValues(alpha: 0.4), width: 1),
              ),
              child: Icon(Icons.close, color: MonoColors.danger, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
