import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/utils/validators.dart';
import 'package:haru_pos/core/widgets/app_buttons.dart';
import 'package:haru_pos/core/widgets/app_snack_bar.dart';
import 'package:haru_pos/core/widgets/app_text_field.dart';
import 'package:haru_pos/features/hall/domain/entities/table_entity.dart';
import 'package:haru_pos/features/hall/presentation/bloc/table_bloc.dart';

class AddTableDialog extends StatefulWidget {
  final TableEntity? table;

  const AddTableDialog({super.key, this.table});

  bool get isEdit => table != null;

  @override
  State<AddTableDialog> createState() => _AddTableDialogState();
}

class _AddTableDialogState extends State<AddTableDialog> {
  final TextEditingController _tableNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _tableNumberController.text = widget.table!.tableNumber.toString();
    }
  }

  @override
  void dispose() {
    _tableNumberController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    final tableNumber = int.tryParse(_tableNumberController.text.trim());
    if (tableNumber == null) {
      AppSnackbar.error(context, 'Введите корректный номер стола');
      return;
    }

    if (widget.isEdit) {
      _updateTable(tableNumber);
    } else {
      _createTable(tableNumber);
    }
  }

  void _createTable(int tableNumber) {
    context.read<TableBloc>().add(CreateTableEvent(tableNumber: tableNumber));
  }

  void _updateTable(int tableNumber) {
    context.read<TableBloc>().add(
      UpdateTableEvent(
        id: widget.table!.id,
        tableNumber: tableNumber,
        status: widget.table!.status,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Material(
        color: Colors.white,
        child: SizedBox(
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isEdit ? 'Изменить стол' : 'Добавить стол',
                    style: GoogleFonts.nunitoSans(
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
              Form(
                key: _formKey,
                child: AppTextField(
                  controller: _tableNumberController,
                  hintText: 'Номер стола',
                  contentPadding: const EdgeInsets.all(16.0),
                  hintStyle: GoogleFonts.inter(
                    fontSize: 13.0,
                    color: const Color(0xFF7A7A7A),
                  ),
                  textStyle: GoogleFonts.inter(fontSize: 13.0),
                  keyboardType: TextInputType.number,
                  validator: Validators.simpleValidator,
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
      actions: [
        BlocConsumer<TableBloc, TableState>(
          listener: (context, state) {
            if (state is TableOperationSuccess) {
              Navigator.pop(context, true);
            } else if (state is TableError) {
              AppSnackbar.error(context, state.message);
            }
          },
          builder: (context, state) {
            return PrimaryButton(
              height: 30.0,
              title: state is TableLoading ? 'Сохранение...' : 'Сохранить',
              textStyle: GoogleFonts.inter(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              onPressed: state is TableLoading ? null : _onSave,
            );
          },
        ),
      ],
    );
  }
}
