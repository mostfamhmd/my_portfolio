import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/hero_section.dart';
import 'widgets/about_section.dart';
import 'widgets/skills_section.dart';
import 'widgets/projects_section.dart';
import 'widgets/experience_section.dart';
import 'widgets/contact_section.dart';
import '../../theme/app_colors.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            child: Column(
              children: const [
                HeroSection(),
                AboutSection(),
                SkillsSection(),
                ProjectsSection(),
                ExperienceSection(),
                ContactSection(),
              ],
            ),
          ),

          // Floating dashboard button
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton.extended(
              onPressed: () => context.go('/dashboard'),
              backgroundColor: AppColors.lightPrimary,
              icon: const Icon(Icons.dashboard, color: Colors.white),
              label: const Text(
                'Dashboard',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
