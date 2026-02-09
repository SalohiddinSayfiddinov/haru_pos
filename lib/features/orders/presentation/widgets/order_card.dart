import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:haru_pos/core/di/injection.dart';
import 'package:haru_pos/core/utils/date_extensions.dart';
import 'package:haru_pos/core/utils/extensions.dart';
import 'package:haru_pos/core/utils/order_extensions.dart';
import 'package:haru_pos/core/widgets/app_buttons.dart';
import 'package:haru_pos/core/widgets/app_snack_bar.dart';
import 'package:haru_pos/features/auth/domain/entities/auth_entity.dart';
import 'package:haru_pos/features/orders/domain/entities/orders_entity.dart';
import 'package:haru_pos/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:haru_pos/features/orders/presentation/widgets/change_table_dialog.dart';
import 'package:haru_pos/features/orders/presentation/widgets/close_order_dialog.dart';
import 'package:haru_pos/features/orders/presentation/widgets/print_bill_dialog.dart';
import 'package:haru_pos/features/orders/presentation/widgets/rejected_items_dialog.dart';
import 'package:haru_pos/features/orders/presentation/widgets/remove_order_item_dialog.dart';

class OrderCard extends StatefulWidget {
  final OrderEntity order;
  final VoidCallback onCloseOrder;
  final VoidCallback onUpdateOrder;

  const OrderCard({
    super.key,
    required this.order,
    required this.onCloseOrder,
    required this.onUpdateOrder,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _showCloseOrderDialog(BuildContext context, OrderEntity order) async {
    final result = await showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => getIt<OrderBloc>(),
        child: CloseOrderDialog(order: order),
      ),
    );

    if (result == true) {
      widget.onCloseOrder();
    }
  }

