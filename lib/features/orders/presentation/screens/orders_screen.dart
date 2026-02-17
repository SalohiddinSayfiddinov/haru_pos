import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:haru_pos/core/routes/app_pages.dart';
import 'package:haru_pos/core/utils/date_extensions.dart';
import 'package:haru_pos/core/widgets/app_buttons.dart';
import 'package:haru_pos/features/orders/domain/entities/orders_entity.dart';
import 'package:haru_pos/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:haru_pos/features/orders/presentation/widgets/orders_filters.dart';
import 'package:haru_pos/features/orders/presentation/widgets/orders_grid.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:haru_pos/core/locale/locale_keys.g.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedType;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(const LoadOrdersEvent());
    _scrollController.addListener(_onScroll);
  }

  Locale? _lastLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currentLocale = context.locale;

    if (_lastLocale != currentLocale) {
      _lastLocale = currentLocale;
    }
  }

  void _checkIfNeedMoreData() {
    if (_scrollController.hasClients &&
        _scrollController.position.maxScrollExtent <= 0) {
      _loadMoreOrders();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) _loadMoreOrders();
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 200);
  }

  void _refreshOrders() {
    context.read<OrderBloc>().add(
      LoadOrdersEvent(
        startDt: _startDate?.formattedYearFirst,
        endDt: _endDate?.formattedYearFirst,
        type: _selectedType,
      ),
    );
  }

  bool _isFetching = false;

  void _loadMoreOrders() {
    final state = context.read<OrderBloc>().state;
    if (state.isLoadMore || state.hasReachedMax || _isFetching) return;
    _isFetching = true;
    final currentOrders = state.orders.length;
    context.read<OrderBloc>().add(
      LoadOrdersEvent(
        startDt: _startDate?.formattedYearFirst,
        endDt: _endDate?.formattedYearFirst,
        type: _selectedType,
        offset: currentOrders,
        loadMore: true,
      ),
    );
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
    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderError && state.orders.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
        if (state is OrdersLoaded) {
          _isFetching = false;
          if (!state.hasReachedMax) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _checkIfNeedMoreData();
            });
          }
        }
      },
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _OrdersHeader(
                  _startDate,
                  _endDate,
                  _selectedType,
                  _selectDateRange,
                  _clearDateRange,
                  _onStatusSelected,
                  _refreshOrders,
                ),
                const SizedBox(height: 30.0),

                const SizedBox(height: 30.0),
                OrdersGrid(
                  onRefresh: _refreshOrders,
                  onLoadMore: _loadMoreOrders,
                  onUpdateOrder: (order) {
                    _openDrawer(order);
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: FloatingActionButton(
              onPressed: () => context.go(AppPages.products),
              backgroundColor: AppColors.primary,
              shape: CircleBorder(),
              child: Icon(Icons.add, color: Colors.white),
            ),
          ),
          BlocConsumer<OrderBloc, OrderState>(
            listener: (context, state) {
              if (state is OrderError) {
                CustomSnackBar.error(message: state.message);
              } else if (state is OrderOperationSuccess) {
                CustomSnackBar.success(message: state.message);
              }
            },
            builder: (context, state) {
              return SizedBox();
            },
          ),
        ],
      ),
    );
  }

  void _openDrawer(OrderEntity order) {
    context.read<OrderBloc>().add(SetOrderForEditing(order: order));
    context.go(AppPages.products);
  }

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
}

class _OrdersHeader extends StatelessWidget {
  final DateTime? _startDate;
  final DateTime? _endDate;
  final String? _selectedType;
  final Function() _selectDateRange;
  final Function() _clearDateRange;
  final Function(String?) _onStatusSelected;
  final Function() _refreshOrders;

  const _OrdersHeader(
    this._startDate,
    this._endDate,
    this._selectedType,
    this._selectDateRange,
    this._clearDateRange,
    this._onStatusSelected,
    this._refreshOrders,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          LocaleKeys.orders_title.tr(),
          style: GoogleFonts.inter(fontSize: 25.0, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        OrdersFilters(
          isHistory: false,
          startDate: _startDate,
          endDate: _endDate,
          selectedStatus: _selectedType,
          onSelectDateRange: _selectDateRange,
          onClearDateRange: _clearDateRange,
          onStatusSelected: _onStatusSelected,
          onRefresh: _refreshOrders,
        ),
        PrimaryButton(
          width: 185.0,
          height: 30.0,
          textStyle: GoogleFonts.montserrat(
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          title: LocaleKeys.orders_history.tr(),
          onPressed: () => context.push(AppPages.orderHistory),
        ),
      ],
    );
  }
}
