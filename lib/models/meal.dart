class Meal {
  final String id;
  final String dayId;
  final String name;
  final int calories;
  final String user;

  Meal({
    required this.id,
    required this.dayId,
    required this.name,
    required this.calories,
    required this.user,
  });

  factory Meal.fromRecord(dynamic record) {
    return Meal(
      id: record.id as String,
      dayId: record.get('day') as String,
      name: record.get('name') as String,
      calories: (record.get('calories') as num).toInt(),
      user: record.get('user') as String,
    );
  }
}
