import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/constants/app_colors.dart';

class StatusDropdown extends StatelessWidget {
  final List<String> statuses;
  final String? selectedStatus;
  final Function(String?) onChanged;

  const StatusDropdown({
    super.key,
    required this.statuses,
    required this.selectedStatus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      iconStyleData: const IconStyleData(icon: Icon(Icons.keyboard_arrow_down)),
      style: GoogleFonts.montserrat(
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        width: 200.0,
      ),
      decoration: _buildInputDecoration(),
      hint: Text(
        'Выберите статус',
        style: GoogleFonts.montserrat(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF606060),
        ),
      ),
      value: selectedStatus,
      items: statuses.map((status) {
        return DropdownMenuItem(value: status, child: Text(status));
      }).toList(),
      onChanged: onChanged,
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18.0),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border, width: .6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
    );
  }
}
