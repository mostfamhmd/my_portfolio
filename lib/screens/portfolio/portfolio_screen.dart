import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/hero_section.dart';
import 'widgets/about_section.dart';
import 'widgets/skills_section.dart';
import 'widgets/projects_section.dart';
import 'widgets/experience_section.dart';
import 'widgets/contact_section.dart';
import '../../providers/theme_provider.dart';
import '../../theme/app_colors.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final aboutSectionKey = GlobalKey();
  final projectsSectionKey = GlobalKey();

  void scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            child: Column(
              children: [
                HeroSection(
                  onViewProjects: () => scrollToSection(projectsSectionKey),
                  onContactMe: () => scrollToSection(aboutSectionKey),
                ),
                AboutSection(sectionKey: aboutSectionKey),
                const SkillsSection(),
                ProjectsSection(sectionKey: projectsSectionKey),
                const ExperienceSection(),
                const ContactSection(),
              ],
            ),
          ),

          // Theme toggle button
          Positioned(
            top: 24,
            right: 24,
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                final isDarkMode = Theme.of(context).brightness == Brightness.dark;
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Material(
                    color: isDarkMode
                        ? AppColors.darkSurface
                        : AppColors.lightSurface,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () => themeProvider.toggleTheme(),
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: 56,
                        height: 56,
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          isDarkMode ? Icons.light_mode : Icons.dark_mode,
                          color: isDarkMode
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
