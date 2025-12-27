import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/utils/extensions.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final List<_MockOrder> orders = [
    _MockOrder(
      number: 'Заказ #351',
      name: 'Роллы, суши нигири',
      price: 280500,
      waiter: 'Кобилов Одил',
      paymentType: 'Наличные',
      date: '20.11.2025',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: context.pop,
                  icon: Icon(Icons.arrow_back_ios),
                ),
                Text(
                  'История заказов',
                  style: GoogleFonts.inter(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.0),
            Card(
              margin: EdgeInsets.zero,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.white,
              child: DividerTheme(
                data: DividerThemeData(thickness: 0, color: Colors.transparent),
                child: DataTable(
                  dividerThickness: 0,
                  dataRowColor: WidgetStateProperty.all(Colors.white),
                  columns: [
                    _buildHeaderText('#'),
                    _buildHeaderText('Наименование'),
                    _buildHeaderText('Цена'),
                    _buildHeaderText('Официант'),
                    _buildHeaderText('Способ оплаты'),
                    _buildHeaderText('Дата'),
                  ],
                  rows: [
                    ...orders.map(
                      (order) => DataRow(cells: _buildOrderRow(order)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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

  List<DataCell> _buildOrderRow(_MockOrder order) {
    return [
      DataCell(_buildRowText(order.number)),
      DataCell(_buildRowText(order.name)),
      DataCell(_buildRowText(order.price.formatCurrency())),
      DataCell(_buildRowText(order.waiter)),
      DataCell(_buildRowText(order.paymentType)),
      DataCell(_buildRowText(order.date)),
    ];
  }

  Widget _buildRowText(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(fontSize: 13.0, fontWeight: FontWeight.w500),
    );
  }
}

class _MockOrder {
  final String number;
  final String name;
  final int price;
  final String waiter;
  final String paymentType;
  final String date;

  _MockOrder({
    required this.number,
    required this.name,
    required this.price,
    required this.waiter,
    required this.paymentType,
    required this.date,
  });
}
