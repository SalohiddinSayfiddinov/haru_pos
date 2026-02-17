import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:haru_pos/core/locale/locale_keys.g.dart';
import 'package:haru_pos/core/utils/extensions.dart';
import 'package:haru_pos/features/dashboard/presentation/widgets/dashboard_section_card.dart';
import 'package:haru_pos/features/employee/domain/entities/employee_entity.dart';

class EmployeesSection extends StatelessWidget {
  final List<EmployeeEntity> employees;

  const EmployeesSection({super.key, required this.employees});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270.0,
      height: 255.0,
      child: DashboardSectionCard(
        title: LocaleKeys.dashboard_employees.tr(),
        padding: const EdgeInsets.all(14.0),
        children: [
          const SizedBox(height: 14),
          ...employees.map((employee) => _buildEmployeeItem(employee)),
        ],
      ),
    );
  }

  Widget _buildEmployeeItem(EmployeeEntity employee) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          _UserAvatar(user: employee),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.fullName.isNotEmpty
                      ? employee.fullName
                      : employee.username,
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                Text(
                  employee.role.roleToString(),
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

class _UserAvatar extends StatefulWidget {
  final EmployeeEntity user;
  const _UserAvatar({required this.user});

  @override
  State<_UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<_UserAvatar> {
  @override
  Widget build(BuildContext context) {
    final String displayName = (widget.user.fullName.isEmpty)
        ? widget.user.username
        : widget.user.fullName;

    return Tooltip(
      message: displayName,
      waitDuration: const Duration(milliseconds: 500),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: widget.user.image,
          fit: BoxFit.cover,
          width: 45,
          height: 45,
          errorWidget: (context, url, error) => CircleAvatar(
            backgroundColor: AppColors.primary,
            radius: 22,
            child: Text(
              widget.user.username[0].toUpperCase(),
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
