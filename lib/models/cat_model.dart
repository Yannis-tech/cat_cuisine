import 'package:cat_cuisine/utils/cat_image_provider.dart';

/// Convert database model for `cats` table to
/// internal dart `class`:
/// - Use `fromJson` method to convert supabase response to [Cat]
/// - Use `toJson` method to convert [Cat] for update request
class CatModel {
  static const defaultUserId = 1;

  final String catId;
  final int userId;
  final String? name;
  final DateTime? birthday;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  CatModel({
    required this.catId,
    this.userId = defaultUserId,
    this.name,
    this.birthday,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : avatarUrl = avatarUrl ?? CatImageProvider.getRandomCatImage(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  int? get age {
    if (birthday == null) return null;
    final now = DateTime.now();
    int age = now.year - birthday!.year;
    if (now.month < birthday!.month ||
        (now.month == birthday!.month && now.day < birthday!.day)) {
      age--;
    }
    return age;
  }

  static CatModel fromJson(Map<String, dynamic> json) => CatModel(
        catId: json['cat_id'].toString(),
        userId: json['user_id'] as int? ?? defaultUserId,
        name: json['name'] as String?,
        birthday: json['birthday'] != null
            ? DateTime.parse(json['birthday'] as String)
            : null,
        avatarUrl: json['avatar_url'] as String?,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : DateTime.now(),
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'] as String)
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'cat_id': catId,
        'user_id': userId,
        'name': name,
        'birthday': birthday?.toIso8601String(),
        'avatar_url': avatarUrl,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  CatModel copyWith({
    String? catId,
    int? userId,
    String? name,
    DateTime? birthday,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CatModel(
      catId: catId ?? this.catId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      birthday: birthday ?? this.birthday,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
