import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Modern loading widget with pulsing dots animation
class ModernLoader extends StatefulWidget {
  final Color? color;
  final double size;
  final String? message;

  const ModernLoader({super.key, this.color, this.size = 50, this.message});

  @override
  State<ModernLoader> createState() => _ModernLoaderState();
}

class _ModernLoaderState extends State<ModernLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).primaryColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: widget.size * 2,
          height: widget.size,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (index) {
                  final delay = index * 0.2;
                  final value = (_controller.value - delay) % 1.0;
                  final scale = value < 0.5
                      ? 1.0 + (value * 2 * 0.5)
                      : 1.5 - ((value - 0.5) * 2 * 0.5);

                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: widget.size / 4,
                      height: widget.size / 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.withValues(
                          alpha: 0.3 + (scale - 1.0) * 0.7,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.3),
                            blurRadius: 8 * scale,
                            spreadRadius: 2 * scale,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
        if (widget.message != null) ...[
          const SizedBox(height: 16),
          Text(
            widget.message!,
            style: TextStyle(
              color: color.withValues(alpha: 0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

/// Pulsing placeholder (replaces shimmer)
class PulsingPlaceholder extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const PulsingPlaceholder({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<PulsingPlaceholder> createState() => _PulsingPlaceholderState();
}

class _PulsingPlaceholderState extends State<PulsingPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _opacity = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;

    return AnimatedBuilder(
      animation: _opacity,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            color: baseColor.withValues(alpha: _opacity.value),
          ),
        );
      },
    );
  }
}

/// Circular progress with gradient
class GradientCircularLoader extends StatefulWidget {
  final double size;
  final Color? color;
  final double strokeWidth;

  const GradientCircularLoader({
    super.key,
    this.size = 50,
    this.color,
    this.strokeWidth = 4,
  });

  @override
  State<GradientCircularLoader> createState() => _GradientCircularLoaderState();
}

class _GradientCircularLoaderState extends State<GradientCircularLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).primaryColor;

    return RotationTransition(
      turns: _controller,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: CustomPaint(
          painter: _GradientCirclePainter(
            color: color,
            strokeWidth: widget.strokeWidth,
          ),
        ),
      ),
    );
  }
}

