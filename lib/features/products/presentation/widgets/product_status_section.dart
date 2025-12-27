import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/widgets/app_text_field.dart';
import 'package:haru_pos/features/products/presentation/widgets/status_dropdown.dart';

class ProductStatusSection extends StatelessWidget {
  final List<String> statuses;
  final String? selectedStatus;
  final Function(String?) onStatusChanged;
  final TextEditingController commentController;

  const ProductStatusSection({
    super.key,
    required this.statuses,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.commentController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Статус продукта:',
          style: GoogleFonts.montserrat(
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 30.0),
        Expanded(
          child: Column(
            children: [
              StatusDropdown(
                statuses: statuses,
                selectedStatus: selectedStatus,
                onChanged: onStatusChanged,
              ),
              const SizedBox(height: 15.0),
              AppTextField(
                controller: commentController,
                hintText: 'Коментарий',
                maxLines: 4,
                hintStyle: GoogleFonts.montserrat(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF606060),
                ),
                textStyle: GoogleFonts.montserrat(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
