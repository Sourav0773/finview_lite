import 'package:finview_lite/app.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final bool isDarkSaved = prefs.getBool('is_dark_mode') ?? false;
  runApp(FinviewLiteApp(initialIsDarkMode: isDarkSaved));
}
