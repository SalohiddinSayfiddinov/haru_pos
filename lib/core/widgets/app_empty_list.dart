import 'package:flutter/material.dart';

class AppEmptyList extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isDark;

  const AppEmptyList({
    super.key,
    required this.title,
    this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          if (subtitle != null)
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.grey[400] : const Color(0xFF666666),
              ),
            ),
        ],
      ),
    );
  }
}
