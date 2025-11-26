import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../theme/app_colors.dart';

class ContactSection extends StatelessWidget {
  final Key? sectionKey;

  const ContactSection({super.key, this.sectionKey});

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  IconData _getIconForPlatform(String platform) {
    final lowercasePlatform = platform.toLowerCase();
    if (lowercasePlatform.contains('github')) return Icons.code;
    if (lowercasePlatform.contains('linkedin')) return Icons.work;
    if (lowercasePlatform.contains('twitter') ||
        lowercasePlatform.contains('x')) {
      return Icons.message;
    }
    if (lowercasePlatform.contains('facebook')) return Icons.facebook;
    if (lowercasePlatform.contains('instagram')) return Icons.camera_alt;
    return Icons.link;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortfolioProvider>();
    final socialLinks = provider.socialLinks;
    final personalInfo = provider.personalInfo;

    return Container(
      key: sectionKey,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0x1A667eea), Color(0x1A764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            Text(
              'Get In Touch',
              style: Theme.of(context).textTheme.displaySmall,
            ).animate().fadeIn().slideY(begin: 0.2),

            const SizedBox(height: 48),

            if (socialLinks.isNotEmpty)
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: socialLinks.map((link) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _launchUrl(link.url),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getIconForPlatform(link.platform),
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                link.platform,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 100.ms).scale(delay: 100.ms);
                }).toList(),
              ),

            const SizedBox(height: 48),

            const Divider(),

            const SizedBox(height: 24),

            Text(
              '© ${DateTime.now().year} ${personalInfo.name.isEmpty ? 'Your Name' : personalInfo.name}. All rights reserved.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
