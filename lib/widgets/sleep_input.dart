import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/day_provider.dart';
import '../theme/brutalist_theme.dart';

class SleepInput extends StatefulWidget {
  const SleepInput({super.key});

  @override
  State<SleepInput> createState() => _SleepInputState();
}

class _SleepInputState extends State<SleepInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DayProvider>();
    final hours = provider.today?.sleepHours;

    return Container(
      decoration: MonoDecor.card(),
      padding: MonoDecor.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bedtime_outlined, color: MonoColors.amber, size: 22),
              Gap.hSm,
              Text('SLEEP', style: MonoText.label.copyWith(color: MonoColors.amber)),
            ],
          ),
          Gap.md,
          Row(
            children: [
              _LargeStepperButton(
                icon: Icons.remove,
                onPressed: () {
                  final current = hours ?? 0;
                  if (current > 0) {
                    provider.updateSleepHours((current - 0.5).clamp(0, 24));
                  }
                },
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      hours != null ? hours.toStringAsFixed(1) : '—',
                      style: MonoText.number.copyWith(
                        fontSize: 32,
                        color: hours != null
                            ? MonoColors.textPrimary
                            : MonoColors.textMuted,
                      ),
                    ),
                    Text(
                      'HOURS',
                      style: MonoText.labelSm.copyWith(color: MonoColors.textSecondary),
                    ),
                  ],
                ),
              ),
              _LargeStepperButton(
                icon: Icons.add,
                onPressed: () {
                  final current = hours ?? 0;
                  if (current < 24) {
                    provider.updateSleepHours((current + 0.5).clamp(0, 24));
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LargeStepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _LargeStepperButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: MonoColors.surfaceHigh,
          border: Border.all(color: MonoColors.amber, width: 2),
        ),
        child: Icon(icon, color: MonoColors.amber, size: 28),
      ),
    );
  }
}