class _GradientCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _GradientCirclePainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    const startAngle = -90.0 * (3.14159 / 180.0);
    const sweepAngle = 270.0 * (3.14159 / 180.0);

    final paint = Paint()
      ..shader = SweepGradient(
        colors: [color.withValues(alpha: 0.1), color],
        stops: const [0.0, 1.0],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect.deflate(strokeWidth / 2),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Skeleton loader for portfolio sections with fade animation
class PortfolioSkeleton extends StatefulWidget {
  final double? maxWidth;

  const PortfolioSkeleton({super.key, this.maxWidth});

  @override
  State<PortfolioSkeleton> createState() => _PortfolioSkeletonState();
}

class _PortfolioSkeletonState extends State<PortfolioSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth =
            widget.maxWidth ?? math.min(constraints.maxWidth, 1200.0);
        final heroTextWidth =
            (maxWidth * 0.7).clamp(220.0, maxWidth).toDouble();
        final sectionSpacing = maxWidth < 720 ? 32.0 : 48.0;
        final projectCardWidth = _projectCardWidth(maxWidth);

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: 0.3 + (_controller.value * 0.4),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero section skeleton
                    Center(
                      child: Column(
                        children: [
                          const PulsingPlaceholder(
                            width: 120,
                            height: 120,
                            borderRadius: BorderRadius.all(Radius.circular(60)),
                          ),
                          const SizedBox(height: 24),
                          PulsingPlaceholder(
                            width: heroTextWidth * 0.45,
                            height: 32,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          const SizedBox(height: 12),
                          PulsingPlaceholder(
                            width: heroTextWidth * 0.3,
                            height: 20,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          const SizedBox(height: 24),
                          PulsingPlaceholder(
                            width: heroTextWidth,
                            height: 60,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: sectionSpacing),

                    // Projects section skeleton
                    PulsingPlaceholder(
                      width: 150,
                      height: 28,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: List.generate(
                        3,
                        (index) => SizedBox(
                          width: projectCardWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PulsingPlaceholder(
                                width: double.infinity,
                                height: 200,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              const SizedBox(height: 12),
                              PulsingPlaceholder(
                                width: double.infinity,
                                height: 20,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              const SizedBox(height: 8),
                              PulsingPlaceholder(
                                width: 120,
                                height: 16,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: sectionSpacing),

                    // Skills section skeleton
                    PulsingPlaceholder(
                      width: 120,
                      height: 28,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: List.generate(
                        10,
                        (index) => PulsingPlaceholder(
                          width: 110,
                          height: 40,
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  double _projectCardWidth(double maxWidth) {
    if (maxWidth >= 1100) {
      return (maxWidth - 32) / 3;
    }
    if (maxWidth >= 780) {
      return (maxWidth - 16) / 2;
    }
    return maxWidth;
  }
}

/// Skeleton loader for list items
class SkeletonListItem extends StatelessWidget {
  final bool showAvatar;

  const SkeletonListItem({super.key, this.showAvatar = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showAvatar) ...[
            const PulsingPlaceholder(
              width: 50,
              height: 50,
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PulsingPlaceholder(
                  width: double.infinity,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                PulsingPlaceholder(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Immersive loading experience with animated background and skeleton
class PortfolioLoadingScreen extends StatelessWidget {
  final String? headline;
  final String? subhead;

  const PortfolioLoadingScreen({
    super.key,
    this.headline,
    this.subhead,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = headline ?? 'Crafting your portfolio';
    final subtitle =
        subhead ?? 'Fetching projects, experiences, and visual assets';

    return Scaffold(
      body: Stack(
        children: [
          const _AnimatedGradientBackdrop(),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 32),
                const ModernLoader(
                  size: 72,
                  message: 'Setting up your personal space...',
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _FrostedSurface(
                          child: PortfolioSkeleton(
                            maxWidth: 1200,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FrostedSurface extends StatelessWidget {
  final Widget child;

  const _FrostedSurface({required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: colorScheme.primary.withOpacity(0.15),
            ),
            gradient: LinearGradient(
              colors: [
                colorScheme.surface.withOpacity(0.75),
                colorScheme.surfaceVariant.withOpacity(0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 24,
                spreadRadius: 2,
                offset: const Offset(0, 12),
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _AnimatedGradientBackdrop extends StatefulWidget {
  const _AnimatedGradientBackdrop();

  @override
  State<_AnimatedGradientBackdrop> createState() =>
      _AnimatedGradientBackdropState();
}

class _AnimatedGradientBackdropState extends State<_AnimatedGradientBackdrop>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value * 2 * math.pi;
        final alignment1 = Alignment(
          math.cos(progress) * 0.6,
          math.sin(progress) * 0.6,
        );
        final alignment2 = Alignment(
          math.sin(progress / 2) * 0.8,
          math.cos(progress / 2) * 0.8,
        );
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: alignment1,
              end: alignment2,
              colors: [
                scheme.primary.withOpacity(0.25),
                scheme.secondary.withOpacity(0.2),
                scheme.tertiary.withOpacity(0.15),
              ],
            ),
          ),
          child: Stack(
            children: const [
              _BlurOrb(
                size: 220,
                alignment: Alignment(-0.8, -0.6),
                opacity: 0.35,
              ),
              _BlurOrb(
                size: 280,
                alignment: Alignment(0.7, -0.2),
                opacity: 0.25,
              ),
              _BlurOrb(
                size: 260,
                alignment: Alignment(-0.4, 0.8),
                opacity: 0.2,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BlurOrb extends StatelessWidget {
  final double size;
  final Alignment alignment;
  final double opacity;

  const _BlurOrb({
    required this.size,
    required this.alignment,
    this.opacity = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(opacity),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(opacity * 0.6),
              blurRadius: size * 0.6,
              spreadRadius: size * 0.15,
            ),
          ],
        ),
      ),
    );
  }
}
