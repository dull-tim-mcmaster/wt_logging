import 'package:logger/logger.dart';

import 'theme/logging_color_style.dart';

class CustomerPlainPrinter extends LogPrinter {
  final LoggingColorStyle symbolStyle;
  final String className;

  CustomerPlainPrinter(this.className, this.symbolStyle);

  @override
  List<String> log(LogEvent event) {
    final styles = symbolStyle.forLevel(event.level);
    return ['${event.time} : ${styles.tag} $className : ${styles.emoji} ${event.message}'];
  }
}

class CustomerColorPrinter extends LogPrinter {
  final LoggingColorStyle config;
  final String className;

  CustomerColorPrinter(this.className, this.config);

  @override
  List<String> log(LogEvent event) {
    final AnsiColor color = PrettyPrinter.defaultLevelColors[event.level] ?? AnsiColor.none();
    final styles = config.forLevel(event.level);
    final message = event.message;
    return [color('${event.time} : ${styles.tag} $className : ${styles.emoji} $message')];
  }
}
