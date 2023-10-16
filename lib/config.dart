import 'package:flutter/material.dart'
    show Color, ColorScheme, Colors, ThemeData;

class Config {
  static const double textFontSize = 18;
  static const double titleFontSize = 22;
  static const Color orange = Color.fromARGB(255, 239, 138, 80);
  static const Color red = Color.fromARGB(255, 239, 83, 80);
  static const Color white = Colors.white;
  static const Color successfullSnackBar = Colors.green;
  static const Color errorSnackBar = Colors.red;
  static ThemeData theme = ThemeData.from(
    colorScheme: ColorScheme.dark(
      background: Colors.grey[900]!,
    ),
  );
}
