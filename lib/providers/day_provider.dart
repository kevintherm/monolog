import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config.dart';
import '../models/day.dart';
import '../models/meal.dart';
import '../models/workout.dart';
import '../services/veloquent_service.dart';

class DayProvider extends ChangeNotifier {
  final _service = VeloquentService.instance;

  Day? _today;
  Day? get today => _today;

  List<Meal> _meals = [];
  List<Meal> get meals => _meals;

  List<Workout> _workouts = [];
  List<Workout> get workouts => _workouts;

  bool _loading = false;
  bool get loading => _loading;

  String? _userId;
  String? get userId => _userId;

  String? _error;
  String? get error => _error;

  Future<void> loadToday() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final profile = await _service.me();
      _userId = profile['id'] as String;

      final dateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final result = await _service.sdk.records.list(
        AppConfig.daysCollection,
        filter: 'date = "$dateStr" && user = "$_userId"',
      );

      if (result.data.isNotEmpty) {
        _today = Day.fromRecord(result.data.first);
      } else {
        final created = await _service.sdk.records.create(
          AppConfig.daysCollection,
          {'date': dateStr, 'user': _userId},
        );
        _today = Day.fromRecord(created);
      }

      await Future.wait([_loadMeals(), _loadWorkouts()]);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> _loadMeals() async {
    if (_today == null) return;
    final result = await _service.sdk.records.list(
      AppConfig.mealsCollection,
      filter: 'day = "${_today!.id}" && user = "$_userId"',
    );
    _meals = result.data.map((r) => Meal.fromRecord(r)).toList();
  }

  Future<void> _loadWorkouts() async {
    if (_today == null) return;
    final result = await _service.sdk.records.list(
      AppConfig.workoutsCollection,
      filter: 'day = "${_today!.id}" && user = "$_userId"',
    );
    _workouts = result.data.map((r) => Workout.fromRecord(r)).toList();
  }

  Future<void> updateSleepHours(double hours) async {
    if (_today == null) return;
    try {
      final updated = await _service.sdk.records.update(
        AppConfig.daysCollection,
        _today!.id,
        {'sleep_hours': hours},
      );
      _today = Day.fromRecord(updated);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateMood(int mood) async {
    if (_today == null) return;
    try {
      final updated = await _service.sdk.records.update(
        AppConfig.daysCollection,
        _today!.id,
        {'mood': mood},
      );
      _today = Day.fromRecord(updated);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> addMeal(String name, int calories) async {
    if (_today == null) return;
    try {
      await _service.sdk.records.create(AppConfig.mealsCollection, {
        'day': _today!.id,
        'name': name,
        'calories': calories,
        'user': _userId,
      });
      await _loadMeals();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteMeal(String mealId) async {
    try {
      await _service.sdk.records.delete(AppConfig.mealsCollection, mealId);
      _meals.removeWhere((m) => m.id == mealId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> addWorkout(String exercise, List<ExerciseSet> sets) async {
    if (_today == null) return;
    try {
      await _service.sdk.records.create(AppConfig.workoutsCollection, {
        'day': _today!.id,
        'exercise': exercise,
        'sets': jsonEncode(sets.map((s) => s.toMap()).toList()),
        'user': _userId,
      });
      await _loadWorkouts();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateWorkoutSets(String workoutId, List<ExerciseSet> sets) async {
    try {
      await _service.sdk.records.update(AppConfig.workoutsCollection, workoutId, {
        'sets': jsonEncode(sets.map((s) => s.toMap()).toList()),
      });
      await _loadWorkouts();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteWorkout(String workoutId) async {
    try {
      await _service.sdk.records.delete(AppConfig.workoutsCollection, workoutId);
      _workouts.removeWhere((w) => w.id == workoutId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<Workout?> fetchLastWeekExercise(String exerciseName) async {
    if (_userId == null) return null;
    try {
      final lastWeekDate = DateTime.now().subtract(const Duration(days: 7));
      final dateStr = DateFormat('yyyy-MM-dd').format(lastWeekDate);

      final dayResult = await _service.sdk.records.list(
        AppConfig.daysCollection,
        filter: 'date = "$dateStr" && user = "$_userId"',
      );

      if (dayResult.data.isEmpty) return null;

      final dayId = dayResult.data.first.id;
      final workoutResult = await _service.sdk.records.list(
        AppConfig.workoutsCollection,
        filter: 'day = "$dayId" && exercise = "$exerciseName"',
      );

      if (workoutResult.data.isEmpty) return null;
      return Workout.fromRecord(workoutResult.data.first);
    } catch (_) {
      return null;
    }
  }

  Future<List<String>> fetchPreviousExercises() async {
    if (_userId == null) return [];
    try {
      final result = await _service.sdk.records.list(
        AppConfig.workoutsCollection,
        filter: 'user = "$_userId"',
        sort: '-created_at',
        perPage: 100,
      );

      final names = <String>{};
      for (final record in result.data) {
        names.add(record.get('exercise') as String);
      }
      return names.toList()..sort();
    } catch (_) {
      return [];
    }
  }
}
