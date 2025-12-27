import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/features/dashboard/data/models/dashboard_model.dart';
import 'package:haru_pos/features/dashboard/presentation/widgets/dashboard_section_card.dart';

class EmployeesSection extends StatelessWidget {
  final List<Employee> employees;

  const EmployeesSection({super.key, required this.employees});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270.0,
      height: 255.0,
      child: DashboardSectionCard(
        title: 'Сотрудники',
        padding: const EdgeInsets.all(14.0),
        children: [
          const SizedBox(height: 14),
          ...employees.map((employee) => _buildEmployeeItem(employee)),
        ],
      ),
    );
  }

  Widget _buildEmployeeItem(Employee employee) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22.5,
            backgroundColor: Colors.grey.shade300,
            child: Text(
              employee.name.split(' ').map((e) => e[0]).join(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.name,
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                Text(
                  employee.position,
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    color: Color(0xFF646464),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
