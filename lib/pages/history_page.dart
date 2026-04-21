import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/day.dart';
import '../providers/day_provider.dart';
import '../theme/brutalist_theme.dart';
import '../widgets/skeleton.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: MonoDecor.pagePadding,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(MonoSpacing.sm),
                      decoration: BoxDecoration(
                        border: Border.all(color: MonoColors.border, width: 2),
                      ),
                      child: const Icon(Icons.arrow_back, color: MonoColors.amber, size: 22),
                    ),
                  ),
                  Gap.hBase,
                  Text(
                    'HISTORY',
                    style: MonoText.h2.copyWith(color: MonoColors.amber),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Day>>(
                future: context.read<DayProvider>().fetchHistory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const HistorySkeleton();
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('ERROR: ${snapshot.error}', style: MonoText.body));
                  }

                  final days = snapshot.data ?? [];

                  if (days.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('NO LOGS FOUND', style: MonoText.h2),
                          Gap.md,
                          Text('KEEP WORKING TO SEE YOUR HISTORY.', style: MonoText.label.copyWith(color: MonoColors.textSecondary)),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(MonoSpacing.base),
                    itemCount: days.length,
                    separatorBuilder: (context, index) => Gap.md,
                    itemBuilder: (context, index) {
                      final day = days[index];
                      return _HistoryCard(day: day);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final Day day;

  const _HistoryCard({required this.day});

  IconData _getMoodIcon(int? mood) {
    switch (mood) {
      case 1: return Icons.sentiment_very_dissatisfied;
      case 2: return Icons.sentiment_dissatisfied;
      case 3: return Icons.sentiment_neutral;
      case 4: return Icons.sentiment_satisfied;
      case 5: return Icons.sentiment_very_satisfied;
      default: return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = day.dateTime;
    final isToday = DateFormat('yyyy-MM-dd').format(date) == 
                    DateFormat('yyyy-MM-dd').format(DateTime.now());

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/history-detail', arguments: day);
      },
      child: Container(
        decoration: isToday ? MonoDecor.cardAccent() : MonoDecor.card(),
        padding: const EdgeInsets.all(MonoSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEEE').format(date).toUpperCase(),
                    style: MonoText.labelSm.copyWith(color: MonoColors.amber),
                  ),
                  Text(
                    DateFormat('MMMM dd, yyyy').format(date).toUpperCase(),
                    style: MonoText.h2,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bedtime_outlined, size: 14, color: MonoColors.textSecondary),
                    Gap.hXs,
                    Text(
                      day.sleepHours != null ? '${day.sleepHours}H' : '—',
                      style: MonoText.numberSm,
                    ),
                  ],
                ),
                Gap.xs,
                if (day.mood != null)
                  Icon(
                    _getMoodIcon(day.mood),
                    color: MonoColors.textSecondary,
                    size: 20,
                  )
                else
                  Text('—', style: MonoText.bodySm.copyWith(color: MonoColors.textMuted)),
              ],
            ),
            Gap.hMd,
            const Icon(Icons.chevron_right, color: MonoColors.amber),
          ],
        ),
      ),
    );
  }
}
