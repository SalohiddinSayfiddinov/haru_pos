import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/utils/validators.dart';
import 'package:haru_pos/core/widgets/app_buttons.dart';
import 'package:haru_pos/core/widgets/app_snack_bar.dart';
import 'package:haru_pos/core/widgets/app_text_field.dart';
import 'package:haru_pos/features/hall/domain/entities/table_entity.dart';
import 'package:haru_pos/features/hall/presentation/bloc/table_bloc.dart';
import 'package:haru_pos/features/hall/presentation/widgets/table_date_picker.dart';

class ReserveTableDialog extends StatefulWidget {
  final TableEntity table;

  const ReserveTableDialog({super.key, required this.table});

  @override
  State<ReserveTableDialog> createState() => _AddTableDialogState();
}

class _AddTableDialogState extends State<ReserveTableDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    _reserveTable();
  }

  void _reserveTable() {
    context.read<TableBloc>().add(
      BookTableEvent(
        dateAndTime: _selectedDate.toString(),
        phoneNumber: _phoneController.text
            .replaceAll('(', '')
            .replaceAll(')', '')
            .replaceAll(' ', ''),
        fullName: _nameController.text,
        tableId: widget.table.id,
      ),
    );
  }

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: SizedBox(
        width: 750,
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Стол ${widget.table.tableNumber}',
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
            Form(
              key: _formKey,
              child: Column(
                spacing: 10,
                children: [
                  AppTextField(
                    controller: _nameController,
                    hintText: 'Введите имя клиента',
                    contentPadding: const EdgeInsets.all(16.0),
                    hintStyle: GoogleFonts.inter(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF7A7A7A),
                    ),
                    textStyle: GoogleFonts.inter(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                    ),
                    keyboardType: TextInputType.number,
                    validator: Validators.simpleValidator,
                  ),
                  AppTextField(
                    controller: _phoneController,
                    hintText: 'Введите номер телефона клиента',
                    contentPadding: const EdgeInsets.all(16.0),
                    isPhone: true,
                    hintStyle: GoogleFonts.inter(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF7A7A7A),
                    ),
                    textStyle: GoogleFonts.inter(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                    ),
                    keyboardType: TextInputType.number,
                    validator: Validators.simpleValidator,
                  ),
                ],
              ),
            ),
            TableDatePicker(
              onSelected: (date) async {
                final time = await showTimePicker(
                  initialEntryMode: TimePickerEntryMode.inputOnly,
                  context: context,
                  initialTime: _selectedTime,
                );
                if (time != null) {
                  setState(() {
                    _selectedDate = date;
                    _selectedTime = time;
                    _selectedDate = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time.hour,
                      time.minute,
                    );
                  });
                }
              },
              selectedDate: _selectedDate,
            ),
          ],
        ),
      ),
      actions: [
        BlocConsumer<TableBloc, TableState>(
          listener: (context, state) {
            if (state is TableOperationSuccess) {
              AppSnackbar.success(context, state.message);
              Navigator.pop(context, true);
            } else if (state is TableError) {
              AppSnackbar.error(context, state.message);
            }
          },
          builder: (context, state) {
            return PrimaryButton(
              height: 30.0,
              title: state is TableLoading ? 'Бронирование...' : 'Бронировать',
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
