import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/day_provider.dart';
import '../theme/brutalist_theme.dart';
import 'brutalist_button.dart';

class WorkoutSection extends StatelessWidget {
  const WorkoutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DayProvider>();
    final workouts = provider.workouts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.fitness_center, color: MonoColors.amber, size: 22),
            Gap.hSm,
            Text('WORKOUTS', style: MonoText.label.copyWith(color: MonoColors.amber)),
            const Spacer(),
            if (workouts.isNotEmpty)
              Text(
                '${workouts.length} EXERCISE${workouts.length == 1 ? '' : 'S'}',
                style: MonoText.labelSm.copyWith(color: MonoColors.textSecondary),
              ),
          ],
        ),
        Gap.md,
        if (workouts.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(MonoSpacing.xl),
            decoration: MonoDecor.card(),
            child: Text(
              'No exercises logged yet',
              textAlign: TextAlign.center,
              style: MonoText.body.copyWith(color: MonoColors.textMuted),
            ),
          )
        else
          ...workouts.map((workout) => Padding(
                padding: const EdgeInsets.only(bottom: MonoSpacing.sm),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/exercise-detail',
                    arguments: workout,
                  ),
                  child: Dismissible(
                    key: Key(workout.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: MonoSpacing.base),
                      color: MonoColors.danger,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) => provider.deleteWorkout(workout.id),
                    child: Container(
                      width: double.infinity,
                      padding: MonoDecor.cardPadding,
                      decoration: MonoDecor.card(),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(workout.exercise, style: MonoText.h3),
                                Gap.xs,
                                Text(
                                  workout.sets.map((s) => '${s.reps}×${s.weight.toStringAsFixed(0)}kg').join('  ·  '),
                                  style: MonoText.bodySm.copyWith(color: MonoColors.textSecondary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: MonoSpacing.sm,
                              vertical: MonoSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: MonoColors.amber.withValues(alpha: 0.15),
                              border: Border.all(color: MonoColors.amber, width: 1),
                            ),
                            child: Text(
                              '${workout.sets.length} SET${workout.sets.length == 1 ? '' : 'S'}',
                              style: MonoText.labelSm.copyWith(color: MonoColors.amber),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        Gap.md,
        TileButton(
          label: 'Add Exercise',
          icon: Icons.add,
          color: MonoColors.gold,
          onPressed: () => Navigator.pushNamed(context, '/exercise-detail'),
        ),
      ],
    );
  }
}
