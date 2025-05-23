/// Convert database model for `meal_consumptions` table to
/// internal dart `class`:
/// - Use `fromJson` method to convert supabase response to [MealConsumptionModel]
/// - Use `toJson` method to convert [MealConsumptionModel] for update request
class MealConsumptionModel {
  final String? mealConsumptionId;
  final String mealId;
  final String catId;
  final int portionSize;
  final int rating;
  final DateTime createdAt;
  final DateTime updatedAt;

  MealConsumptionModel({
    this.mealConsumptionId,
    required this.mealId,
    required this.catId,
    required this.portionSize,
    required this.rating,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  static MealConsumptionModel fromJson(Map<String, dynamic> json) =>
      MealConsumptionModel(
        mealConsumptionId: json['meal_consumption_id']?.toString(),
        mealId: json['meal_id'].toString(),
        catId: json['cat_id'].toString(),
        portionSize: json['portion_size'] as int,
        rating: json['rating'] as int,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : DateTime.now(),
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'] as String)
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'meal_id': mealId,
      'cat_id': catId,
      'portion_size': portionSize,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };

    // Only include meal_consumption_id for existing records
    if (mealConsumptionId != null) {
      json['meal_consumption_id'] = mealConsumptionId;
    }

    return json;
  }

  MealConsumptionModel copyWith({
    String? mealConsumptionId,
    String? mealId,
    String? catId,
    int? portionSize,
    int? rating,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MealConsumptionModel(
      mealConsumptionId: mealConsumptionId ?? this.mealConsumptionId,
      mealId: mealId ?? this.mealId,
      catId: catId ?? this.catId,
      portionSize: portionSize ?? this.portionSize,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
