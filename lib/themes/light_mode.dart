import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      background: Colors.lightBlue.shade100,
      primary: Colors.grey.shade500,
      secondary: Colors.lightBlue.shade100,
      tertiary: Colors.white,
      inversePrimary: Colors.grey.shade700,
    ));
