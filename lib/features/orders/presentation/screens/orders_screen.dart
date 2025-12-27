import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:haru_pos/core/routes/app_pages.dart';
import 'package:haru_pos/core/widgets/app_buttons.dart';
import 'package:haru_pos/features/orders/domain/entities/orders_entity.dart';
import 'package:haru_pos/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:haru_pos/features/orders/presentation/widgets/orders_grid.dart';
import 'package:haru_pos/features/products/presentation/widgets/order_drawer.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(const LoadOrdersEvent());
  }

  void _refreshOrders() {
    context.read<OrderBloc>().add(
      LoadOrdersEvent(
        startDt: _startDate,
        endDt: _endDate,
        status: _selectedStatus,
      ),
    );
  }

  void _loadMoreOrders() {
    final currentOrders = context.read<OrderBloc>().state.orders.length;
    context.read<OrderBloc>().add(
      LoadOrdersEvent(
        startDt: _startDate,
        endDt: _endDate,
        status: _selectedStatus,
        offset: currentOrders,
        loadMore: true,
      ),
    );
  }

  void _openDrawer(OrderEntity order) {
    context.read<OrderBloc>().add(SetOrderForEditing(order: order));
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
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
      _selectedStatus = status;
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
      },
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _OrdersHeader(),
                  const SizedBox(height: 30.0),
                  _OrdersFilters(
                    startDate: _startDate,
                    endDate: _endDate,
                    selectedStatus: _selectedStatus,
                    onSelectDateRange: _selectDateRange,
                    onClearDateRange: _clearDateRange,
                    onStatusSelected: _onStatusSelected,
                    onRefresh: _refreshOrders,
                  ),
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
                CustomSnackBar.error(message: state.message);
              }
            },
            builder: (context, state) {
              if (state.cartItems.isNotEmpty) {
                return const Positioned(right: 0, child: OrderDrawer());
              }
              return SizedBox();
            },
          ),
        ],
      ),
    );
  }
}

class _OrdersHeader extends StatelessWidget {
  const _OrdersHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Заказы',
          style: GoogleFonts.inter(fontSize: 25.0, fontWeight: FontWeight.w600),
        ),
        PrimaryButton(
          width: 185.0,
          height: 30.0,
          textStyle: GoogleFonts.montserrat(
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          title: 'История заказов',
          onPressed: () => context.push(AppPages.orderHistory),
        ),
      ],
    );
  }
}

class _OrdersFilters extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? selectedStatus;
  final VoidCallback onSelectDateRange;
  final VoidCallback onClearDateRange;
  final ValueChanged<String?> onStatusSelected;
  final VoidCallback onRefresh;

  const _OrdersFilters({
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
    return Wrap(
      spacing: 15.0,
      runSpacing: 15.0,
      crossAxisAlignment: WrapCrossAlignment.center,
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
      icon: const Icon(Icons.calendar_today, size: 18.0),
      label: Text(
        startDate != null && endDate != null
            ? '${DateFormat('dd.MM.yyyy').format(startDate!)} - ${DateFormat('dd.MM.yyyy').format(endDate!)}'
            : 'Выбрать период',
        style: GoogleFonts.inter(fontSize: 13.0),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        side: BorderSide(color: AppColors.primary),
        foregroundColor: AppColors.primary,
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
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedStatus,
          hint: Text('Все статусы', style: GoogleFonts.inter(fontSize: 13.0)),
          items: [
            DropdownMenuItem<String>(
              value: null,
              child: Text(
                'Все статусы',
                style: GoogleFonts.inter(fontSize: 13.0),
              ),
            ),
            DropdownMenuItem<String>(
              value: 'unpaid',
              child: Text(
                'Не оплачен',
                style: GoogleFonts.inter(fontSize: 13.0),
              ),
            ),
            DropdownMenuItem<String>(
              value: 'paid',
              child: Text('Оплачен', style: GoogleFonts.inter(fontSize: 13.0)),
            ),
            DropdownMenuItem<String>(
              value: 'cancelled',
              child: Text('Отменён', style: GoogleFonts.inter(fontSize: 13.0)),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _RefreshButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.refresh, size: 20.0),
      tooltip: 'Обновить',
      style: IconButton.styleFrom(
        backgroundColor: AppColors.primary.withValues(alpha: .1),
        foregroundColor: AppColors.primary,
      ),
    );
  }
}
