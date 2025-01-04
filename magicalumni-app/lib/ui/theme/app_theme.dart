import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    brightness: Brightness.light,
    // Light body color in web =  Color(0xFFffffe7)
    scaffoldBackgroundColor: Color(0xFFF1F1FA),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white
      ),
      color: Color(0xFF8400FF),
    ),
    
    primaryColor: Color(0xFF8400FF),
    
    canvasColor: Color(0xFFF7CA18),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(
          color: Colors.white
        ),
        backgroundColor: const Color(0xFF8400FF),
        disabledBackgroundColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        )
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 2,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xFFF1F1FA),
      unselectedItemColor: Colors.black,
      selectedItemColor: Color(0xFF8401ff)
    )
  );
}

// purple - #8401ff
 
// dark yellow - #F7CA18
 
// light yellow - #F4D352
 
// body yellow - #ffffe7
 