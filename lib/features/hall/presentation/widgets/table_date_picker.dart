import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/assets/app_icons.dart';
import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:haru_pos/core/utils/date_extensions.dart';

class TableDatePicker extends StatelessWidget {
  final Function(DateTime date) onSelected;
  final DateTime selectedDate;
  const TableDatePicker({
    super.key,
    required this.onSelected,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.0),
      onTap: () async {
        var results = await showCalendarDatePicker2Dialog(
          dialogBackgroundColor: Colors.white,
          context: context,
          config: CalendarDatePicker2WithActionButtonsConfig(
            monthBuilder:
                ({
                  decoration,
                  isCurrentMonth,
                  isDisabled,
                  isSelected,
                  required month,
                  textStyle,
                }) {
                  return Container(
                    decoration: BoxDecoration(
                      color: isSelected == true
                          ? AppColors.primary
                          : Colors.transparent,
                      shape: isSelected == true
                          ? BoxShape.rectangle
                          : BoxShape.circle,
                      borderRadius: isSelected == true
                          ? BorderRadius.circular(
                              12.0,
                            ).copyWith(topLeft: Radius.circular(0))
                          : null,
                    ),
                    alignment: .center,
                    child: Text(
                      month.toString(),
                      style: GoogleFonts.nunitoSans(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        color: isSelected == true
                            ? Colors.white
                            : isDisabled == true
                            ? Color(0xFF757575)
                            : Color(0xFF202224),
                      ),
                    ),
                  );
                },
            yearBuilder:
                ({
                  decoration,
                  isCurrentYear,
                  isDisabled,
                  isSelected,
                  textStyle,
                  required year,
                }) {
                  return Container(
                    decoration: BoxDecoration(
                      color: isSelected == true
                          ? AppColors.primary
                          : Colors.transparent,
                      shape: isSelected == true
                          ? BoxShape.rectangle
                          : BoxShape.circle,
                      borderRadius: isSelected == true
                          ? BorderRadius.circular(
                              12.0,
                            ).copyWith(topLeft: Radius.circular(0))
                          : null,
                    ),
                    alignment: .center,
                    child: Text(
                      year.toString(),
                      style: GoogleFonts.nunitoSans(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        color: isSelected == true
                            ? Colors.white
                            : isDisabled == true
                            ? Color(0xFF757575)
                            : Color(0xFF202224),
                      ),
                    ),
                  );
                },
            modePickerBuilder:
                ({isMonthPicker, required monthDate, required viewMode}) {
                  return SizedBox();
                },
            weekdayLabelBuilder: ({isScrollViewTopHeader, required weekday}) {
              return Text(
                weekday.ruShortWeekday,
                textAlign: .center,
                style: GoogleFonts.nunitoSans(
                  color: Color(0xFF202224),
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
            firstDate: DateTime.now(),
            okButton: Container(
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: .center,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Применить',
                style: GoogleFonts.inter(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            cancelButton: Text(
              'Отменить',
              style: GoogleFonts.inter(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
            daySplashColor: Colors.white,
            dayBuilder:
                ({
                  required date,
                  decoration,
                  isDisabled,
                  isSelected,
                  isToday,
                  textStyle,
                }) {
                  return Container(
                    decoration: BoxDecoration(
                      color: isSelected == true
                          ? AppColors.primary
                          : Colors.transparent,
                      shape: isSelected == true
                          ? BoxShape.rectangle
                          : BoxShape.circle,
                      borderRadius: isSelected == true
                          ? BorderRadius.circular(
                              12.0,
                            ).copyWith(topLeft: Radius.circular(0))
                          : null,
                    ),
                    alignment: .center,
                    child: Text(
                      date.day.toString(),
                      style: GoogleFonts.nunitoSans(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        color: isSelected == true
                            ? Colors.white
                            : Color(0xFF757575),
                      ),
                    ),
                  );
                },
          ),
          dialogSize: const Size(325, 400),
          value: [selectedDate],
          borderRadius: BorderRadius.circular(15),
        );
        if (results?.first != null) {
          onSelected(results!.first!);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: AppColors.border),
        ),
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              selectedDate.toRuFancy(),
              style: GoogleFonts.inter(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF202224),
              ),
            ),
            SvgPicture.asset(AppIcons.calendar),
          ],
        ),
      ),
    );
  }
}
