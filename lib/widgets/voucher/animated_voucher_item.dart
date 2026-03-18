import 'package:flutter/material.dart';

class AnimatedVoucherItem extends StatefulWidget {
  final Widget child;
  final int index;

  const AnimatedVoucherItem({
    super.key,
    required this.child,
    required this.index,
  });

  @override
  State<AnimatedVoucherItem> createState() => _AnimatedVoucherItemState();
}

class _AnimatedVoucherItemState extends State<AnimatedVoucherItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> scale;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    /// POP EFFECT: 1 → 1.10 → 0.97 → 1
    scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.9,
          end: 1.10,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.10,
          end: 0.97,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.97,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 30,
      ),
    ]).animate(controller);

    /// delay theo index → stagger effect
    Future.delayed(Duration(milliseconds: 80 * widget.index), () {
      if (mounted) controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      alignment: Alignment.center,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
