import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../widgets/gradient_card.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortfolioProvider>();
    final skillsByCategory = provider.skillsByCategory;

    if (skillsByCategory.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Skills & Technologies',
              style: Theme.of(context).textTheme.displaySmall,
            ).animate().fadeIn().slideY(begin: 0.2),

            const SizedBox(height: 48),

            ...skillsByCategory.entries.map((entry) {
              return Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        entry.key,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: entry.value.map((skill) {
                        return SizedBox(
                          // width: 280,
                          child: GradientCard(
                            hasGlassEffect: false,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  skill.name,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                // const SizedBox(height: 12),
                                // Wrap(
                                //   spacing: 8,
                                //   runSpacing: 6,
                                //   children: [
                                //     Chip(
                                //       label: Text(
                                //         skill.category,
                                //         style: Theme.of(context)
                                //             .textTheme
                                //             .labelMedium,
                                //       ),
                                //       backgroundColor: AppColors.darkBackground
                                //           .withOpacity(0.05),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
