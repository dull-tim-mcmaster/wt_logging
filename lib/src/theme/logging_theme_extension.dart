import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'logging_color_style.dart';

class LoggingThemeData extends ThemeExtension<LoggingThemeData> {
  final Level minLevel;
  final LoggingColorStyle style;

  const LoggingThemeData({required this.minLevel, required this.style});

  factory LoggingThemeData.initial() {
    return LoggingThemeData.create(
      primary: Colors.blue,
      secondary: Colors.deepOrangeAccent,
      brightness: Brightness.light,
      minLevel: Level.all,
    );
  }

  factory LoggingThemeData.fromTheme(ThemeData theme, {Level minLevel = Level.warning}) {
    return LoggingThemeData.create(
      primary: theme.colorScheme.primary,
      secondary: theme.colorScheme.secondary,
      brightness: theme.brightness,
      minLevel: minLevel,
    );
  }

  factory LoggingThemeData.create({
    required Color primary,
    required Color secondary,
    required Brightness brightness,
    Level minLevel = Level.warning,
  }) {
    return LoggingThemeData(
      minLevel: minLevel,
      style: LoggingColorStyle.create(
        primaryThemeColor: primary,
        secondaryThemeColor: secondary,
        brightness: brightness,
      ),
    );
  }

  @override
  LoggingThemeData copyWith({Level? minLevel, LoggingColorStyle? colors}) {
    return LoggingThemeData(minLevel: minLevel ?? this.minLevel, style: colors ?? this.style);
  }

  @override
  LoggingThemeData lerp(LoggingThemeData other, double t) {
    return LoggingThemeData(minLevel: t < 0.5 ? minLevel : other.minLevel, style: style.lerp(other.style, t));
  }
}

extension LoggingThemeExtension on ThemeData {
  LoggingThemeData get loggingTheme {
    return extension<LoggingThemeData>() ?? LoggingThemeData.fromTheme(this);
  }
}
