import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'services/storage_service.dart';
import 'theme/app_theme.dart';
import 'screens/portfolio/portfolio_screen.dart';
import 'package:provider/provider.dart';
import 'providers/portfolio_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  final storageService = StorageService();
  await storageService.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => PortfolioProvider(storageService),
      child: const MyPortfolioApp(),
    ),
  );
}

class MyPortfolioApp extends StatelessWidget {
  const MyPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Portfolio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatelessWidget {
  const PortfolioHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PortfolioProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return const PortfolioScreen();
      },
    );
  }
}
