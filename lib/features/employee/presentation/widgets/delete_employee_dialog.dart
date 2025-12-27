import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:haru_pos/core/di/injection.dart';
import 'package:haru_pos/core/widgets/app_snack_bar.dart';
import 'package:haru_pos/features/employee/presentation/bloc/employee_bloc.dart';

class DeleteEmployeeDialog extends StatelessWidget {
  final int employeeId;
  final String employeeName;

  const DeleteEmployeeDialog({
    super.key,
    required this.employeeId,
    required this.employeeName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EmployeeBloc>(),
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Удалить сотрудника?',
          style: GoogleFonts.inter(fontSize: 18.0, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Вы уверены, что хотите удалить сотрудника "$employeeName"?',
          style: GoogleFonts.inter(
            fontSize: 14.0,
            color: const Color(0xFF6B7280),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            style: TextButton.styleFrom(foregroundColor: Colors.blue),
            child: const Text('Отмена'),
          ),
          BlocConsumer<EmployeeBloc, EmployeeState>(
            listener: (context, state) {
              if (state is EmployeeOperationSuccess) {
                Navigator.pop(context, true);
              } else if (state is EmployeeError) {
                AppSnackbar.error(context, state.message);
              }
            },
            builder: (context, state) {
              return TextButton(
                onPressed: state is EmployeeLoading
                    ? null
                    : () {
                        context.read<EmployeeBloc>().add(
                          DeleteEmployeeEvent(employeeId),
                        );
                      },
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                child: Text(
                  state is EmployeeLoading ? 'Удаление...' : 'Удалить',
                  style: GoogleFonts.inter(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
