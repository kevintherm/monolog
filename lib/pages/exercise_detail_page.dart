import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../providers/day_provider.dart';
import '../theme/brutalist_theme.dart';
import '../widgets/brutalist_button.dart';
import '../widgets/set_input_row.dart';

class ExerciseDetailPage extends StatefulWidget {
  const ExerciseDetailPage({super.key});

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  final _exerciseController = TextEditingController();
  final List<TextEditingController> _repsControllers = [];
  final List<TextEditingController> _weightControllers = [];

  Workout? _existingWorkout;
  Workout? _lastWeekWorkout;
  List<String> _previousExercises = [];
  bool _saving = false;
  bool _loadingLastWeek = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  void _init() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Workout) {
      _existingWorkout = args;
      _isEditing = true;
      _exerciseController.text = args.exercise;

      for (final set in args.sets) {
        _addSetRow(reps: set.reps, weight: set.weight);
      }
      _fetchLastWeek(args.exercise);
    } else {
      _addSetRow();
    }

    context.read<DayProvider>().fetchPreviousExercises().then((names) {
      if (mounted) setState(() => _previousExercises = names);
    });
  }

  void _addSetRow({int? reps, double? weight}) {
    setState(() {
      _repsControllers.add(TextEditingController(text: reps?.toString() ?? ''));
      _weightControllers.add(
        TextEditingController(text: weight?.toStringAsFixed(0) ?? ''),
      );
    });
  }

  void _removeSetRow(int index) {
    setState(() {
      _repsControllers[index].dispose();
      _weightControllers[index].dispose();
      _repsControllers.removeAt(index);
      _weightControllers.removeAt(index);
    });
  }

  Future<void> _fetchLastWeek(String exerciseName) async {
    if (exerciseName.isEmpty) return;
    setState(() => _loadingLastWeek = true);
    final result = await context.read<DayProvider>().fetchLastWeekExercise(exerciseName);
    if (mounted) {
      setState(() {
        _lastWeekWorkout = result;
        _loadingLastWeek = false;
      });
    }
  }

  List<ExerciseSet> _collectSets() {
    final sets = <ExerciseSet>[];
    for (int i = 0; i < _repsControllers.length; i++) {
      final reps = int.tryParse(_repsControllers[i].text);
      final weight = double.tryParse(_weightControllers[i].text);
      if (reps != null && weight != null) {
        sets.add(ExerciseSet(reps: reps, weight: weight));
      }
    }
    return sets;
  }

  Future<void> _save() async {
    final exercise = _exerciseController.text.trim();
    final sets = _collectSets();
    if (exercise.isEmpty || sets.isEmpty) return;

    setState(() => _saving = true);
    final provider = context.read<DayProvider>();

    if (_isEditing && _existingWorkout != null) {
      await provider.updateWorkoutSets(_existingWorkout!.id, sets);
    } else {
      await provider.addWorkout(exercise, sets);
    }

    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    if (_existingWorkout == null) return;
    
    // Simple confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: MonoColors.surface,
        title: Text('DELETE EXERCISE', style: MonoText.h2),
        content: Text('Are you sure you want to remove this exercise?', style: MonoText.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('CANCEL', style: MonoText.label.copyWith(color: MonoColors.textSecondary)),
          ),
          BrutalistButton(
            label: 'DELETE',
            small: true,
            color: MonoColors.danger,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _saving = true);
      await context.read<DayProvider>().deleteWorkout(_existingWorkout!.id);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _exerciseController.dispose();
    for (final c in _repsControllers) {
      c.dispose();
    }
    for (final c in _weightControllers) {
      c.dispose();
    }
    super.dispose();
  }

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
                    _isEditing ? 'EDIT EXERCISE' : 'ADD EXERCISE',
                    style: MonoText.h2.copyWith(color: MonoColors.amber),
                  ),
                ],
              ),
            ),
            Gap.base,

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: MonoSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('EXERCISE NAME', style: MonoText.label.copyWith(color: MonoColors.textSecondary)),
                    Gap.md,
                    Container(
                      decoration: MonoDecor.card(),
                      padding: MonoDecor.cardPadding,
                      child: Autocomplete<String>(
                        initialValue: TextEditingValue(text: _exerciseController.text),
                        optionsBuilder: (value) {
                          if (value.text.isEmpty) return _previousExercises;
                          return _previousExercises.where(
                            (e) => e.toLowerCase().contains(value.text.toLowerCase()),
                          );
                        },
                        onSelected: (value) {
                          _exerciseController.text = value;
                          _fetchLastWeek(value);
                        },
                        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                          if (controller.text != _exerciseController.text) {
                            controller.text = _exerciseController.text;
                          }
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            style: MonoText.h3,
                            decoration: const InputDecoration(
                              hintText: 'e.g. Bench Press',
                              border: InputBorder.none,
                            ),
                            onChanged: (v) => _exerciseController.text = v,
                            onSubmitted: (_) {
                              onFieldSubmitted();
                              _fetchLastWeek(_exerciseController.text);
                            },
                          );
                        },
                        optionsViewBuilder: (context, onSelected, options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              color: MonoColors.surface,
                              child: Container(
                                width: MediaQuery.of(context).size.width - MonoSpacing.lg * 2,
                                constraints: const BoxConstraints(maxHeight: 200),
                                decoration: BoxDecoration(
                                  border: Border.all(color: MonoColors.border, width: 2),
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: options.length,
                                  itemBuilder: (context, index) {
                                    final option = options.elementAt(index);
                                    return InkWell(
                                      onTap: () => onSelected(option),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: MonoSpacing.base,
                                          vertical: MonoSpacing.md,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: MonoColors.border.withValues(alpha: 0.5),
                                            ),
                                          ),
                                        ),
                                        child: Text(option, style: MonoText.body),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Gap.xl,

                    if (_loadingLastWeek)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(MonoSpacing.base),
                        decoration: MonoDecor.card(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: MonoColors.amber,
                                strokeWidth: 2,
                              ),
                            ),
                            Gap.hSm,
                            Text('Loading last week...',
                                style: MonoText.bodySm.copyWith(color: MonoColors.textMuted)),
                          ],
                        ),
                      )
                    else if (_lastWeekWorkout != null) ...[
                      Text('LAST WEEK', style: MonoText.label.copyWith(color: MonoColors.textSecondary)),
                      Gap.md,
                      Container(
                        width: double.infinity,
                        padding: MonoDecor.cardPadding,
                        decoration: MonoDecor.card(borderColor: MonoColors.amberDark),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.history, color: MonoColors.amberDark, size: 18),
                                Gap.hSm,
                                Text(
                                  '${_lastWeekWorkout!.sets.length} set${_lastWeekWorkout!.sets.length == 1 ? '' : 's'}',
                                  style: MonoText.bodySm.copyWith(color: MonoColors.textSecondary),
                                ),
                              ],
                            ),
                            Gap.sm,
                            ..._lastWeekWorkout!.sets.asMap().entries.map((entry) {
                              final i = entry.key;
                              final s = entry.value;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: MonoSpacing.xs),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      child: Text(
                                        '${i + 1}.',
                                        style: MonoText.bodySm.copyWith(color: MonoColors.textMuted),
                                      ),
                                    ),
                                    Text(
                                      '${s.reps} reps × ${s.weight.toStringAsFixed(0)} kg',
                                      style: MonoText.numberSm.copyWith(
                                        color: MonoColors.textSecondary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      Gap.xl,
                    ],

                    Text('CURRENT SETS', style: MonoText.label.copyWith(color: MonoColors.textSecondary)),
                    Gap.md,
                    Container(
                      width: double.infinity,
                      padding: MonoDecor.cardPadding,
                      decoration: MonoDecor.card(),
                      child: Column(
                        children: [
                          ...List.generate(_repsControllers.length, (i) {
                            return SetInputRow(
                              index: i,
                              repsController: _repsControllers[i],
                              weightController: _weightControllers[i],
                              onDelete: () => _removeSetRow(i),
                            );
                          }),
                          Gap.sm,
                          BrutalistButton(
                            label: 'Add Set',
                            onPressed: () => _addSetRow(),
                            fullWidth: true,
                            small: true,
                            color: MonoColors.surfaceHigh,
                            textColor: MonoColors.amber,
                            icon: Icons.add,
                          ),
                        ],
                      ),
                    ),
                    Gap.xxl,

                    BrutalistButton(
                      label: _isEditing ? 'Update Exercise' : 'Save Exercise',
                      onPressed: _save,
                      fullWidth: true,
                      icon: Icons.check,
                      isLoading: _saving,
                    ),
                    if (_isEditing) ...[
                      Gap.xl,
                      BrutalistButton(
                        label: 'Delete Exercise',
                        onPressed: _delete,
                        fullWidth: true,
                        color: MonoColors.surfaceHigh,
                        textColor: MonoColors.danger,
                        icon: Icons.delete_outline,
                      ),
                    ],
                    Gap.xxxl,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
