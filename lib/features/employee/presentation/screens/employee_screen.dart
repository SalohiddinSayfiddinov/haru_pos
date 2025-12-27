import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/di/injection.dart';
import 'package:haru_pos/core/widgets/app_buttons.dart';
import 'package:haru_pos/core/widgets/app_snack_bar.dart';
import 'package:haru_pos/features/employee/presentation/bloc/employee_bloc.dart';
import 'package:haru_pos/features/employee/presentation/widgets/add_employee_dialog.dart';
import 'package:haru_pos/features/employee/presentation/widgets/delete_employee_dialog.dart';
import 'package:haru_pos/features/employee/presentation/widgets/employee_card.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EmployeeBloc>().add(LoadEmployeesEvent());
  }

  void _showAddEmployeeDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => getIt<EmployeeBloc>(),
        child: const AddEmployeeDialog(),
      ),
    );
    if (result == true && mounted) {
      context.read<EmployeeBloc>().add(LoadEmployeesEvent());
    }
  }

  void _showEditEmployeeDialog(employee) async {
    final result = await showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => getIt<EmployeeBloc>(),
        child: AddEmployeeDialog(employee: employee),
      ),
    );
    if (result == true && mounted) {
      context.read<EmployeeBloc>().add(LoadEmployeesEvent());
    }
  }

  void _showDeleteConfirmationDialog(
    int employeeId,
    String employeeName,
  ) async {
    final result = await showDialog(
      context: context,
      builder: (context) => DeleteEmployeeDialog(
        employeeId: employeeId,
        employeeName: employeeName,
      ),
    );
    if (result == true && mounted) {
      context.read<EmployeeBloc>().add(LoadEmployeesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<EmployeeBloc>(),
      child: BlocListener<EmployeeBloc, EmployeeState>(
        listener: (context, state) {
          if (state is EmployeeError) {
            AppSnackbar.error(context, state.message);
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Сотрудники',
                      style: GoogleFonts.inter(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    PrimaryButton(
                      height: 30.0,
                      textStyle: GoogleFonts.montserrat(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      title: 'Добавить сотрудника',
                      onPressed: _showAddEmployeeDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 40.0),
                _buildEmployeesGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeesGrid() {
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        if (state is EmployeeLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is EmployeeError) {
          return Center(
            child: Column(
              children: [
                Text(
                  'Ошибка загрузки сотрудников',
                  style: GoogleFonts.inter(fontSize: 16.0, color: Colors.red),
                ),
                const SizedBox(height: 10.0),
                PrimaryButton(
                  title: 'Попробовать снова',
                  onPressed: () {
                    context.read<EmployeeBloc>().add(LoadEmployeesEvent());
                  },
                ),
              ],
            ),
          );
        }

        if (state is EmployeesLoaded) {
          final employees = state.employees;

          if (employees.isEmpty) {
            return Center(
              child: Column(
                children: [
                  Text(
                    'Сотрудники не найдены',
                    style: GoogleFonts.inter(fontSize: 16.0),
                  ),
                  const SizedBox(height: 10.0),
                  PrimaryButton(
                    title: 'Добавить сотрудника',
                    onPressed: _showAddEmployeeDialog,
                  ),
                ],
              ),
            );
          }

          return Wrap(
            spacing: 25.0,
            runSpacing: 25.0,
            children: employees.map((employee) {
              return EmployeeCard(
                employee: employee,
                onEdit: () => _showEditEmployeeDialog(employee),
                onDelete: () => _showDeleteConfirmationDialog(
                  employee.id,
                  employee.fullName,
                ),
              );
            }).toList(),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
