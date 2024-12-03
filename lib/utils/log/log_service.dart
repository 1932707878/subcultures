import 'package:logger/logger.dart';

class Log {
  Log._();
  static final Log _instance = Log._();
  static Log get instance => _instance;

  static final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );

  /// 调试日志
  static void debug(String message) {
    _logger.d(message);
  }

  /// 信息日志
  static void info(String message) {
    _logger.i(message);
  }

  /// 警告日志
  static void warning(String message) {
    _logger.w(message);
  }

  /// 错误日志
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
