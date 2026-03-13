import 'package:flutter/material.dart';

class LoggingColorScheme {
  final Color darker;
  final Color lighter;
  final IconData icon;
  final String emoji;
  final String tag;

  LoggingColorScheme({
    required this.darker,
    required this.lighter,
    required this.icon,
    required this.emoji,
    required this.tag,
  });

  // TODO: It might be worth looking into adding some getter functions that adjust the colours, based on the current theme color scheme, to blend the colours; just a thought.
}
