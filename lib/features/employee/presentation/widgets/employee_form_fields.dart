import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:haru_pos/core/utils/extensions.dart';
import 'package:haru_pos/core/utils/validators.dart';
import 'package:haru_pos/core/widgets/app_text_field.dart';

class EmployeeFormFields extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final String? selectedRole;
  final ValueChanged<String?> onRoleChanged;
  final bool isEdit;

  const EmployeeFormFields({
    super.key,
    required this.formKey,
    required this.fullNameController,
    required this.usernameController,
    required this.passwordController,
    required this.selectedRole,
    required this.onRoleChanged,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> roles = ['WAITER', 'CASHIER', 'ADMIN'];

    return Form(
      key: formKey,
      child: Column(
        children: [
          AppTextField(
            controller: fullNameController,
            hintText: 'Напишите ФИО сотрудника',
            contentPadding: const EdgeInsets.all(16.0),
            hintStyle: GoogleFonts.inter(
              fontSize: 13.0,
              color: const Color(0xFF7A7A7A),
            ),
            textStyle: GoogleFonts.inter(fontSize: 13.0),
            validator: Validators.simpleValidator,
          ),
          const SizedBox(height: 11.0),
          DropdownButtonFormField2<String>(
            items: roles.map((role) {
              return DropdownMenuItem(
                value: role,
                child: Text(
                  role.roleToString(),
                  style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF646464),
                    fontSize: 13.0,
                  ),
                ),
              );
            }).toList(),
            value: selectedRole,
            hint: Text(
              'Выберите должность',
              style: GoogleFonts.inter(
                fontSize: 13.0,
                color: const Color(0xFF7A7A7A),
              ),
            ),
            style: GoogleFonts.nunitoSans(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF646464),
              fontSize: 13.0,
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(Icons.keyboard_arrow_down, size: 12.0),
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
              ),
            ),
            decoration: _buildInputDecoration(),
            onChanged: onRoleChanged,
            validator: Validators.simpleValidator,
          ),
          const SizedBox(height: 11.0),
          AppTextField(
            controller: usernameController,
            hintText: 'Придумайте логин',
            contentPadding: const EdgeInsets.all(16.0),
            hintStyle: GoogleFonts.inter(
              fontSize: 13.0,
              color: const Color(0xFF7A7A7A),
            ),
            textStyle: GoogleFonts.inter(fontSize: 13.0),
            validator: Validators.simpleValidator,
          ),
          const SizedBox(height: 11.0),
          AppTextField(
            controller: passwordController,
            hintText: isEdit
                ? 'Новый пароль (оставьте пустым чтобы не менять)'
                : 'Придумайте пароль',
            contentPadding: const EdgeInsets.all(16.0),
            hintStyle: GoogleFonts.inter(
              fontSize: 13.0,
              color: const Color(0xFF7A7A7A),
            ),
            textStyle: GoogleFonts.inter(fontSize: 13.0),
            obscureText: true,
            validator: isEdit ? null : Validators.simpleValidator,
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.only(right: 16.0),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border, width: .6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
    );
  }
}
