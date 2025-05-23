import 'package:cat_cuisine/database/food_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'food_database_provider.g.dart';

class FoodItem {
  final String brand;
  final String productLine;
  final String sort;
  final String packaging;
  final String packagingSize;

  const FoodItem({
    required this.brand,
    required this.productLine,
    required this.sort,
    required this.packaging,
    required this.packagingSize,
  });
}

@riverpod
class FoodData extends _$FoodData {
  @override
  FutureOr<List<FoodItem>> build() async {
    return _loadAllItems();
  }

  Future<List<FoodItem>> _loadAllItems() async {
    final db = await FoodDatabase.instance.database;

    final result = await db.rawQuery('''
     SELECT DISTINCT
       Brand as brand,
       Product_line as productLine,
       Sort as sort, 
       Packaging as packaging,
       Packaging_Size as packagingSize
     FROM pet_food
   ''');

    return result
        .map((row) => FoodItem(
              brand: row['brand'] as String,
              productLine: row['productLine'] as String,
              sort: row['sort'] as String,
              packaging: row['packaging'] as String,
              packagingSize: row['packagingSize'] as String,
            ))
        .toList();
  }

  Future<List<String>> getFilteredProductLines({
    String? brand,
    String? sort,
    String? packaging,
    String? packagingSize,
  }) async {
    final db = await FoodDatabase.instance.database;
    final query = '''
     SELECT DISTINCT Product_line 
     FROM pet_food 
     WHERE 1=1
     ${brand != null ? "AND Brand = ?" : ""}
     ${sort != null ? "AND Sort = ?" : ""}
     ${packaging != null ? "AND Packaging = ?" : ""}
     ${packagingSize != null ? "AND Packaging_Size = ?" : ""}
     ORDER BY Product_line
   ''';

    final args = [
      if (brand != null) brand,
      if (sort != null) sort,
      if (packaging != null) packaging,
      if (packagingSize != null) packagingSize,
    ];

    final result = await db.rawQuery(query, args);
    return result.map((row) => row['Product_line'] as String).toList();
  }

  Future<List<String>> getFilteredSorts({
    String? brand,
    String? productLine,
    String? packaging,
    String? packagingSize,
  }) async {
    final db = await FoodDatabase.instance.database;
    final query = '''
     SELECT DISTINCT Sort 
     FROM pet_food 
     WHERE 1=1
     ${brand != null ? "AND Brand = ?" : ""}
     ${productLine != null ? "AND Product_line = ?" : ""}
     ${packaging != null ? "AND Packaging = ?" : ""}
     ${packagingSize != null ? "AND Packaging_Size = ?" : ""}
     ORDER BY Sort
   ''';

    final args = [
      if (brand != null) brand,
      if (productLine != null) productLine,
      if (packaging != null) packaging,
      if (packagingSize != null) packagingSize,
    ];

    final result = await db.rawQuery(query, args);
    return result.map((row) => row['Sort'] as String).toList();
  }

  Future<List<String>> getFilteredPackagings({
    String? brand,
    String? productLine,
    String? sort,
    String? packagingSize,
  }) async {
    final db = await FoodDatabase.instance.database;
    final query = '''
     SELECT DISTINCT Packaging 
     FROM pet_food 
     WHERE 1=1
     ${brand != null ? "AND Brand = ?" : ""}
     ${productLine != null ? "AND Product_line = ?" : ""}
     ${sort != null ? "AND Sort = ?" : ""}
     ${packagingSize != null ? "AND Packaging_Size = ?" : ""}
     ORDER BY Packaging
   ''';

    final args = [
      if (brand != null) brand,
      if (productLine != null) productLine,
      if (sort != null) sort,
      if (packagingSize != null) packagingSize,
    ];

    final result = await db.rawQuery(query, args);
    return result.map((row) => row['Packaging'] as String).toList();
  }

  Future<List<String>> getFilteredPackagingSizes({
    String? brand,
    String? productLine,
    String? sort,
    String? packaging,
  }) async {
    final db = await FoodDatabase.instance.database;
    final query = '''
     SELECT DISTINCT Packaging_Size 
     FROM pet_food 
     WHERE 1=1
     ${brand != null ? "AND Brand = ?" : ""}
     ${productLine != null ? "AND Product_line = ?" : ""}
     ${sort != null ? "AND Sort = ?" : ""}
     ${packaging != null ? "AND Packaging = ?" : ""}
     ORDER BY Packaging_Size
   ''';

    final args = [
      if (brand != null) brand,
      if (productLine != null) productLine,
      if (sort != null) sort,
      if (packaging != null) packaging,
    ];

    final result = await db.rawQuery(query, args);
    return result.map((row) => row['Packaging_Size'] as String).toList();
  }

  Future<List<String>> getBrands({
    String? productLine,
    String? sort,
    String? packaging,
    String? packagingSize,
  }) async {
    final db = await FoodDatabase.instance.database;
    final query = '''
     SELECT DISTINCT Brand
     FROM pet_food 
     WHERE 1=1
     ${productLine != null ? "AND Product_line = ?" : ""}
     ${sort != null ? "AND Sort = ?" : ""}
     ${packaging != null ? "AND Packaging = ?" : ""}
     ${packagingSize != null ? "AND Packaging_Size = ?" : ""}
     ORDER BY Brand
   ''';

    final args = [
      if (productLine != null) productLine,
      if (sort != null) sort,
      if (packaging != null) packaging,
      if (packagingSize != null) packagingSize,
    ];

    final result = await db.rawQuery(query, args);
    return result.map((row) => row['Brand'] as String).toList();
  }
}
