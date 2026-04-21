import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/day_provider.dart';
import '../theme/brutalist_theme.dart';
import '../config.dart';
import 'brutalist_button.dart';
import 'confirm_bottom_sheet.dart';

class MealSection extends StatelessWidget {
  final bool readOnly;
  const MealSection({super.key, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DayProvider>();
    final meals = provider.meals;
    final totalCalories = meals.fold<int>(0, (sum, m) => sum + m.calories);
    final totalProtein = meals.fold<int>(0, (sum, m) => sum + m.protein);

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$totalCalories CAL',
                    style: MonoText.numberSm.copyWith(color: MonoColors.textSecondary),
                  ),
                  Text(
                    '${totalProtein}G PROTEIN',
                    style: MonoText.labelSm.copyWith(color: MonoColors.textMuted, fontSize: 9),
                  ),
                ],
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
                  direction: readOnly ? DismissDirection.none : DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await ConfirmBottomSheet.show(
                      context,
                      title: 'DELETE MEAL',
                      message: 'Are you sure you want to remove this meal?',
                      confirmLabel: 'DELETE',
                    );
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: MonoSpacing.base),
                    color: MonoColors.danger,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => provider.deleteMeal(meal.id),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(MonoSpacing.sm),
                      decoration: MonoDecor.card(),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(color: MonoColors.border, width: 2),
                              image: meal.image.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(
                                        () {
                                          String url = meal.image;
                                          if (!url.startsWith('http')) {
                                            url = '${AppConfig.apiUrl}/api/files/${AppConfig.mealsCollection}/${meal.id}/${meal.image}';
                                          }
                                          if (!kIsWeb && Platform.isAndroid) {
                                            url = url.replaceFirst('monolog.localhost', '10.0.2.2');
                                          }
                                          return url;
                                        }(),
                                        headers: {
                                          if (!kIsWeb && Platform.isAndroid) 'Host': AppConfig.domain,
                                        },
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: meal.image.isEmpty
                                ? const Icon(Icons.restaurant, color: MonoColors.textMuted, size: 20)
                                : null,
                          ),
                          Gap.hBase,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(meal.name, style: MonoText.h3, overflow: TextOverflow.ellipsis),
                                Row(
                                  children: [
                                    Text(
                                      '${meal.protein}g',
                                      style: MonoText.labelSm.copyWith(color: MonoColors.amber),
                                    ),
                                    Gap.hXs,
                                    Text(
                                      'PROTEIN',
                                      style: MonoText.labelSm.copyWith(color: MonoColors.textMuted, fontSize: 9),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${meal.calories}',
                                style: MonoText.numberSm.copyWith(color: MonoColors.textPrimary),
                              ),
                              Text(
                                'CAL',
                                style: MonoText.labelSm.copyWith(color: MonoColors.textMuted, fontSize: 9),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ),
              )),
        if (!readOnly) ...[
          Gap.md,
          TileButton(
            label: 'Add Meal',
            icon: Icons.add,
            variant: BrutalistButtonVariant.primary,
            onPressed: () => Navigator.pushNamed(context, '/add-meal'),
          ),
        ],
      ],
    );
  }
}
