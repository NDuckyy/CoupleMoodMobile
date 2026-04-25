import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MoodButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback onTap;

  const MoodButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 320,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: [Color(0xFF8093F1), Color(0xFFB388EB)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.balooChettan2(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
