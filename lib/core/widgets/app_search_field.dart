import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/constants/app_colors.dart';

class SearchField extends StatelessWidget {
  final Function(String query)? onSearch;
  const SearchField({
    super.key,
    required TextEditingController searchController,
    this.onSearch,
  }) : _searchController = searchController;

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 388),
      child: TextField(
        onChanged: onSearch,
        controller: _searchController,
        style: GoogleFonts.inter(
          color: Colors.black,
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
        ),
        cursorColor: Colors.black,
        decoration: InputDecoration(
          hintText: 'Найти',

          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.5,
            vertical: 11.0,
          ),
          prefixIcon: Icon(Icons.search, size: 15.0),
          hintStyle: GoogleFonts.inter(color: Color(0xFF202224)),
          filled: true,
          fillColor: Color(0xFFF5F6FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Color(0xFFD5D5D5), width: .6),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: AppColors.error, width: .6),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Color(0xFFD5D5D5), width: .6),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Color(0xFFD5D5D5)),
          ),
        ),
      ),
    );
  }
}
