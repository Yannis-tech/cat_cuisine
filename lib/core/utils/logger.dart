import 'package:logging/logging.dart';
import 'dart:developer' as developer;

final Logger _log = Logger('CatCuisine');

void setupLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    developer.log(
      record.message,
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  });
  
  _log.info('Logger initialized');
}

class AppLogger {
  static void info(String message) {
    _log.info(message);
  }

  static void warning(String message) {
    _log.warning(message);
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _log.severe(message, error, stackTrace);
  }

  static void debug(String message) {
    _log.fine(message);
  }
}