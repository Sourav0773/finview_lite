import 'package:flutter/material.dart';

class AppTheme {

  /// Light theme config
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF9FAFB), 
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF3B82F6),               
        onPrimary: Colors.white,                  
        surface: Colors.white,                    
        onSurface: Color(0xFF111827),             
        onSurfaceVariant: Color(0xFF6B7280),      
        surfaceContainerHighest: Color(0xFFE5E7EB), 
        outlineVariant: Color(0xFFE5E7EB),        
        secondary: Color(0xFF00E676),             
        error: Color(0xFFEF4444),                 
      ), 
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF111827)), 
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF111827)),    
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6B7280)),  
      ),
    );
  }

  /// Dark theme config
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0B0F19), 
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF3B82F6),               
        onPrimary: Colors.white,                  
        surface: Color(0xFF131B2E),               
        onSurface: Color(0xFFF9FAFB),             
        onSurfaceVariant: Color(0xFF9CA3AF),      
        surfaceContainerHighest: Color(0xFF1F2937), 
        outlineVariant: Color(0xFF1E293B),        
        secondary: Color(0xFF00E676),             
        error: Color(0xFFF87171),                 
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFF9FAFB)),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFF9FAFB)),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF)),
      ),
    );
  }
}