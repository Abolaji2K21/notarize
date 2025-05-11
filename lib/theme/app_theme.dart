import 'package:flutter/material.dart';

class AppTheme {
  // Colors from the provided palette
  static const Color lightBlue = Color(0xFFC2DCFD);
  static const Color lightPink = Color(0xFFFFD8F4);
  static const Color lightYellow = Color(0xFFFBF6AA);
  static const Color lightGreen = Color(0xFFB0E9CA);
  static const Color paleYellow = Color(0xFFFCFAD9);
  static const Color lightLavender = Color(0xFFF1DBF5);
  static const Color veryLightBlue = Color(0xFFD9E8FC);
  static const Color veryLightPink = Color(0xFFFFFDBE3);
  
  // App colors
  static const Color backgroundColor = Color(0xFFF0F2FA);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF2E3A59);
  static const Color secondaryTextColor = Color(0xFF8F9BB3);
  
  // Note card colors - updated to match the palette
  static const Color todoColor = lightBlue;
  static const Color homeworkColor = lightPink;
  static const Color eveningColor = lightYellow;
  static const Color classesColor = lightGreen;
  static const Color tourColor = lightLavender;
  static const Color rollerCoasterColor = veryLightBlue;
  
  // Text styles with Nunito font (replacing Avenir)
  static const TextStyle headingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: textColor,
    fontFamily: 'Nunito',
  );
  
  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textColor,
    fontFamily: 'Nunito',
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: textColor,
    fontFamily: 'Nunito',
  );
  
  static const TextStyle captionStyle = TextStyle(
    fontSize: 12,
    color: secondaryTextColor,
    fontFamily: 'Nunito',
  );
  
  // Theme data
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.black,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.light(
      primary: Colors.black,
      secondary: Colors.black,
      background: backgroundColor,
      surface: cardColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: textColor,
      onSurface: textColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: textColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: textColor),
      titleTextStyle: TextStyle(
        color: textColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'Nunito',
      ),
    ),
    cardTheme: CardTheme(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade200,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: const TextStyle(
        color: secondaryTextColor,
        fontFamily: 'Nunito',
      ),
    ),
    fontFamily: 'Nunito',
  );
}
