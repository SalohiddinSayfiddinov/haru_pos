import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/di/injection.dart';
import 'package:haru_pos/core/utils/extensions.dart';
import 'package:haru_pos/features/orders/domain/entities/orders_entity.dart';
import 'package:haru_pos/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<OrderBloc>()..add(const LoadOrdersHistoryEvent()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: context.pop,
                      icon: const Icon(Icons.arrow_back_ios),
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
                const SizedBox(height: 40.0),
                BlocBuilder<OrderBloc, OrderState>(
                  builder: (context, state) {
                    if (state is OrderLoading && !state.isLoadMore) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is OrderError) {
                      return Center(child: Text(state.message));
                    }

                    final orders = state.orders;

                    if (orders.isEmpty) {
                      return const Center(child: Text('История заказов пуста'));
                    }

                    return Card(
                      margin: EdgeInsets.zero,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.white,
                      child: DividerTheme(
                        data: const DividerThemeData(
                          thickness: 0,
                          color: Colors.transparent,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: DataTable(
                            dividerThickness: 0,
                            dataRowColor: WidgetStateProperty.all(Colors.white),
                            columns: [
                              _buildHeaderText('#'),
                              _buildHeaderText('Наименование'),
                              _buildHeaderText('Цена'),
                              _buildHeaderText('Официант'),
                              _buildHeaderText('Тип'),
                              _buildHeaderText('Дата'),
                            ],
                            rows: [
                              ...orders.map(
                                (order) =>
                                    DataRow(cells: _buildOrderRow(order)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DataColumn _buildHeaderText(String title) {
    return DataColumn(
      label: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF87888C),
        ),
      ),
    );
  }

  List<DataCell> _buildOrderRow(OrderEntity order) {
    final productsName = order.orderItems
        .map((e) => e.product.nameRu)
        .join(', ');

    return [
      DataCell(_buildRowText('#${order.id}')),
      DataCell(
        SizedBox(
          width: 200,
          child: Text(
            productsName,
            style: GoogleFonts.inter(
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      DataCell(_buildRowText(order.fullPrice.formatCurrencyUz())),
      DataCell(_buildRowText(order.user?.fullName ?? 'Неизвестно')),
      DataCell(_buildRowText(_mapOrderType(order.type))),
      DataCell(
        _buildRowText(DateFormat('dd.MM.yyyy HH:mm').format(order.createdAt)),
      ),
    ];
  }

  Widget _buildRowText(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(fontSize: 13.0, fontWeight: FontWeight.w500),
    );
  }

  String _mapOrderType(String type) {
    switch (type) {
      case 'dine_in':
        return 'В зале';
      case 'take_away':
        return 'С собой';
      case 'delivery':
        return 'Доставка';
      default:
        return type;
    }
  }
}
