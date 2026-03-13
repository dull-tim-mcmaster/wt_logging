import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'logging_color_scheme.dart';

class LoggingColorStyle {
  static final _default = LoggingColorScheme(
    darker: Colors.grey,
    lighter: Colors.white,
    icon: Icons.note,
    emoji: '📘',
    tag: 'LOG',
  );

  final Map<Level, LoggingColorScheme> _schemes;

  LoggingColorStyle(this._schemes);

  factory LoggingColorStyle.create({
    required Color primaryThemeColor,
    required Color secondaryThemeColor,
    required Brightness brightness,
  }) {
    final Map<Level, LoggingColorScheme> styles = {
      Level.trace: LoggingColorScheme(
        darker: Colors.blue,
        lighter: Colors.white,
        icon: Icons.notes_outlined,
        emoji: '📝',
        tag: 'TRACE',
      ),
      Level.debug: LoggingColorScheme(
        darker: Colors.blueGrey,
        lighter: Colors.white,
        icon: Icons.bug_report,
        emoji: '🐛',
        tag: 'DEBUG',
      ),
      Level.info: LoggingColorScheme(
        darker: Colors.green,
        lighter: secondaryThemeColor,
        icon: Icons.info_outline,
        emoji: 'ℹ️',
        tag: 'INFO',
      ),
      Level.warning: LoggingColorScheme(
        darker: Colors.orange,
        lighter: secondaryThemeColor,
        icon: Icons.warning_amber_outlined,
        emoji: '⚠️',
        tag: 'WARNING',
      ),
      Level.error: LoggingColorScheme(
        darker: Colors.red,
        lighter: secondaryThemeColor,
        icon: Icons.error_outline,
        emoji: '🚨',
        tag: 'ERROR',
      ),
      Level.fatal: LoggingColorScheme(
        darker: Colors.deepOrange,
        lighter: secondaryThemeColor,
        icon: Icons.error,
        emoji: '🔥',
        tag: 'FATAL',
      ),
    };

    return LoggingColorStyle(styles);
  }

  LoggingColorScheme forLevel(Level level) {
    return _schemes[level] ?? _default;
  }

  LoggingColorStyle lerp(LoggingColorStyle other, double t) {
    return LoggingColorStyle(t < 0.5 ? _schemes : other._schemes);
  }
}

extension IsBrightExt on Brightness {
  bool isLight() => this == Brightness.light;
}
