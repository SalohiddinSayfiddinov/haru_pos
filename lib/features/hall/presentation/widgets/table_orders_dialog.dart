import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:haru_pos/core/locale/locale_keys.g.dart';
import 'package:haru_pos/features/hall/presentation/widgets/table_order_card.dart';
import 'package:haru_pos/features/orders/domain/entities/orders_entity.dart';

class TableOrdersDialog extends StatefulWidget {
  final List<OrderEntity> orders;
  final int tableNumber;

  const TableOrdersDialog({
    super.key,
    required this.orders,
    required this.tableNumber,
  });

  @override
  State<TableOrdersDialog> createState() => _TableOrdersDialogState();
}

class _TableOrdersDialogState extends State<TableOrdersDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        LocaleKeys.hall_table_card_title.tr(
          args: [widget.tableNumber.toString()],
        ),
      ),
      content: SizedBox(
        width: 750,
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: widget.orders.map((order) {
              return TableOrderCard(
                order: order,
                onCloseOrder: () {},
                onUpdateOrder: () {},
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
