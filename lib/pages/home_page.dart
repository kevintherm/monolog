import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/day_provider.dart';
import '../services/veloquent_service.dart';
import '../theme/brutalist_theme.dart';
import '../widgets/sleep_input.dart';
import '../widgets/meal_section.dart';
import '../widgets/workout_section.dart';
import '../widgets/mood_input.dart';
import '../widgets/skeleton.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DayProvider>().loadToday();
    });
  }

  Future<void> _refresh() async {
    await context.read<DayProvider>().loadToday();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DayProvider>();
    final today = DateFormat('EEEE, MMMM d').format(DateTime.now());

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          color: MonoColors.amber,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: MonoDecor.pagePadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap.base,
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/logo-sm.png',
                                  height: 32,
                                ),
                                Gap.xs,
                                Text(
                                  today.toUpperCase(),
                                  style: MonoText.label.copyWith(color: MonoColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/history'),
                            child: Container(
                              padding: const EdgeInsets.all(MonoSpacing.sm),
                              decoration: BoxDecoration(
                                border: Border.all(color: MonoColors.border, width: 2),
                              ),
                              child: const Icon(
                                Icons.history,
                                color: MonoColors.amber,
                                size: 22,
                              ),
                            ),
                          ),
                          Gap.hSm,
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/profile'),
                            child: Container(
                              padding: const EdgeInsets.all(MonoSpacing.sm),
                              decoration: BoxDecoration(
                                border: Border.all(color: MonoColors.border, width: 2),
                              ),
                              child: const Icon(
                                Icons.person_outline,
                                color: MonoColors.amber,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap.xl,
                    ],
                  ),
                ),
              ),

              if (provider.loading)
                const SliverFillRemaining(
                  child: HomeSkeleton(),
                )
              else if (provider.error != null)
                SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: MonoDecor.pagePadding,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline, color: MonoColors.danger, size: 48),
                          Gap.base,
                          Text(
                            provider.error!,
                            style: MonoText.body.copyWith(color: MonoColors.danger),
                            textAlign: TextAlign.center,
                          ),
                          Gap.xl,
                          GestureDetector(
                            onTap: _refresh,
                            child: Text(
                              'TAP TO RETRY',
                              style: MonoText.label.copyWith(color: MonoColors.amber),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else ...[
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: MonoSpacing.lg),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SleepInput(),
                      Gap.xl,

                      const MoodInput(),
                      Gap.xl,

                      const MealSection(),
                      Gap.xl,

                      const WorkoutSection(),
                      Gap.xxxl,

                      Center(
                        child: Text(
                          'LOGGED IN AS ${VeloquentService.instance.currentUser?['name']?.toString().toUpperCase() ?? 'USER'}',
                          style: MonoText.labelSm.copyWith(color: MonoColors.textMuted),
                        ),
                      ),
                      Gap.xl,
                    ]),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
