import 'package:cat_cuisine/database/food_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'food_database_provider.g.dart';

@riverpod
class FoodData extends _$FoodData {
  @override
  Future<List<String>> build() async {
    // Initially load brands
    return FoodDatabase.instance.getBrands();
  }

  Future<List<String>> getBrands() async {
    return FoodDatabase.instance.getBrands();
  }

  Future<List<String>> getProductLines(String brand) async {
    return FoodDatabase.instance.getProductLines(brand);
  }

  Future<List<String>> getSorts(String brand, String productLine) async {
    return FoodDatabase.instance.getSorts(brand, productLine);
  }

  Future<List<String>> getPackagings(
      String brand, String productLine, String sort) async {
    return FoodDatabase.instance.getPackagings(brand, productLine, sort);
  }

  Future<List<String>> getPackagingSizes(
      String brand, String productLine, String sort, String packaging) async {
    return FoodDatabase.instance
        .getPackagingSizes(brand, productLine, sort, packaging);
  }
}
