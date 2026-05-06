import 'package:flutter/material.dart';

class ProfileWhiteSheet extends StatelessWidget {
  final List<Widget> accountItems;
  final List<Widget> serviceItems;
  final List<Widget> otherItems;

  const ProfileWhiteSheet({
    super.key,
    required this.accountItems,
    required this.serviceItems,
    required this.otherItems,
  });

  Widget _section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 6),
        ...children,
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section("Tài khoản", accountItems),
            _section("Dịch vụ", serviceItems),
            _section("Khác", otherItems),
          ],
        ),
      ),
    );
  }
}
