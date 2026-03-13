import 'package:logger/logger.dart';

import 'theme/logging_color_style.dart';
import 'logging_printers.dart';

typedef LogFunction = void Function(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace});

typedef LogFunction2 =
    void Function(
      dynamic message, {
      DateTime? time,
      Object? error,
      StackTrace? stackTrace,
      bool userLog,
      bool banner,
      bool snackBar,
    });

typedef PrinterFactory = LogPrinter Function(String, LoggingColorStyle);

mixin LogFunctions {
  void f(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace});
  void e(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace});
  void w(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace});
  void i(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace});
  void d(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace});
  void t(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace});
}

enum PrinterTypes {
  plain(CustomerPlainPrinter.new),
  color(CustomerColorPrinter.new);

  final PrinterFactory createPrinter;

  const PrinterTypes(this.createPrinter);
}

class UserLogEntry {
  final String message;
  final Level level;
  final String className;
  final DateTime time;
  final Object? error;
  final StackTrace? stackTrace;

  const UserLogEntry({
    required this.message,
    required this.level,
    required this.className,
    required this.time,
    this.error,
    this.stackTrace,
  });

  @override
  String toString() {
    return '$time : [$className] $message'
        '${error == null ? '' : '\nError: ${error.toString()}'}'
        '${stackTrace == null ? '' : '\nStack: ${stackTrace.toString().split('\n').take(5).join('\n')}... (truncated)'}';
  }
}
