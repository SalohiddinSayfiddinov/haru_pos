import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:haru_pos/core/locale/locale_keys.g.dart';
import 'package:haru_pos/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:haru_pos/features/dashboard/presentation/widgets/dashboard_section_card.dart';

class TopProductsSection extends StatelessWidget {
  final List<TopProductEntity> products;

  const TopProductsSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 255,
        child: DashboardSectionCard(
          title: LocaleKeys.dashboard_top_products.tr(),
          padding: const EdgeInsets.all(14.0),
          children: [
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: DividerTheme(
                data: DividerThemeData(thickness: 0, color: Colors.transparent),
                child: DataTable(
                  dividerThickness: 0,
                  dataRowColor: WidgetStateProperty.all(Colors.white),
                  columnSpacing: 40,
                  headingTextStyle: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF87888C),
                  ),
                  dataTextStyle: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  columns: [
                    DataColumn(label: Text(LocaleKeys.dashboard_rank.tr())),
                    DataColumn(
                      label: Text(LocaleKeys.dashboard_product_name.tr()),
                    ),
                    DataColumn(
                      label: Text(LocaleKeys.dashboard_popularity.tr()),
                    ),
                    DataColumn(label: Text(LocaleKeys.dashboard_sales.tr())),
                  ],
                  rows: List.generate(products.length, (index) {
                    final product = products[index];
                    final color = _setColor(index);

                    return DataRow(
                      cells: [
                        DataCell(Text(product.id.toString().padLeft(2, '0'))),
                        DataCell(Text(product.name)),
                        DataCell(
                          SizedBox(
                            width: 200,
                            child: LinearProgressIndicator(
                              value: product.popularity / 100,
                              borderRadius: BorderRadius.circular(4),
                              color: color,
                              backgroundColor: AppColors.background,
                            ),
                          ),
                        ),
                        DataCell(
                          _buildSalesPercentage(
                            product.salesPercent.toInt(),
                            color,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _setColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFCB859);
      case 1:
        return const Color(0xFFA9DFD8);
      case 2:
        return const Color(0xFF28AEF3);
      case 3:
        return const Color(0xFFF2C8ED);
      default:
        return const Color(0xFFFCB859);
    }
  }

  Widget _buildSalesPercentage(int percent, Color color) {
    return Container(
      width: 55,
      height: 38,
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      alignment: Alignment.center,
      child: Text(
        '$percent%',
        style: GoogleFonts.inter(color: color, fontWeight: FontWeight.w500),
      ),
    );
  }
}
