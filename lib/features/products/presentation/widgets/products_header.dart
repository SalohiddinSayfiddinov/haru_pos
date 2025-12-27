import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/widgets/app_buttons.dart';
import 'package:haru_pos/core/widgets/app_search_field.dart';

class ProductsHeader extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearch;
  final VoidCallback onAddProduct;

  const ProductsHeader({
    super.key,
    required this.searchController,
    required this.onSearch,
    required this.onAddProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Продукты',
          style: GoogleFonts.inter(fontSize: 25.0, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          width: 300,
          child: SearchField(
            searchController: searchController,
            onSearch: onSearch,
          ),
        ),
        PrimaryButton(
          width: 185.0,
          height: 30.0,
          textStyle: GoogleFonts.montserrat(
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          title: 'Добавить продукт',
          onPressed: onAddProduct,
        ),
      ],
    );
  }
}
