import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../providers/portfolio_provider.dart';
import '../../../../widgets/gradient_card.dart';

class AboutSection extends StatelessWidget {
  final Key? sectionKey;

  const AboutSection({super.key, this.sectionKey});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortfolioProvider>();
    final personalInfo = provider.personalInfo;

    return Container(
      key: sectionKey,
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
                    type: InfoCardType.location,
                  ),
                if (personalInfo.email.isNotEmpty)
                  _InfoCard(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    value: personalInfo.email,
                    type: InfoCardType.email,
                  ),
                if (personalInfo.phone.isNotEmpty)
                  _InfoCard(
                    icon: Icons.phone_outlined,
                    title: 'Phone',
                    value: personalInfo.phone,
                    type: InfoCardType.phone,
                  ),
                if (personalInfo.cvUrl.isNotEmpty)
                  _InfoCard(
                    icon: Icons.description_outlined,
                    title: 'Download CV',
                    value: 'Resume',
                    type: InfoCardType.cv,
                    cvUrl: personalInfo.cvUrl,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum InfoCardType { location, email, phone, cv }

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final InfoCardType type;
  final String? cvUrl;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.type,
    this.cvUrl,
  });

  Future<void> _handleEmailTap(BuildContext context, String email) async {
    if (!context.mounted) return;

    try {
      final Uri emailUri = Uri(scheme: 'mailto', path: email);
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open email client')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  Future<void> _handleCvTap(BuildContext context, String cvUrl) async {
    if (!context.mounted) return;

    try {
      final Uri cvUri = Uri.parse(cvUrl);
      if (await canLaunchUrl(cvUri)) {
        await launchUrl(cvUri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open CV link')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _handlePhoneTap(BuildContext context, String phone) async {
    if (!context.mounted) return;

    // Show dialog to choose between call or WhatsApp
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Contact Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Call'),
                onTap: () async {
                  Navigator.pop(dialogContext);
                  try {
                    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
                    if (await canLaunchUrl(phoneUri)) {
                      await launchUrl(
                        phoneUri,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Could not open phone dialer'),
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat),
                title: const Text('WhatsApp'),
                onTap: () async {
                  Navigator.pop(dialogContext);
                  try {
                    // Remove all non-digit characters except + for WhatsApp
                    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
                    final Uri whatsappUri = Uri.parse(
                      'https://wa.me/$cleanPhone',
                    );
                    if (await canLaunchUrl(whatsappUri)) {
                      await launchUrl(
                        whatsappUri,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Could not open WhatsApp'),
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isClickable =
        type == InfoCardType.email || type == InfoCardType.phone || type == InfoCardType.cv;

    Widget cardContent = GradientCard(
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
    );

    if (isClickable) {
      cardContent = InkWell(
        onTap: () {
          if (!context.mounted) return;
          if (type == InfoCardType.email) {
            _handleEmailTap(context, value);
          } else if (type == InfoCardType.phone) {
            _handlePhoneTap(context, value);
          } else if (type == InfoCardType.cv && cvUrl != null) {
            _handleCvTap(context, cvUrl!);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: cardContent,
      );
    }

    return cardContent.animate().fadeIn(delay: 200.ms).scale(delay: 200.ms);
  }
}
