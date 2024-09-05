import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      background: const Color.fromARGB(255, 20, 20, 20),
      primary: const Color.fromARGB(255, 122, 122, 122),
      secondary: const Color.fromARGB(255, 20, 20, 20),
      tertiary: const Color.fromARGB(255, 47, 47, 47),
      inversePrimary: Colors.grey.shade300,
    ));
