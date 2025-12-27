import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:haru_pos/core/constants/app_colors.dart';

class CustomDatePicker extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const CustomDatePicker({super.key, required this.onDateSelected});

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              child: CalendarDatePicker2(
                config: CalendarDatePicker2Config(
                  selectedDayHighlightColor: AppColors.primary,
                  calendarType: CalendarDatePicker2Type.single,
                ),
                value: [selectedDate],

                // initialDate: selectedDate,
                // firstDate: DateTime.now(),
                // lastDate: DateTime.now().add(Duration(days: 7)),
                // onDateChanged: (date) {
                //   setState(() => selectedDate = date);
                // },
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                widget.onDateSelected(selectedDate);
              },
              child: const Text("Готово"),
            ),
          ],
        ),
      ),
    );
  }
}
