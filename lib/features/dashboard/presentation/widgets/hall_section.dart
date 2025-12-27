import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:haru_pos/features/dashboard/data/models/dashboard_model.dart';
import 'package:haru_pos/features/dashboard/presentation/widgets/dashboard_section_card.dart';

class HallSection extends StatelessWidget {
  final List<Order> orders;

  const HallSection({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return DashboardSectionCard(
      title: 'Зал',
      padding: const EdgeInsets.all(14.0),
      children: [
        DividerTheme(
          data: DividerThemeData(thickness: 0, color: Colors.transparent),
          child: DataTable(
            dividerThickness: 0,
            dataRowColor: WidgetStateProperty.all(Colors.white),
            columns: [
              _buildHeaderText('#'),
              _buildHeaderText('Заказ'),
              _buildHeaderText('Цена'),
              _buildHeaderText('Официант'),
              _buildHeaderText('Статус'),
            ],
            rows: [
              ...orders.map((order) => DataRow(cells: _buildOrderRow(order))),
            ],
          ),
        ),
      ],
    );
  }

  DataColumn _buildHeaderText(String title) {
    return DataColumn(
      columnWidth: FlexColumnWidth(),
      label: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
          color: Color(0xFF87888C),
        ),
      ),
    );
  }

  List<DataCell> _buildOrderRow(Order order) {
    return [
      DataCell(_buildRowText(order.tableNumber.toString().padLeft(2, '0'))),
      DataCell(_buildRowText(order.items)),
      DataCell(_buildRowText(order.price)),
      DataCell(_buildRowText(order.waiter)),
      DataCell(_buildStatusIndicator(order.status)),
    ];
  }

  Widget _buildRowText(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(fontSize: 13.0, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildStatusIndicator(OrderStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFFD9D9D9)),
      ),
      child: Row(
        spacing: 11.0,
        children: [
          CircleAvatar(radius: 3, backgroundColor: _setColor(status)),
          _buildRowText(_setText(status)),
        ],
      ),
    );
  }

  String _setText(OrderStatus status) {
    switch (status) {
      case OrderStatus.notPaid:
        return 'Не оплачен';
      case OrderStatus.empty:
        return 'Пусто';
      case OrderStatus.free:
        return 'Free';
    }
  }

  Color _setColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.notPaid:
        return AppColors.error;
      case OrderStatus.empty:
        return Color(0xFFFFC300);
      case OrderStatus.free:
        return Color(0xFFFFC300);
    }
  }
}
