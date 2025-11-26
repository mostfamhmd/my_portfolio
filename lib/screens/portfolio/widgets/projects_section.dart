import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../widgets/gradient_card.dart';
import '../../../theme/app_colors.dart';

class ProjectsSection extends StatelessWidget {
  final Key? sectionKey;

  const ProjectsSection({super.key, this.sectionKey});

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortfolioProvider>();
    final projects = provider.projects;

    if (projects.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      key: sectionKey,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            Text(
              'Projects',
              style: Theme.of(context).textTheme.displaySmall,
            ).animate().fadeIn().slideY(begin: 0.2),

            const SizedBox(height: 48),

            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: projects.map((project) {
                return SizedBox(
                  width: 380,
                  child: GradientCard(
                    hasGlassEffect: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Project Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child:
                              project.imageUrl.isNotEmpty &&
                                  project.imageUrl.startsWith('http')
                              ? Image.network(
                                  project.imageUrl,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 200,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.image, size: 64),
                                    );
                                  },
                                )
                              : Container(
                                  height: 200,
                                  width: double.infinity,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image, size: 64),
                                ),
                        ),

                        const SizedBox(height: 16),

                        // Project Title
                        Text(
                          project.title,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 8),

                        // Project Description
                        Text(
                          project.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 16),

                        // Technologies
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: project.technologies.map((tech) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                tech,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 16),

                        // Links
                        Row(
                          children: [
                            if (project.playStoreUrl.isNotEmpty)
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      _launchUrl(project.playStoreUrl),
                                  icon: const Icon(Icons.android, size: 16),
                                  label: const Text('Play Store'),
                                ),
                              ),
                            if (project.playStoreUrl.isNotEmpty &&
                                project.appStoreUrl.isNotEmpty)
                              const SizedBox(width: 8),
                            if (project.appStoreUrl.isNotEmpty)
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      _launchUrl(project.appStoreUrl),
                                  icon: const Icon(Icons.apple, size: 16),
                                  label: const Text('App Store'),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 100.ms).scale(delay: 100.ms),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
