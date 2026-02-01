import 'package:flutter/material.dart';

class VenueTitleRow extends StatefulWidget {
  final String name;

  const VenueTitleRow({super.key, required this.name});

  @override
  State<VenueTitleRow> createState() => _VenueTitleRowState();
}

class _VenueTitleRowState extends State<VenueTitleRow>
    with SingleTickerProviderStateMixin {
  bool isFavorite = false;

  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    _scale = TweenSequence(
      [
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.25), weight: 35),
        TweenSequenceItem(tween: Tween(begin: 1.25, end: 0.95), weight: 30),
        TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.0), weight: 35),
      ],
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _glow = Tween(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  void _toggle() {
    setState(() => isFavorite = !isFavorite);
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            widget.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ),
        GestureDetector(
          onTap: _toggle,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Transform.scale(
                scale: _scale.value,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      if (isFavorite)
                        BoxShadow(
                          color: Colors.pink.withOpacity(0.45),
                          blurRadius: _glow.value,
                          spreadRadius: 1,
                        ),
                    ],
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 28,
                    color: isFavorite ? Colors.pink : Colors.grey,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
