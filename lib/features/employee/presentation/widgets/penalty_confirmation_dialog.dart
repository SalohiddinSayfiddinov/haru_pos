import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/utils/validators.dart';
import 'package:haru_pos/core/widgets/app_buttons.dart';
import 'package:haru_pos/core/widgets/app_snack_bar.dart';
import 'package:haru_pos/core/widgets/app_text_field.dart';
import 'package:haru_pos/features/employee/domain/entities/employee_entity.dart';
import 'package:haru_pos/features/employee/presentation/bloc/employee_bloc.dart';

class PenaltyConfirmationDialog extends StatefulWidget {
  final EmployeeEntity employee;

  const PenaltyConfirmationDialog({super.key, required this.employee});

  @override
  State<PenaltyConfirmationDialog> createState() =>
      _PenaltyConfirmationDialogState();
}

class _PenaltyConfirmationDialogState extends State<PenaltyConfirmationDialog> {
  final TextEditingController _penaltyController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _penaltyController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    final limit = int.parse(_penaltyController.text.replaceAll(' ', ''));

    context.read<EmployeeBloc>().add(
      UpdateLimitEvent(userId: widget.employee.id, limit: limit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFF9FAFB),
      content: Material(
        color: const Color(0xFFF9FAFB),
        child: SizedBox(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Оштрафовать сотрудника',
                    style: GoogleFonts.inter(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.clear),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Form(
                key: _formKey,
                child: AppTextField(
                  controller: _penaltyController,
                  hintText: 'Введите сумму штрафа',
                  isNumber: true,
                  contentPadding: const EdgeInsets.all(16.0),
                  hintStyle: GoogleFonts.inter(
                    fontSize: 13.0,
                    color: const Color(0xFF7A7A7A),
                  ),
                  textStyle: GoogleFonts.inter(fontSize: 13.0),
                  validator: Validators.simpleValidator,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        BlocConsumer<EmployeeBloc, EmployeeState>(
          listener: (context, state) {
            if (state is EmployeeOperationSuccess) {
              Navigator.pop(context, true);
            } else if (state is EmployeeError) {
              AppSnackbar.error(context, state.message);
            }
          },
          builder: (context, state) {
            return PrimaryButton(
              height: 30.0,
              title: state is EmployeeLoading ? 'Сохранение...' : 'Сохранить',
              textStyle: GoogleFonts.inter(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              onPressed: state is EmployeeLoading ? null : _onSave,
            );
          },
        ),
      ],
    );
  }
}
