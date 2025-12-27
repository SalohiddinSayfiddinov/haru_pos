import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/widgets/app_buttons.dart';
import 'package:haru_pos/core/widgets/app_snack_bar.dart';
import 'package:haru_pos/features/employee/domain/entities/employee_entity.dart';
import 'package:haru_pos/features/employee/presentation/bloc/employee_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'employee_form_fields.dart';

class AddEmployeeDialog extends StatefulWidget {
  final EmployeeEntity? employee;

  const AddEmployeeDialog({super.key, this.employee});

  bool get isEdit => employee != null;

  @override
  State<AddEmployeeDialog> createState() => _AddEmployeeDialogState();
}

class _AddEmployeeDialogState extends State<AddEmployeeDialog> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _initializeEditData();
    }
  }

  void _initializeEditData() {
    final employee = widget.employee!;
    _fullNameController.text = employee.fullName;
    _usernameController.text = employee.username;
    _selectedRole = employee.role;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    if (!widget.isEdit && _selectedImage == null) {
      AppSnackbar.error(context, 'Выберите изображение');
      return;
    }

    if (_selectedRole == null) {
      AppSnackbar.error(context, 'Выберите должность');
      return;
    }

    if (widget.isEdit) {
      _updateEmployee();
    } else {
      _createEmployee();
    }
  }

  void _createEmployee() {
    context.read<EmployeeBloc>().add(
      CreateEmployeeEvent(
        fullName: _fullNameController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
        role: _selectedRole!,
        imagePath: _selectedImage!.path,
      ),
    );
  }

  void _updateEmployee() {
    context.read<EmployeeBloc>().add(
      UpdateEmployeeEvent(
        id: widget.employee!.id,
        fullName: _fullNameController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
        role: _selectedRole!,
        imagePath: _selectedImage?.path ?? '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFF9FAFB),
      content: Material(
        color: const Color(0xFFF9FAFB),
        child: SizedBox(
          width: 750,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isEdit
                        ? 'Изменить сотрудника'
                        : 'Добавить сотрудника',
                    style: GoogleFonts.inter(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: _pickImage,
                    borderRadius: BorderRadius.circular(100),
                    child: CircleAvatar(
                      radius: 40.0,
                      backgroundColor: const Color(0xFFECECEE),
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : (widget.isEdit && widget.employee!.image.isNotEmpty
                                ? NetworkImage(widget.employee!.image)
                                : null),
                      child:
                          _selectedImage == null &&
                              (!widget.isEdit || widget.employee!.image.isEmpty)
                          ? const Icon(
                              CupertinoIcons.camera_fill,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 43),
                  Expanded(
                    child: EmployeeFormFields(
                      formKey: _formKey,
                      fullNameController: _fullNameController,
                      usernameController: _usernameController,
                      passwordController: _passwordController,
                      selectedRole: _selectedRole,
                      onRoleChanged: (role) {
                        setState(() {
                          _selectedRole = role;
                        });
                      },
                      isEdit: widget.isEdit,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
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
