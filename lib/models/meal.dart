class Meal {
  final String id;
  final String dayId;
  final String name;
  final int calories;
  final int protein;
  final String image;
  final String user;

  Meal({
    required this.id,
    required this.dayId,
    required this.name,
    required this.calories,
    required this.protein,
    required this.image,
    required this.user,
  });

  factory Meal.fromRecord(dynamic record) {
    final imageData = record.get('image');
    String imageVal = '';
    if (imageData is String) {
      imageVal = imageData;
    } else if (imageData is Map) {
      imageVal = imageData['url'] as String? ?? 
                 imageData['name'] as String? ?? 
                 imageData['filename'] as String? ?? '';
    }

    return Meal(
      id: record.id as String,
      dayId: record.get('day') as String,
      name: record.get('name') as String,
      calories: (record.get('calories') as num).toInt(),
      protein: (record.get('protein') as num? ?? 0).toInt(),
      image: imageVal,
      user: record.get('user') as String,
    );
  }
}
