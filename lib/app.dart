import 'package:finview_lite/core/theme/app_theme.dart';
import 'package:finview_lite/core/theme/app_theme_provider.dart';
import 'package:finview_lite/data/datasource/portfolio_data_source.dart';
import 'package:finview_lite/data/repositories/portfolio_repository.dart';
import 'package:finview_lite/presentation/controllers/dashboard_controller.dart';
import 'package:finview_lite/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';

class FinviewLiteApp extends StatefulWidget {
  final bool initialIsDarkMode;
  const FinviewLiteApp({super.key, required this.initialIsDarkMode});

  @override
  State<FinviewLiteApp> createState() => _FinviewLiteAppState();
}

class _FinviewLiteAppState extends State<FinviewLiteApp> {
  late final AppThemeProvider _themeProvider;
  late final DashboardController _dashboardController;

  @override
  void initState() {
    super.initState();
    _themeProvider = AppThemeProvider(isDarkModeInitially: widget.initialIsDarkMode);
    
    _dashboardController = DashboardController(
      repository: PortfolioRepositoryImpl(dataSource: PortfolioDataSource()),
    );
  }

  @override
  void dispose() {
    _themeProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeProvider.themeNotifier,
      builder: (context, currentThemeMode, child) {
        return MaterialApp(
          title: 'FinView Lite',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentThemeMode,
          home: DashboardScreen(
            onThemeToggle: _themeProvider.toggleTheme,
            dashboardController: _dashboardController,
          ),
        );
      },
    );
  }
}