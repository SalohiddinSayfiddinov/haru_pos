import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/assets/app_icons.dart';
import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:intl/intl.dart';

class OrdersFilters extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? selectedStatus;
  final VoidCallback onSelectDateRange;
  final VoidCallback onClearDateRange;
  final ValueChanged<String?> onStatusSelected;
  final VoidCallback onRefresh;

  const OrdersFilters({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.selectedStatus,
    required this.onSelectDateRange,
    required this.onClearDateRange,
    required this.onStatusSelected,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 15.0,
      children: [
        _DateRangeFilter(
          startDate: startDate,
          endDate: endDate,
          onPressed: onSelectDateRange,
        ),
        if (startDate != null && endDate != null)
          _ClearDateButton(onPressed: onClearDateRange),
        _StatusFilter(
          selectedStatus: selectedStatus,
          onChanged: onStatusSelected,
        ),
        _RefreshButton(onPressed: onRefresh),
        const SizedBox.shrink(),
      ],
    );
  }
}

class _DateRangeFilter extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final VoidCallback onPressed;

  const _DateRangeFilter({
    required this.startDate,
    required this.endDate,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: SvgPicture.asset(AppIcons.calendar),
      label: Text(
        startDate != null
            ? (endDate != null
                  ? '${DateFormat('dd.MM.yyyy').format(startDate!)} - ${DateFormat('dd.MM.yyyy').format(endDate!)}'
                  : DateFormat('dd.MM.yyyy').format(startDate!))
            : 'Выбрать период',
        style: GoogleFonts.inter(fontSize: 13.0),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        side: BorderSide(color: AppColors.primary),
        foregroundColor: const Color(0xFF202224),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }
}

class _ClearDateButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ClearDateButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.close, size: 18.0),
      tooltip: 'Очистить фильтр',
      style: IconButton.styleFrom(
        backgroundColor: Colors.red.withValues(alpha: .1),
        foregroundColor: Colors.red,
      ),
    );
  }
}

class _StatusFilter extends StatelessWidget {
  final String? selectedStatus;
  final ValueChanged<String?> onChanged;

  const _StatusFilter({required this.selectedStatus, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.0,
      padding: const EdgeInsets.only(right: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButton2<String>(
        value: selectedStatus,
        iconStyleData: IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down, size: 18.0),
        ),
        underline: SizedBox(),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.white,
          ),
        ),
        hint: Text(
          'Все заказы',
          style: GoogleFonts.inter(
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF202224),
          ),
        ),
        items: [
          DropdownMenuItem<String>(
            value: null,
            child: Text(
              'Все заказы',
              style: GoogleFonts.inter(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF202224),
              ),
            ),
          ),
          DropdownMenuItem<String>(
            value: 'dine_in',
            child: Text(
              'В ресторане',
              style: GoogleFonts.inter(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF202224),
              ),
            ),
          ),
          DropdownMenuItem<String>(
            value: 'delivery',
            child: Text(
              'Доставка',
              style: GoogleFonts.inter(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF202224),
              ),
            ),
          ),
          DropdownMenuItem<String>(
            value: 'takeaway',
            child: Text(
              'С собой',
              style: GoogleFonts.inter(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF202224),
              ),
            ),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _RefreshButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.0,
      width: 30.0,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 0,
          padding: EdgeInsets.all(5.0),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        child: Icon(Icons.refresh),
      ),
    );
  }
}
