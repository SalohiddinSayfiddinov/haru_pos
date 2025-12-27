import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:haru_pos/features/dashboard/data/models/dashboard_model.dart';
import 'package:haru_pos/features/dashboard/presentation/widgets/dashboard_section_card.dart';

class TopProductsSection extends StatelessWidget {
  final List<Product> products;

  const TopProductsSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 275.0,
      width: 780,
      child: DashboardSectionCard(
        title: 'Топ продукты',
        padding: EdgeInsets.all(14.0),
        children: [
          const SizedBox(height: 19),
          _buildTableHeader(),
          ...List.generate(products.length, (index) {
            final product = products[index];
            return _buildProductRow(product, index);
          }),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 4.0),
        SizedBox(width: 25, child: _buildHeaderText('#')),
        SizedBox(width: 60.0),
        SizedBox(width: 80, child: _buildHeaderText('Название')),
        SizedBox(width: 130.0),
        SizedBox(width: 250, child: _buildHeaderText('Популярность')),
        SizedBox(width: 100.0),
        SizedBox(width: 75, child: _buildHeaderText('Продажа')),
      ],
    );
  }

  Widget _buildHeaderText(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 15.0,
        fontWeight: FontWeight.w500,
        color: Color(0xFF87888C),
      ),
    );
  }

  Widget _buildProductRow(Product product, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 4.0),
          SizedBox(
            width: 30,
            child: Text(
              product.rank.toString().padLeft(2, '0'),
              style: GoogleFonts.inter(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 60.0),
          SizedBox(
            width: 85,
            child: Text(
              product.name,
              style: GoogleFonts.inter(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 130.0),
          SizedBox(
            width: 250,
            child: LinearProgressIndicator(
              value: product.salesPercentage / 100,
              borderRadius: BorderRadius.circular(4),
              color: _setColor(index),
              backgroundColor: AppColors.background,
            ),
          ),
          SizedBox(width: 100.0),
          SizedBox(
            width: 75,
            child: _buildSalerPercentage(
              product.salesPercentage,
              _setColor(index),
            ),
          ),
        ],
      ),
    );
  }

  Color _setColor(int index) {
    switch (index) {
      case 0:
        return Color(0xFFFCB859);
      case 1:
        return Color(0xFFA9DFD8);
      case 2:
        return Color(0xFF28AEF3);
      case 3:
        return Color(0xFFF2C8ED);

      default:
        return Color(0xFFFCB859);
    }
  }

  Widget _buildSalerPercentage(int salesPercentage, Color color) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 38.0,
        padding: EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: color),
        ),
        child: Center(
          child: Text(
            '$salesPercentage%',
            style: GoogleFonts.inter(
              color: color,
              fontSize: 10.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
