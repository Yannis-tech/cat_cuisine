import 'dart:io';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FoodDatabase {
  static final FoodDatabase instance = FoodDatabase._init();
  static Database? _database;
  final _logger = Logger('FoodDatabase');

  var sqliteFile = 'food_brands.db';
  var tableName = 'pet_food';
  var brandColumn = 'Brand';
  var productLineColumn = 'Product_line';
  var foodTypeColumn = 'Food_type';
  var sortColumn = 'Sort';
  var packagingColumn = 'Packaging';
  var packagingSizeColumn = 'Packaging_Size';

  FoodDatabase._init() {
    // Initialize logging
    Logger.root.level = Level.ALL; // Set the root logger level
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, sqliteFile);
    _logger.info('Database path: $path');

    // Force delete existing database
    if (await File(path).exists()) {
      await File(path).delete();
      _logger.info('Deleted existing database');
    }

    try {
      await Directory(dirname(path)).create(recursive: true);
      _logger.info('Created directory for database');

      ByteData data = await rootBundle.load('assets/$sqliteFile');
      _logger.info('Loaded database from assets');

      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
      _logger.info('Successfully copied database to path');
    } catch (e, stackTrace) {
      _logger.severe('Error copying database', e, stackTrace);
    }

    _database = await openDatabase(path);

    // Verify tables after opening
    final tables = await _database!
        .rawQuery("SELECT name FROM sqlite_master WHERE type='table';");
    _logger.info('Available tables: ${tables.map((t) => t['name']).toList()}');

    return _database!;
  }

  Future<List<String>> getBrands() async {
    _logger.fine('Getting brands list');
    try {
      final db = await database;
      final result = await db.rawQuery(
          'SELECT DISTINCT $brandColumn FROM $tableName ORDER BY $brandColumn');
      _logger.fine('Found ${result.length} brands');
      return result.map((row) => row[brandColumn] as String).toList();
    } catch (e, stackTrace) {
      _logger.severe('Error getting brands', e, stackTrace);
      rethrow;
    }
  }

  Future<List<String>> getProductLines(String brand) async {
    _logger.fine('Getting product lines for brand: $brand');
    try {
      final db = await database;
      final result = await db.rawQuery(
          'SELECT DISTINCT $productLineColumn FROM $tableName WHERE $brandColumn = ? ORDER BY $productLineColumn',
          [brand]);
      _logger.fine('Found ${result.length} product lines for $brand');
      return result.map((row) => row[productLineColumn] as String).toList();
    } catch (e, stackTrace) {
      _logger.severe('Error getting product lines for $brand', e, stackTrace);
      rethrow;
    }
  }

  Future<List<String>> getSorts(String brand, String productLine) async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT DISTINCT $sortColumn FROM $tableName WHERE $brandColumn = ? AND $productLineColumn = ? ORDER BY $sortColumn',
        [brand, productLine]);
    return result.map((row) => row[sortColumn] as String).toList();
  }

  Future<List<String>> getPackagings(
      String brand, String productLine, String sort) async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT DISTINCT $packagingColumn FROM $tableName WHERE $brandColumn = ? AND $productLineColumn = ? AND $sortColumn = ? ORDER BY $packagingColumn ',
        [brand, productLine, sort]);
    return result.map((row) => row[packagingColumn] as String).toList();
  }

  Future<List<String>> getPackagingSizes(
      String brand, String productLine, String sort, String packaging) async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT DISTINCT $packagingSizeColumn FROM $tableName WHERE $brandColumn = ? AND $productLineColumn = ? AND $sortColumn = ? AND $packagingColumn  = ? ORDER BY $packagingSizeColumn',
        [brand, productLine, sort, packaging]);
    return result.map((row) => row[packagingSizeColumn] as String).toList();
  }
}
