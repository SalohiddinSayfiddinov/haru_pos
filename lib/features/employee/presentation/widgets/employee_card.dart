import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/utils/extensions.dart';
import 'package:haru_pos/core/widgets/app_buttons.dart';
import 'package:haru_pos/features/employee/domain/entities/employee_entity.dart';

class EmployeeCard extends StatelessWidget {
  final EmployeeEntity employee;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EmployeeCard({
    super.key,
    required this.employee,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFAEAEAE)),
        borderRadius: BorderRadius.circular(9),
      ),
      padding: const EdgeInsets.all(15.0).copyWith(bottom: 13.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 21,
                backgroundImage: employee.image.isNotEmpty
                    ? NetworkImage(employee.image)
                    : null,
                child: employee.image.isEmpty
                    ? const Icon(Icons.person, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 17),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee.fullName,
                    style: GoogleFonts.inter(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    employee.role.roleToString(),
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF757575),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 22.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrimaryButton(
                onPressed: onDelete,
                height: 30.0,
                title: 'Удалить',
                textStyle: GoogleFonts.montserrat(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 20.0),
              PrimaryButton(
                onPressed: onEdit,
                height: 30.0,
                title: 'Изменить',
                textStyle: GoogleFonts.montserrat(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
