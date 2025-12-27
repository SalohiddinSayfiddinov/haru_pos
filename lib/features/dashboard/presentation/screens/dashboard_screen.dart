import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/features/dashboard/data/models/mock_data.dart';
import 'package:haru_pos/features/dashboard/presentation/widgets/average_bill_section.dart';
import 'package:haru_pos/features/dashboard/presentation/widgets/employees_section.dart';
import 'package:haru_pos/features/dashboard/presentation/widgets/hall_section.dart';
import 'package:haru_pos/features/dashboard/presentation/widgets/profit_card.dart';
import 'package:haru_pos/features/dashboard/presentation/widgets/top_products_section.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Главный панель',
              style: GoogleFonts.inter(
                fontSize: 25.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 40.0),
            Row(
              spacing: 25.0,
              children: [
                ProfitCard(profitData: MockData.profitData),
                EmployeesSection(employees: MockData.employees),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              spacing: 25.0,
              children: [
                TopProductsSection(products: MockData.topProducts),
                AverageBillSection(averageBillData: MockData.averageBillData),
              ],
            ),
            SizedBox(height: 25.0),

            HallSection(orders: MockData.orders),
          ],
        ),
      ),
    );
  }
}
