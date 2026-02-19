import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:haru_pos/core/locale/locale_keys.g.dart';
import 'package:haru_pos/core/utils/date_extensions.dart';
import 'package:haru_pos/core/utils/extensions.dart';
import 'package:haru_pos/features/orders/domain/entities/orders_entity.dart';
import 'package:haru_pos/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:haru_pos/features/orders/presentation/widgets/orders_filters.dart';
import 'package:number_pagination/number_pagination.dart';

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
        startDt: _startDate?.formattedYearFirst,
        endDt: _endDate?.formattedYearFirst,
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
            weekday.localizedShortWeekday,
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
            LocaleKeys.orders_apply.tr(),
            style: GoogleFonts.inter(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        cancelButton: Text(
          LocaleKeys.orders_cancel.tr(),
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
                    LocaleKeys.order_history_title.tr(),
                    style: GoogleFonts.inter(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  OrdersFilters(
                    isHistory: true,
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
                  } else if (state is OrdersHistoryLoaded) {
                    final orders = state.orders;

                    if (orders.isEmpty) {
                      return Center(
                        child: Text(LocaleKeys.order_history_empty.tr()),
                      );
                    }

                    return Column(
                      children: [
                        Card(
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
                                dataRowColor: WidgetStateProperty.all(
                                  Colors.white,
                                ),
                                columns: [
                                  _buildHeaderText('#'),
                                  _buildHeaderText(
                                    LocaleKeys.order_history_headers_name.tr(),
                                  ),
                                  _buildHeaderText(
                                    LocaleKeys.order_history_headers_price.tr(),
                                  ),
                                  _buildHeaderText(
                                    LocaleKeys.order_history_headers_waiter
                                        .tr(),
                                  ),
                                  _buildHeaderText(
                                    LocaleKeys.order_history_headers_type.tr(),
                                  ),
                                  _buildHeaderText(
                                    LocaleKeys.order_history_headers_date.tr(),
                                  ),
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
                        ),
                        const SizedBox(height: 20.0),
                        NumberPagination(
                          onPageChanged: (v) {
                            context.read<OrderBloc>().add(
                              LoadOrdersHistoryEvent(
                                limit: 20,
                                offset: (v - 1) * 20,
                                startDt: _startDate?.formattedYearFirst,
                                endDt: _endDate?.formattedYearFirst,
                                type: _selectedType,
                              ),
                            );
                          },
                          totalPages: state.totalPages,
                          currentPage: state.currentPage,
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
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
        .map(
          (e) => context.locale.languageCode == 'ru'
              ? e.product.nameRu
              : e.product.nameUz,
        )
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
      DataCell(_buildRowText(order.fullPrice.formatCurrency(context))),
      DataCell(
        _buildRowText(
          order.user!.fullName.isNotEmpty
              ? order.user!.fullName
              : order.user!.username,
        ),
      ),
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
        return LocaleKeys.common_order_types_dine_in.tr();
      case 'takeaway':
        return LocaleKeys.common_order_types_takeaway.tr();
      case 'delivery':
        return LocaleKeys.common_order_types_delivery.tr();
      default:
        return type;
    }
  }
}
