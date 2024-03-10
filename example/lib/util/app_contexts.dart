import 'package:flutter/material.dart';

extension Contexts on BuildContext {
  TextTheme get themeText => Theme.of(this).textTheme;
  ColorScheme get themeColor => Theme.of(this).colorScheme;
}
