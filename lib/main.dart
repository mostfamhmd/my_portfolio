import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'services/storage_service.dart';
import 'models/personal_info.dart';
import 'models/skill.dart';
import 'models/project.dart';
import 'models/experience.dart';
import 'models/social_link.dart';
import 'theme/app_theme.dart';
import 'screens/portfolio/portfolio_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  final storageService = StorageService();
  await storageService.init();

  runApp(MyPortfolioApp(storageService: storageService));
}

class MyPortfolioApp extends StatelessWidget {
  final StorageService storageService;

  const MyPortfolioApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Portfolio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: PortfolioHome(storageService: storageService),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  final StorageService storageService;

  const PortfolioHome({super.key, required this.storageService});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  late PersonalInfo personalInfo;
  late List<Skill> skills;
  late List<Project> projects;
  late List<Experience> experiences;
  late List<SocialLink> socialLinks;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    personalInfo = await widget.storageService.getPersonalInfo();
    skills = await widget.storageService.getSkills();
    projects = await widget.storageService.getProjects();
    experiences = await widget.storageService.getExperiences();
    socialLinks = await widget.storageService.getSocialLinks();

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return PortfolioScreen();
  }
}
