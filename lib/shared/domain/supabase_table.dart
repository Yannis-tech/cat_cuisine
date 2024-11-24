/// Set of all the database tables in Supabase.
///
/// Used to reference valid tables when making database requests.
abstract class SupabaseTable {
  String get tableName;
  String get primaryKey;
}

class CatsSupabaseTable implements SupabaseTable {
  @override
  final String tableName = 'cats';
  @override
  final String primaryKey = 'cat_id';

  const CatsSupabaseTable();
}

class MealsSupabaseTable implements SupabaseTable {
  @override
  final String tableName = 'meals';
  @override
  final String primaryKey = 'meal_id';

  const MealsSupabaseTable();
}

class MealConsumptionsSupabaseTable implements SupabaseTable {
  @override
  final String tableName = 'meal_consumptions';
  @override
  final String primaryKey = 'meal_consumption_id';

  const MealConsumptionsSupabaseTable();
}
