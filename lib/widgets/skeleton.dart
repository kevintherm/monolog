import 'package:flutter/material.dart';
import '../theme/brutalist_theme.dart';

class SkeletonBox extends StatefulWidget {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final bool isCard;

  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.margin,
    this.isCard = false,
  });

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: widget.width,
        height: widget.height,
        margin: widget.margin,
        decoration: widget.isCard 
          ? MonoDecor.card(color: MonoColors.surfaceHigh) 
          : BoxDecoration(
              color: MonoColors.surfaceHigh,
              border: Border.all(color: MonoColors.border, width: 1),
            ),
      ),
    );
  }
}

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: MonoSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(height: 120, isCard: true),
          Gap.xl,
          const SkeletonBox(height: 100, isCard: true),
          Gap.xl,
          Row(
            children: [
              const SkeletonBox(width: 80, height: 20),
              const Spacer(),
              const SkeletonBox(width: 60, height: 20),
            ],
          ),
          Gap.md,
          const SkeletonBox(height: 80, isCard: true),
          Gap.sm,
          const SkeletonBox(height: 80, isCard: true),
          Gap.xl,
          const SkeletonBox(width: 100, height: 20),
          Gap.md,
          const SkeletonBox(height: 80, isCard: true),
        ],
      ),
    );
  }
}

class HistorySkeleton extends StatelessWidget {
  const HistorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(MonoSpacing.base),
      itemCount: 6,
      separatorBuilder: (context, index) => Gap.md,
      itemBuilder: (context, index) => const SkeletonBox(height: 90, isCard: true),
    );
  }
}
