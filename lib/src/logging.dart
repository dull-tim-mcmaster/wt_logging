import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import './logging_types.dart';
import 'logging_user_log_store.dart';
import 'theme/logging_theme_extension.dart';

class Logging with LogFunctions {
  static final log = Logging.create(Logging, level: Level.debug);

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static final logLevelMap = <Type, Level>{};

  final Level _level;
  final Logger _logger;
  final String className;
  static LoggingThemeData _theme = LoggingThemeData.initial();

  static LoggingThemeData get theme => _theme;

  Logging._(this._logger, this._level, this.className);

  factory Logging.create(dynamic prefix,
      {Level level = Level.warning,
      PrinterTypes printerType = PrinterTypes.color}) {
    final className = prefix.toString().split('<')[0];
    final logger = Logger(
        printer: printerType.createPrinter(className, _theme.style),
        level: level);
    return Logging._(logger, level, className);
  }

  static void configure(LoggingThemeData theme) {
    log.i('Reconfiguring logging theme.');
    _theme = theme;
  }

  @override
  void f(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
    bool userLog = false,
    snackBar = false,
    bool banner = false,
  }) {
    _log(
        LogEvent(Level.fatal, message,
            time: time, error: error, stackTrace: stackTrace),
        _logger.f);
    if (userLog) {
      _userLog(message,
          error: error, stackTrace: stackTrace, level: Level.fatal);
    }
    if (snackBar) {
      _snackBar(message,
          error: error, stackTrace: stackTrace, level: Level.fatal);
    }
    if (banner) {
      _banner(message,
          error: error, stackTrace: stackTrace, level: Level.fatal);
    }
  }

  @override
  void e(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
    bool userLog = false,
    snackBar = false,
    bool banner = false,
  }) {
    _log(
        LogEvent(Level.error, message,
            time: time, error: error, stackTrace: stackTrace),
        _logger.e);
    if (userLog) {
      _userLog(message,
          error: error, stackTrace: stackTrace, level: Level.error);
    }
    if (snackBar) {
      _snackBar(message,
          error: error, stackTrace: stackTrace, level: Level.error);
    }
    if (banner) {
      _banner(message,
          error: error, stackTrace: stackTrace, level: Level.error);
    }
  }

  @override
  void w(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
    bool userLog = false,
    snackBar = false,
    bool banner = false,
  }) {
    _log(
        LogEvent(Level.warning, message,
            time: time, error: error, stackTrace: stackTrace),
        _logger.w);
    if (userLog) {
      _userLog(message,
          error: error, stackTrace: stackTrace, level: Level.warning);
    }
    if (snackBar) {
      _snackBar(message,
          error: error, stackTrace: stackTrace, level: Level.warning);
    }
    if (banner) {
      _banner(message,
          error: error, stackTrace: stackTrace, level: Level.warning);
    }
  }

  @override
  void i(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
    bool userLog = false,
    snackBar = false,
    bool banner = false,
  }) {
    _log(
        LogEvent(Level.info, message,
            time: time, error: error, stackTrace: stackTrace),
        _logger.i);
    if (userLog) {
      _userLog(message,
          error: error, stackTrace: stackTrace, level: Level.info);
    }
    if (snackBar) {
      _snackBar(message,
          error: error, stackTrace: stackTrace, level: Level.info);
    }
    if (banner) {
      _banner(message, error: error, stackTrace: stackTrace, level: Level.info);
    }
  }

  @override
  void d(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
    bool userLog = false,
    snackBar = false,
    bool banner = false,
  }) {
    _log(
        LogEvent(Level.debug, message,
            time: time, error: error, stackTrace: stackTrace),
        _logger.d);
    if (userLog) {
      _userLog(message,
          error: error, stackTrace: stackTrace, level: Level.debug);
    }
    if (snackBar) {
      _snackBar(message,
          error: error, stackTrace: stackTrace, level: Level.debug);
    }
    if (banner) {
      _banner(message,
          error: error, stackTrace: stackTrace, level: Level.debug);
    }
  }

  @override
  void t(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
    bool userLog = false,
    snackBar = false,
    bool banner = false,
  }) {
    _log(
        LogEvent(Level.trace, message,
            time: time, error: error, stackTrace: stackTrace),
        _logger.t);
    if (userLog) {
      _userLog(message,
          error: error, stackTrace: stackTrace, level: Level.trace);
    }
    if (snackBar) {
      _snackBar(message,
          error: error, stackTrace: stackTrace, level: Level.trace);
    }
    if (banner) {
      _banner(message,
          error: error, stackTrace: stackTrace, level: Level.trace);
    }
  }

  void _log(LogEvent event, LogFunction logFunction) {
    final messageString = '${event.message}'
        '${event.error == null ? '' : 'ERROR(${event.error})'}'
        '${event.stackTrace == null ? '' : 'STACKTRACE(${event.stackTrace})'}';
    logFunction(messageString);
  }

  void _userLog(dynamic message,
      {DateTime? time,
      Object? error,
      StackTrace? stackTrace,
      Level level = Level.info}) {
    if (level.value >= _level.value) {
      LoggingUserLogStore.log(
        UserLogEntry(
          message: message,
          level: level,
          className: className,
          time: time ?? DateTime.now(),
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  void _snackBar(dynamic message,
      {Object? error, StackTrace? stackTrace, Level level = Level.info}) {
    final config = _theme;
    if (level.value >= config.minLevel.value) {
      final style = _theme.style.forLevel(level);
      final messageString = '$message'
          '${error == null ? '' : 'ERROR($error)'}'
          '${stackTrace == null ? '' : 'STACKTRACE($stackTrace)'}';

      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Row(
            spacing: 10,
            children: [
              Icon(style.icon),
              Text(messageString, style: TextStyle(color: style.lighter)),
            ],
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: style.darker,
        ),
      );
    }
  }

  void _banner(dynamic message,
      {Object? error, StackTrace? stackTrace, Level level = Level.info}) {
    final config = _theme;
    if (level.value >= config.minLevel.value) {
      final style = config.style.forLevel(level);

      final messageString = '$message'
          '${error == null ? '' : 'ERROR($error)'}'
          '${stackTrace == null ? '' : 'STACKTRACE($stackTrace)'}';

      final banner = MaterialBanner(
        content: Text(messageString, style: TextStyle(color: style.lighter)),
        leading: Icon(
          style.icon, // Use a helper to get icon based on level
          color: style.lighter,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              scaffoldMessengerKey.currentState?.hideCurrentMaterialBanner();
            },
            child: Text('Dismiss', style: TextStyle(color: style.lighter)),
          ),
        ],
        backgroundColor: style.darker,
        elevation: 2.0,
        leadingPadding: const EdgeInsets.all(8.0),
        contentTextStyle: TextStyle(color: style.lighter),
      );

      if (scaffoldMessengerKey.currentState != null) {
        scaffoldMessengerKey.currentState!.showMaterialBanner(banner);
      } else {
        d('ScaffoldMessengerKey is not available to show MaterialBanner.');
      }
    }
  }
}

Logging logger(dynamic prefix,
        {Level level = Level.warning,
        PrinterTypes printerType = PrinterTypes.color}) =>
    Logging.create(prefix, level: level, printerType: printerType);
