import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../theme/app_colors.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortfolioProvider>();
    final experiences = provider.experiences;

    if (experiences.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort: current experience first, then by end date desc, then start date desc
    final sortedExperiences = experiences.toList()
      ..sort((a, b) {
        // Current (ongoing) experience always comes first
        if (a.isCurrent && !b.isCurrent) return -1;
        if (!a.isCurrent && b.isCurrent) return 1;

        // If both are current or both are not, sort by end date desc (null = ongoing)
        final aEnd = a.endDate ?? DateTime.now();
        final bEnd = b.endDate ?? DateTime.now();
        final endCompare = bEnd.compareTo(aEnd);
        if (endCompare != 0) return endCompare;

        // If end dates are equal, sort by start date desc
        return b.startDate.compareTo(a.startDate);
      });

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            Text(
              'Experience',
              style: Theme.of(context).textTheme.displaySmall,
            ).animate().fadeIn().slideY(begin: 0.2),

            const SizedBox(height: 48),

            ...sortedExperiences.asMap().entries.map((entry) {
              final index = entry.key;
              final exp = entry.value;
              final isWork = exp.type == 'work';

              return Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline indicator
                    Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: isWork
                                ? AppColors.primaryGradient
                                : AppColors.secondaryGradient,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isWork ? Icons.work_outline : Icons.school_outlined,
                            color: Colors.white,
                          ),
                        ),
                        if (index < sortedExperiences.length - 1)
                          Container(
                            width: 2,
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.lightPrimary,
                                  AppColors.lightPrimary.withOpacity(0.3),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(width: 24),

                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exp.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            exp.organization,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: AppColors.lightPrimary),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${DateFormat('MMM yyyy').format(exp.startDate)} - ${exp.isCurrent ? 'Present' : DateFormat('MMM yyyy').format(exp.endDate!)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (exp.location.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              exp.location,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                          const SizedBox(height: 12),
                          Text(
                            exp.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: -0.2),
              );
            }),
          ],
        ),
      ),
    );
  }
}
