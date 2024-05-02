// In a new file named theme_data.dart

import 'package:flutter/material.dart';

var MyAppTheme = ThemeData(
  primaryColor: Colors.teal, // Adjust to your desired primary color
  secondaryHeaderColor: const Color.fromARGB(255, 7, 85, 67), // Adjust to your desired accent color
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 16.0),
  ),
  // Add more theme properties as needed:
  // appBarTheme: AppBarTheme(...),
  // buttonTheme: ButtonThemeData(...),
  // etc.
);
