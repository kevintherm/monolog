class Day {
  final String id;
  final String date;
  final double? sleepHours;
  final int? mood;
  final String user;

  Day({
    required this.id,
    required this.date,
    this.sleepHours,
    this.mood,
    required this.user,
  });

  factory Day.fromRecord(dynamic record) {
    return Day(
      id: record.id as String,
      date: record.get('date') as String,
      sleepHours: (record.get('sleep_hours') as num?)?.toDouble(),
      mood: (record.get('mood') as num?)?.toInt(),
      user: record.get('user') as String,
    );
  }
}
