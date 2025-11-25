import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../../providers/portfolio_provider.dart';
import '../../../../widgets/gradient_card.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortfolioProvider>();
    final personalInfo = provider.personalInfo;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            Text(
              'About Me',
              style: Theme.of(context).textTheme.displaySmall,
            ).animate().fadeIn().slideY(begin: 0.2),

            const SizedBox(height: 48),

            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                if (personalInfo.location.isNotEmpty)
                  _InfoCard(
                    icon: Icons.location_on_outlined,
                    title: 'Location',
                    value: personalInfo.location,
                  ),
                if (personalInfo.email.isNotEmpty)
                  _InfoCard(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    value: personalInfo.email,
                  ),
                if (personalInfo.phone.isNotEmpty)
                  _InfoCard(
                    icon: Icons.phone_outlined,
                    title: 'Phone',
                    value: personalInfo.phone,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.bodySmall),
              Text(value, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).scale(delay: 200.ms);
  }
}
