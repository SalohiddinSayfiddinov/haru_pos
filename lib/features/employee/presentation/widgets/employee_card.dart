import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/utils/extensions.dart';
import 'package:haru_pos/features/employee/domain/entities/employee_entity.dart';

class EmployeeCard extends StatelessWidget {
  final EmployeeEntity employee;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onPenalty;

  const EmployeeCard({
    super.key,
    required this.employee,
    required this.onEdit,
    required this.onDelete,
    required this.onPenalty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFAEAEAE)),
        borderRadius: BorderRadius.circular(9),
      ),
      padding: const EdgeInsets.only(left: 15.0, bottom: 13.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: CircleAvatar(
                  radius: 21,
                  backgroundColor: Colors.transparent,
                  backgroundImage: employee.image.isNotEmpty
                      ? NetworkImage(employee.image)
                      : null,
                  child: employee.image.isEmpty
                      ? const Icon(Icons.person, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(width: 17),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Column(
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
                ),
              ),
              const SizedBox(width: 17),
              PopupMenuButton<String>(
                padding: const EdgeInsets.only(top: 15.0),
                icon: const Icon(Icons.more_vert),
                color: Colors.white,
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Изменить')),
                  const PopupMenuItem(value: 'delete', child: Text('Удалить')),
                  const PopupMenuItem(
                    value: 'penalty',
                    child: Text('Оштрафовать'),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    onDelete();
                  } else if (value == 'penalty') {
                    onPenalty();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Text(
            "Лимит: ${employee.limit.formatCurrency()}",
            style: GoogleFonts.inter(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: employee.limits.map((e) {
                  return Text.rich(
                    TextSpan(
                      text: '- ${e.money.formatCurrency()}  ',
                      style: GoogleFonts.inter(
                        fontSize: 14.0,  
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFFF5144),
                      ),
                      children: [
                        TextSpan(
                          text: e.createdAt,
                          style: GoogleFonts.inter(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
