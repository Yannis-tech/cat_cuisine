/// Convert database model for `meals` table to
/// internal dart `class`:
/// - Use `fromJson` method to convert supabase response to [MealModel]
/// - Use `toJson` method to convert [MealModel] for update request
class MealModel {
  final String? mealId;
  final DateTime timeOfDay;
  final String brandName;
  final String sortName;
  final String productLine;
  final String foodType;
  final String packaging;
  final int packagingSize;
  final int portionSize;
  final DateTime createdAt;
  final DateTime updatedAt;

  MealModel({
    this.mealId,
    required this.timeOfDay,
    required this.brandName,
    required this.sortName,
    required this.productLine,
    required this.foodType,
    required this.packaging,
    required this.packagingSize,
    required this.portionSize,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  static MealModel fromJson(Map<String, dynamic> json) => MealModel(
        mealId: json['meal_id']?.toString(),
        timeOfDay: json['time_of_day'] != null
            ? DateTime.parse(json['time_of_day'] as String)
            : DateTime.now(),
        brandName: json['brand_name'] as String,
        sortName: json['sort_name'] as String,
        productLine: json['product_line'] as String,
        foodType: json['food_type'] as String,
        packaging: json['packaging'] as String,
        packagingSize: json['packaging_size'] as int,
        portionSize: json['portion_size'] as int,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : DateTime.now(),
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'] as String)
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'time_of_day': timeOfDay.toIso8601String(),
      'brand_name': brandName,
      'sort_name': sortName,
      'product_line': productLine,
      'food_type': foodType,
      'packaging': packaging,
      'packaging_size': packagingSize,
      'portion_size': portionSize,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };

    // Only include meal_id for existing records
    if (mealId != null) {
      json['meal_id'] = mealId;
    }

    return json;
  }

  MealModel copyWith({
    String? mealId,
    DateTime? timeOfDay,
    String? brandName,
    String? sortName,
    String? productLine,
    String? foodType,
    String? packaging,
    int? packagingSize,
    int? portionSize,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MealModel(
      mealId: mealId ?? this.mealId,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      brandName: brandName ?? this.brandName,
      sortName: sortName ?? this.sortName,
      productLine: productLine ?? this.productLine,
      foodType: foodType ?? this.foodType,
      packaging: packaging ?? this.packaging,
      packagingSize: packagingSize ?? this.packagingSize,
      portionSize: portionSize ?? this.portionSize,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isNew => mealId == null;
}
