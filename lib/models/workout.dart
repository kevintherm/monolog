class ExerciseSet {
  final int reps;
  final double weight;

  ExerciseSet({required this.reps, required this.weight});

  factory ExerciseSet.fromMap(Map<String, dynamic> map) {
    return ExerciseSet(
      reps: (map['reps'] as num).toInt(),
      weight: (map['weight'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {'reps': reps, 'weight': weight};
}

class Workout {
  final String id;
  final String dayId;
  final String exercise;
  final List<ExerciseSet> sets;
  final String user;

  Workout({
    required this.id,
    required this.dayId,
    required this.exercise,
    required this.sets,
    required this.user,
  });

  factory Workout.fromRecord(dynamic record) {
    final rawSets = record.get('sets');
    List<ExerciseSet> parsedSets = [];
    if (rawSets is List) {
      parsedSets = rawSets
          .map((s) => ExerciseSet.fromMap(Map<String, dynamic>.from(s as Map)))
          .toList();
    }

    return Workout(
      id: record.id as String,
      dayId: record.get('day') as String,
      exercise: record.get('exercise') as String,
      sets: parsedSets,
      user: record.get('user') as String,
    );
  }
}
