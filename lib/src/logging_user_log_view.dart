import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'logging.dart';
import 'logging_user_log_store.dart';
import 'theme/logging_theme_extension.dart';

class LoggingUserLogView extends ConsumerWidget {
  static final log = Logging.create(LoggingUserLogView, level: Level.all);
  const LoggingUserLogView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logEntries = ref.watch(LoggingUserLogStore.provider);

    final LoggingThemeData loggingTheme = Theme.of(context).loggingTheme;

    return ListView.builder(
      itemCount: logEntries.length,
      itemBuilder: (context, index) {
        final logEntry = logEntries[index];
        final scheme = loggingTheme.style.forLevel(logEntry.level);
        final backgroundColor = scheme.lighter;
        final foregroundColor = scheme.darker;
        final textStyle = TextStyle(color: foregroundColor, backgroundColor: backgroundColor);
        return ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${logEntry.time}', style: textStyle),
              Text(logEntry.className, style: textStyle),
            ],
          ),
          subtitle: Text(logEntry.message, style: textStyle),
        );
      },
    );
  }
}
