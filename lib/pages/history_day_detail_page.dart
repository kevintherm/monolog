import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/day.dart';
import '../providers/day_provider.dart';
import '../theme/brutalist_theme.dart';
import '../widgets/meal_section.dart';
import '../widgets/workout_section.dart';
import '../widgets/sleep_input.dart';
import '../widgets/mood_input.dart';
import '../widgets/skeleton.dart';

class HistoryDayDetailPage extends StatefulWidget {
  final Day day;
  const HistoryDayDetailPage({super.key, required this.day});

  @override
  State<HistoryDayDetailPage> createState() => _HistoryDayDetailPageState();
}

class _HistoryDayDetailPageState extends State<HistoryDayDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DayProvider>().loadDay(widget.day);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DayProvider>();
    final dateStr = DateFormat('EEEE, MMM dd').format(widget.day.dateTime).toUpperCase();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await context.read<DayProvider>().loadToday();
        if (context.mounted) Navigator.pop(context);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: MonoDecor.pagePadding,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final nav = Navigator.of(context);
                        await context.read<DayProvider>().loadToday();
                        nav.pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(MonoSpacing.sm),
                        decoration: BoxDecoration(
                          border: Border.all(color: MonoColors.border, width: 2),
                        ),
                        child: const Icon(Icons.arrow_back, color: MonoColors.amber, size: 22),
                      ),
                    ),
                    Gap.hBase,
                    Expanded(
                      child: Text(
                        dateStr,
                        style: MonoText.h2.copyWith(color: MonoColors.amber),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: provider.loading 
                  ? const HomeSkeleton()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(MonoSpacing.base),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'HISTORICAL LOG',
                            style: MonoText.labelSm.copyWith(color: MonoColors.textMuted),
                          ),
                          Text(
                            DateFormat('yyyy').format(widget.day.dateTime),
                            style: MonoText.display,
                          ),
                          Gap.xl,
                          const MoodInput(readOnly: true),
                          Gap.lg,
                          const SleepInput(readOnly: true),
                          Gap.xl,
                          const MealSection(readOnly: true),
                          Gap.xl,
                          const WorkoutSection(readOnly: true),
                          Gap.xxl,
                          Center(
                            child: Text(
                              'LOGGED ON ${DateFormat('MMM dd HH:mm').format(widget.day.updatedAt)}',
                              style: MonoText.labelSm.copyWith(color: MonoColors.textMuted),
                            ),
                          ),
                          Gap.xl,
                        ],
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
