import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logging_types.dart';

class LoggingUserLogStore extends StateNotifier<List<UserLogEntry>> {
  static final _instance = LoggingUserLogStore();
  static final provider = StateNotifierProvider<LoggingUserLogStore, List<UserLogEntry>>((_) => _instance);

  LoggingUserLogStore() : super([]);

  static void log(UserLogEntry entry) {
    _instance.state = [..._instance.state, entry];
  }
}
