import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/day_provider.dart';
import '../theme/brutalist_theme.dart';
import 'brutalist_button.dart';

class MealSection extends StatelessWidget {
  const MealSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DayProvider>();
    final meals = provider.meals;
    final totalCalories = meals.fold<int>(0, (sum, m) => sum + m.calories);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.restaurant_outlined, color: MonoColors.amber, size: 22),
            Gap.hSm,
            Text('MEALS', style: MonoText.label.copyWith(color: MonoColors.amber)),
            const Spacer(),
            if (meals.isNotEmpty)
              Text(
                '$totalCalories CAL',
                style: MonoText.numberSm.copyWith(color: MonoColors.textSecondary),
              ),
          ],
        ),
        Gap.md,
        if (meals.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(MonoSpacing.xl),
            decoration: MonoDecor.card(),
            child: Text(
              'No meals logged yet',
              textAlign: TextAlign.center,
              style: MonoText.body.copyWith(color: MonoColors.textMuted),
            ),
          )
        else
          ...meals.map((meal) => Padding(
                padding: const EdgeInsets.only(bottom: MonoSpacing.sm),
                child: Dismissible(
                  key: Key(meal.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: MonoSpacing.base),
                    color: MonoColors.danger,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => provider.deleteMeal(meal.id),
                  child: Container(
                    width: double.infinity,
                    padding: MonoDecor.cardPadding,
                    decoration: MonoDecor.card(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(meal.name, style: MonoText.h3),
                        ),
                        Text(
                          '${meal.calories}',
                          style: MonoText.numberSm.copyWith(color: MonoColors.amber),
                        ),
                        Gap.hXs,
                        Text(
                          'CAL',
                          style: MonoText.labelSm.copyWith(color: MonoColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        Gap.md,
        TileButton(
          label: 'Add Meal',
          icon: Icons.add,
          color: MonoColors.amberLight,
          onPressed: () => Navigator.pushNamed(context, '/add-meal'),
        ),
      ],
    );
  }
}
