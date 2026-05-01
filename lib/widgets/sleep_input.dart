import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/day_provider.dart';
import '../theme/brutalist_theme.dart';

class SleepInput extends StatefulWidget {
  final bool readOnly;
  const SleepInput({super.key, this.readOnly = false});

  @override
  State<SleepInput> createState() => _SleepInputState();
}

class _SleepInputState extends State<SleepInput> {
  double? _localHours;
  Timer? _debounceTimer;

  void _onHoursChanged(double newHours) {
    setState(() {
      _localHours = newHours;
    });

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted && _localHours != null) {
        context.read<DayProvider>().updateSleepHours(_localHours!);
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DayProvider>();
    final serverHours = provider.today?.sleepHours;

    final hours = (_debounceTimer?.isActive ?? false)
        ? (_localHours ?? serverHours)
        : serverHours;

    return Container(
      decoration: MonoDecor.card(),
      padding: MonoDecor.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bedtime_outlined,
                color: MonoColors.amber,
                size: 22,
              ),
              Gap.hSm,
              Text(
                'SLEEP',
                style: MonoText.label.copyWith(color: MonoColors.amber),
              ),
            ],
          ),
          Gap.md,
          Row(
            children: [
              if (!widget.readOnly)
                _LargeStepperButton(
                  icon: Icons.remove,
                  onPressed: () {
                    final current = hours ?? 0.0;
                    if (current > 0) {
                      _onHoursChanged(
                        (current - 0.5).clamp(0.0, double.infinity),
                      );
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
                      style: MonoText.labelSm.copyWith(
                        color: MonoColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (!widget.readOnly)
                _LargeStepperButton(
                  icon: Icons.add,
                  onPressed: () {
                    final current = hours ?? 0.0;
                    _onHoursChanged(
                      (current + 0.5).clamp(0.0, double.infinity),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LargeStepperButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _LargeStepperButton({required this.icon, required this.onPressed});

  @override
  State<_LargeStepperButton> createState() => _LargeStepperButtonState();
}

class _LargeStepperButtonState extends State<_LargeStepperButton> {
  Timer? _timer;

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      widget.onPressed();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MonoColors.surfaceHigh,
      child: GestureDetector(
        onLongPressStart: (_) => _startTimer(),
        onLongPressEnd: (_) => _stopTimer(),
        onLongPressCancel: () => _stopTimer(),
        child: InkWell(
          onTap: widget.onPressed,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: MonoColors.amber, width: 2),
            ),
            child: Icon(widget.icon, color: MonoColors.amber, size: 28),
          ),
        ),
      ),
    );
  }
}