  void _showChangeTableDialog(BuildContext context, OrderEntity order) async {
    final result = await showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => getIt<OrderBloc>(),
        child: ChangeTableDialog(order: order),
      ),
    );

    if (result == true) {
      widget.onCloseOrder();
    }
  }

  void _showRemoveItemDialog(BuildContext context, OrderEntity order) async {
    final result = await showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => getIt<OrderBloc>(),
        child: RemoveOrderItemDialog(order: order),
      ),
    );

    if (result == true) {
      widget.onCloseOrder();
    }
  }

  void _showPrintBillDialog(BuildContext context, OrderEntity order) async {
    final result = await showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => getIt<OrderBloc>(),
        child: PrintBillDialog(order: order),
      ),
    );

    if (result == true) {
      AppSnackbar.success(context, 'Чек успешно напечатан');
    }
  }

  void _showRejectedItemsDialog(BuildContext context, OrderEntity order) async {
    showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => getIt<OrderBloc>(),
        child: RejectedItemsDialog(order: order),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasMoreItems = widget.order.orderItems.length > 2;
    final itemsToShow = _isExpanded
        ? widget.order.orderItems
        : widget.order.orderItems.take(2).toList();

    return Container(
      width: 341,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black.withValues(alpha: .46)),
        borderRadius: BorderRadius.circular(9),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 21.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildOrderCardHeader(order: widget.order),
          const Divider(height: 30.0),
          if (widget.order.rejectedSessions.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    _showRejectedItemsDialog(context, widget.order);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    textStyle: GoogleFonts.inter(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: Text('Отказано'),
                ),
              ],
            ),
          _buildOrderItemsList(items: itemsToShow, isExpanded: _isExpanded),
          if (hasMoreItems) ...[
            const SizedBox(height: 10.0),
            _buildShowMoreButton(
              isExpanded: _isExpanded,
              remainingCount: widget.order.orderItems.length - 2,
              onPressed: _toggleExpanded,
            ),
          ],
          const Divider(height: 30.0),
          _buildFooter(order: widget.order),
        ],
      ),
    );
  }

  Row _buildOrderCardHeader({required OrderEntity order}) {
    return Row(
      spacing: 15.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (order.user != null) _UserAvatar(user: order.user!),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Заказ #${order.id}',
              style: GoogleFonts.inter(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              order.createdAt.formatted,
              style: GoogleFonts.inter(color: const Color(0xFF797B7E)),
            ),
          ],
        ),
        const Spacer(),
        PopupMenuButton<String>(
          tooltip: '',
          color: Colors.white,
          iconSize: 20.0,
          iconColor: const Color(0xFF757575),
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'change_table',
              child: Text('Пересадить'),
            ),
            const PopupMenuItem(
              value: 'remove_item',
              child: Text('Отказ блюд'),
            ),
            const PopupMenuItem(
              value: 'add_items',
              child: Text('Добавить блюда'),
            ),
          ],
          onSelected: (value) {
            if (value == 'change_table') {
              _showChangeTableDialog(context, order);
            } else if (value == 'remove_item') {
              _showRemoveItemDialog(context, order);
            } else if (value == 'add_items') {
              widget.onUpdateOrder();
            }
          },
        ),
      ],
    );
  }

  Widget _buildOrderItemsList({
    required List<OrderItemEntity> items,
    required bool isExpanded,
  }) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(indent: 80.0, height: 40.0),
      itemBuilder: (context, index) => _buildOrderItem(item: items[index]),
    );
  }

  Widget _buildOrderItem({required OrderItemEntity item}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: 35.0,
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(item.product.image),
        ),
        const SizedBox(width: 20.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.product.nameRu,
                style: GoogleFonts.inter(fontSize: 16.0),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4.0),
              Text(
                item.product.category.nameRu,
                style: GoogleFonts.inter(color: const Color(0xFF797B7E)),
              ),
              Text(
                item.product.price.formatCurrency(),
                style: GoogleFonts.inter(),
              ),
            ],
          ),
        ),
        Text('Ед: ${item.amount}', style: GoogleFonts.inter(fontSize: 15.0)),
      ],
    );
  }

  Widget _buildShowMoreButton({
    required bool isExpanded,
    required int remainingCount,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isExpanded ? 'Скрыть' : '+ еще $remainingCount товаров',
              style: GoogleFonts.inter(
                color: AppColors.primary,
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 5.0),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: AppColors.primary,
              size: 18.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter({required OrderEntity order}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildOrderInfo(order: order),
            _buildStatus(order: order),
          ],
        ),
        SizedBox(height: 10),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: PrimaryButton(
                width: double.infinity,
                backgroundColor: AppColors.textPrimary,
                height: 35,
                title: 'Печатать чек',
                textStyle: GoogleFonts.montserrat(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                onPressed: () => _showPrintBillDialog(context, order),
              ),
            ),
            Expanded(
              child: PrimaryButton(
                width: double.infinity,
                backgroundColor: widget.order.active
                    ? AppColors.primary
                    : Colors.green,
                height: 35,
                title: widget.order.active ? 'Закрыть заказ' : 'Оплачен',
                textStyle: GoogleFonts.montserrat(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                onPressed: () {
                  _showCloseOrderDialog(context, widget.order);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderInfo({required OrderEntity order}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          order.type == 'dine_in'
              ? 'Стол - ${order.table!.tableNumber}'
              : 'На вынос',
          style: GoogleFonts.inter(color: const Color(0xFF797B7E)),
        ),

        const SizedBox(height: 10.0),
        Text(
          'Итого - ${order.fullPrice.formatCurrency()}',
          style: GoogleFonts.inter(color: const Color(0xFF797B7E)),
        ),
      ],
    );
  }

  Widget _buildStatus({required OrderEntity order}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Статус',
          style: GoogleFonts.inter(color: const Color(0xFF797B7E)),
        ),
        const SizedBox(height: 5.0),
        Text(
          order.status.toLocalizedText('ru'),
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _UserAvatar extends StatefulWidget {
  final UserEntity user;
  const _UserAvatar({required this.user});

  @override
  State<_UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<_UserAvatar> {
  @override
  Widget build(BuildContext context) {
    final String displayName = (widget.user.fullName.isEmpty)
        ? widget.user.username
        : widget.user.fullName;

    return Tooltip(
      message: displayName,
      waitDuration: const Duration(milliseconds: 500),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: widget.user.image ?? '',
          fit: BoxFit.cover,
          width: 45,
          height: 45,
          errorWidget: (context, url, error) => CircleAvatar(
            backgroundColor: AppColors.primary,
            radius: 22,
            child: Text(
              widget.user.username[0].toUpperCase(),
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
