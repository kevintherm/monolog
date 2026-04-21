import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/day_provider.dart';
import '../theme/brutalist_theme.dart';

class MoodInput extends StatelessWidget {
  final bool readOnly;
  const MoodInput({super.key, this.readOnly = false});

  static const List<IconData> _icons = [
    Icons.sentiment_very_dissatisfied,  
    Icons.sentiment_dissatisfied,
    Icons.sentiment_neutral,
    Icons.sentiment_satisfied,
    Icons.sentiment_very_satisfied
  ];
  static const List<String> _labels = ['AWFUL', 'BAD', 'OK', 'GOOD', 'GREAT'];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DayProvider>();
    final currentMood = provider.today?.mood;

    return Container(
      decoration: MonoDecor.card(),
      padding: MonoDecor.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_emotions_outlined, color: MonoColors.amber, size: 22),
              Gap.hSm,
              Text('MOOD', style: MonoText.label.copyWith(color: MonoColors.amber)),
            ],
          ),
          Gap.md,
          Row(
            children: List.generate(5, (index) {
              final mood = index + 1;
              final isSelected = currentMood == mood;

              return Expanded(
                child: GestureDetector(
                  onTap: readOnly ? null : () => provider.updateMood(mood),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: EdgeInsets.only(right: index < 4 ? MonoSpacing.xs : 0),
                    padding: const EdgeInsets.symmetric(vertical: MonoSpacing.sm),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? MonoColors.amber
                          : MonoColors.surfaceHigh,
                      border: Border.all(
                        color: isSelected ? MonoColors.amberDark : MonoColors.border,
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              const BoxShadow(
                                color: Colors.black38,
                                offset: Offset(2, 2),
                                blurRadius: 0,
                              )
                            ]
                          : [],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _icons[index],
                          size: 28,
                          color: isSelected ? Colors.black : MonoColors.textSecondary,
                        ),
                        Gap.xs,
                        Text(
                          _labels[index],
                          style: MonoText.labelSm.copyWith(
                            color: isSelected ? Colors.black : MonoColors.textMuted,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
