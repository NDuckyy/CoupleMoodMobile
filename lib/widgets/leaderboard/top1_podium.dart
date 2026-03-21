import 'package:flutter/material.dart';
import 'dart:math';

class Top1Podium extends StatefulWidget {
  final dynamic item;

  const Top1Podium({super.key, required this.item});

  @override
  State<Top1Podium> createState() => _Top1PodiumState();
}

class _Top1PodiumState extends State<Top1Podium>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(); // chạy infinite
  }

  @override
  Widget build(BuildContext context) {
    final m1 = widget.item.member1;
    final m2 = widget.item.member2;

    return Column(
      children: [
        /// 🔥 NEON COUPLE NAME
        AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            return ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: const [
                    Colors.amber,
                    Colors.orange,
                    Colors.yellow,
                    Colors.amber,
                  ],
                  stops: [
                    _controller.value,
                    _controller.value + 0.2,
                    _controller.value + 0.4,
                    _controller.value + 0.6,
                  ].map((e) => e % 1).toList(),
                ).createShader(bounds);
              },
              child: Text(
                widget.item.coupleName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 12),

        /// 🔥 SPOTLIGHT + CONTENT
        Stack(
          alignment: Alignment.topCenter,
          children: [
            /// LEFT LIGHT
            Positioned(
              left: 10,
              top: 0,
              child: Transform.rotate(angle: -pi / 6, child: _spotLight()),
            ),

            /// RIGHT LIGHT
            Positioned(
              right: 10,
              top: 0,
              child: Transform.rotate(angle: pi / 6, child: _spotLight()),
            ),

            /// CONTENT (avatar + podium)
            Column(
              children: [
                const SizedBox(height: 10),

                /// AVATAR + HEART (đè xuống gần podium)
                Transform.translate(
                  offset: const Offset(0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _avatar(m1.avatarUrl),
                      const SizedBox(width: 12),
                      const Icon(Icons.favorite, color: Colors.red, size: 28),
                      const SizedBox(width: 12),
                      _avatar(m2.avatarUrl),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                /// MEMBER NAMES
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _name(m1.memberName),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(Icons.favorite, size: 14, color: Colors.red),
                    ),
                    _name(m2.memberName),
                  ],
                ),

                const SizedBox(height: 8),

                /// POINT BADGE
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B9A), Color(0xFFFF8E53)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${widget.item.totalPoints} CP",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// 🔥 WIDE 3D PODIUM
                _wide3DPodium(),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// 🔥 PODIUM DÀI + 3D
  Widget _wide3DPodium() {
    return SizedBox(
      height: 130,
      width: 220, // 🔥 dài hơn
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// shadow
          Positioned(
            bottom: 0,
            child: Container(
              width: 180,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),

          /// back
          Transform.translate(
            offset: const Offset(0, -12),
            child: Container(
              width: 200,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.amber.shade200,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),

          /// front
          Container(
            width: 200,
            height: 90,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFC107), Color(0xFFFF8F00)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: const Text(
              "1",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          /// top face
          Positioned(
            top: 0,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(pi / 5),
              child: Container(
                width: 200,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 SPOTLIGHT
  Widget _spotLight() {
    return Container(
      width: 80,
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.yellow.withOpacity(0.4), Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _avatar(String? url) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: CircleAvatar(
        radius: 30,
        backgroundImage: url != null ? NetworkImage(url) : null,
        child: url == null ? const Icon(Icons.person) : null,
      ),
    );
  }

  Widget _name(String name) {
    return SizedBox(
      width: 90,
      child: Text(
        name,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
