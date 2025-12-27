import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppError extends StatelessWidget {
  final String message;
  final bool isDark;
  final VoidCallback onPressed;
  const AppError({
    super.key,
    required this.message,
    required this.isDark,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              'Xatolik yuz berdi',
              style: GoogleFonts.beVietnamPro(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.beVietnamPro(
                fontSize: 16,
                color: isDark ? Colors.grey[400] : const Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF1B709),
                foregroundColor: const Color(0xFF221E10),
              ),
              onPressed: onPressed,
              child: const Text('Qayta urinish'),
            ),
          ],
        ),
      ),
    );
  }
}
