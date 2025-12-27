import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardSectionCard extends StatelessWidget {
  final String title;
  final EdgeInsets padding;
  final List<Widget> children;
  const DashboardSectionCard({
    super.key,
    required this.title,
    required this.padding,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Colors.white,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}
