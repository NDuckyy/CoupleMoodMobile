import 'package:flutter/material.dart';
import 'dart:math';

class Top1Podium extends StatelessWidget {
  final dynamic item;

  const Top1Podium({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final m1 = item.member1;
    final m2 = item.member2;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// 🔥 COUPLE NAME (CLEAN)
        Text(
          item.coupleName,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 1),

        /// AVATAR
        Transform.translate(
          offset: const Offset(0, 5),
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

        const SizedBox(height: 15),

        /// MEMBER NAME
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _name(m1.memberName),
            const SizedBox(width: 20),
            _name(m2.memberName),
          ],
        ),

        const SizedBox(height: 6),

        /// POINT
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B9A), Color(0xFFFF8E53)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "${item.totalPoints} CP",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 4),

        /// PODIUM
        _buildPodium(),
      ],
    );
  }

  Widget _buildPodium() {
    return SizedBox(
      height: 170,
      width: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // bóng mờ sàn
          Positioned(
            bottom: 12,
            child: Container(
              width: 230,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.20),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),

          // khối chính (thân podium)
          Container(
            width: 230,
            height: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFD54F), Color(0xFFFFA000)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  spreadRadius: 1,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Text(
              "1",
              style: TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),

          // top face
          Positioned(
            top: 0,
            child: Transform(
              alignment: Alignment.topCenter,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.006)
                ..rotateX(-pi / 4),
              child: Container(
                width: 190,
                height: 38,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFFFFC1), Color(0xFFFFF176)],
                  ),
                ),
              ),
            ),
          ),
        ],
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
        radius: 28,
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
        // maxLines: 1,
        // overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
