import 'package:flutter/material.dart';

class AnimatedChallengeItem extends StatefulWidget {
  final Widget Function(VoidCallback triggerAction) builder;
  final Future<bool> Function()? onAction;

  const AnimatedChallengeItem({
    super.key,
    required this.builder,
    this.onAction,
  });

  @override
  State<AnimatedChallengeItem> createState() => _AnimatedChallengeItemState();
}

class _AnimatedChallengeItemState extends State<AnimatedChallengeItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> scale;
  late final Animation<double> opacity;

  bool isAnimating = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.05,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.05,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInBack)),
        weight: 70,
      ),
    ]).animate(controller);

    opacity = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
  }

  Future<void> runAction() async {
    if (widget.onAction == null || isAnimating) return;

    isAnimating = true;

    await controller.forward();

    final success = await widget.onAction!();

    /// nếu fail thì rollback animation
    if (!success && mounted) {
      await controller.reverse();
      isAnimating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacity,
      child: ScaleTransition(
        scale: scale,
        alignment: Alignment.center,
        child: widget.builder(runAction),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
