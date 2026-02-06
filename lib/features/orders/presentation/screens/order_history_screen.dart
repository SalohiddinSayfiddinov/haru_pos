import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:haru_pos/core/utils/date_extensions.dart';
import 'package:haru_pos/core/utils/extensions.dart';
import 'package:haru_pos/features/orders/domain/entities/orders_entity.dart';
import 'package:haru_pos/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:haru_pos/features/orders/presentation/widgets/orders_filters.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(const LoadOrdersHistoryEvent());
  }

  void _refreshOrders() {
    context.read<OrderBloc>().add(
      LoadOrdersHistoryEvent(
        startDt: _startDate,
        endDt: _endDate,
        type: _selectedType,
      ),
    );
  }

  // void _loadMoreOrders() {
  //   final currentOrders = context.read<OrderBloc>().state.orders.length;
  //   context.read<OrderBloc>().add(
  //     LoadOrdersEvent(
  //       startDt: _startDate,
  //       endDt: _endDate,
  //       type: _selectedType,
  //       offset: currentOrders,
  //       loadMore: true,
  //     ),
  //   );
  // }

  Future<void> _selectDateRange() async {
    final results = await showCalendarDatePicker2Dialog(
      dialogBackgroundColor: Colors.white,
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
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
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
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
      value: [
        if (_startDate != null) _startDate!,
        if (_endDate != null) _endDate!,
      ],
      borderRadius: BorderRadius.circular(15),
    );
    if (results != null && results.isNotEmpty) {
      setState(() {
        _startDate = results.isNotEmpty ? results[0] : null;
        _endDate = results.length > 1 ? results[1] : null;
      });
      _refreshOrders();
    }
  }

  void _clearDateRange() {
    setState(() {
      _startDate = null;
      _endDate = null;
    });
    _refreshOrders();
  }

  void _onStatusSelected(String? status) {
    setState(() {
      _selectedType = status;
    });
    _refreshOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Spacer(),
                  OrdersFilters(
                    startDate: _startDate,
                    endDate: _endDate,
                    selectedStatus: _selectedType,
                    onSelectDateRange: _selectDateRange,
                    onClearDateRange: _clearDateRange,
                    onStatusSelected: _onStatusSelected,
                    onRefresh: _refreshOrders,
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
                              (order) => DataRow(cells: _buildOrderRow(order)),
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
