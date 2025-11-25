import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/custom_button.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortfolioProvider>();
    final personalInfo = provider.personalInfo;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.darkBackground,
                  AppColors.darkSurface,
                  AppColors.darkBackground,
                ]
              : [
                  AppColors.lightBackground,
                  Colors.white,
                  AppColors.lightBackground,
                ],
        ),
      ),
      child: Stack(
        children: [
          // Animated background circles
          Positioned(
            top: -100,
            right: -100,
            child: Opacity(
              opacity: 0.1,
              child:
                  Container(
                        width: 400,
                        height: 400,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                        ),
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(
                        duration: 3000.ms,
                        color: Colors.white.withOpacity(0.3),
                      ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -150,
            child: Opacity(
              opacity: 0.1,
              child:
                  Container(
                        width: 500,
                        height: 500,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.secondaryGradient,
                        ),
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(
                        duration: 4000.ms,
                        delay: 1000.ms,
                        color: Colors.white.withOpacity(0.3),
                      ),
            ),
          ),

          // Content
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile Photo
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.primaryGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.lightPrimary.withOpacity(0.5),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(5),
                      child: CircleAvatar(
                        radius: 95,
                        backgroundImage:
                            personalInfo.photoUrl.isNotEmpty &&
                                personalInfo.photoUrl.startsWith('http')
                            ? NetworkImage(personalInfo.photoUrl)
                            : null,
                        backgroundColor: Colors.grey[300],
                        child:
                            personalInfo.photoUrl.isEmpty ||
                                !personalInfo.photoUrl.startsWith('http')
                            ? Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.grey[600],
                              )
                            : null,
                      ),
                    ).animate().scale(
                      duration: 600.ms,
                      curve: Curves.easeOutBack,
                    ),

                    const SizedBox(height: 40),

                    // Name
                    Text(
                          personalInfo.name.isEmpty
                              ? 'Your Name'
                              : personalInfo.name,
                          style: Theme.of(context).textTheme.displayMedium,
                          textAlign: TextAlign.center,
                        )
                        .animate()
                        .fadeIn(duration: 800.ms)
                        .slideY(begin: 0.3, duration: 800.ms),

                    const SizedBox(height: 16),

                    // Title
                    Text(
                          personalInfo.title.isEmpty
                              ? 'Flutter Developer'
                              : personalInfo.title,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.lightPrimary,
                              ),
                          textAlign: TextAlign.center,
                        )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 800.ms)
                        .slideY(begin: 0.3, duration: 800.ms),

                    const SizedBox(height: 32),

                    // Bio
                    Container(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Text(
                            personalInfo.bio.isEmpty
                                ? 'Add your bio here. Talk about your passion and what makes you unique.'
                                : personalInfo.bio,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 800.ms)
                        .slideY(begin: 0.3, duration: 800.ms),

                    const SizedBox(height: 48),

                    // Action Buttons
                    Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          alignment: WrapAlignment.center,
                          children: [
                            CustomButton(
                              text: 'View Projects',
                              onPressed: () {
                                Scrollable.ensureVisible(
                                  context,
                                  duration: const Duration(milliseconds: 800),
                                  curve: Curves.easeInOut,
                                );
                              },
                              icon: const Icon(Icons.work_outline, size: 20),
                            ),
                            CustomButton(
                              text: 'Contact Me',
                              onPressed: () {
                                // Scroll to contact section
                              },
                              isOutlined: true,
                              icon: const Icon(Icons.mail_outline, size: 20),
                            ),
                          ],
                        )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 800.ms)
                        .slideY(begin: 0.3, duration: 800.ms),

                    const SizedBox(height: 80),

                    // Scroll indicator
                    Column(
                      children: [
                        Text(
                          'Scroll Down',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        const Icon(Icons.keyboard_arrow_down, size: 32)
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .moveY(
                              begin: 0,
                              end: 10,
                              duration: 1500.ms,
                              curve: Curves.easeInOut,
                            ),
                      ],
                    ).animate().fadeIn(delay: 1000.ms, duration: 800.ms),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
