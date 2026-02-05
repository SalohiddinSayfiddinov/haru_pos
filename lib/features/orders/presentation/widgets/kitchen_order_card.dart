import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:haru_pos/core/di/injection.dart';
import 'package:haru_pos/core/utils/date_extensions.dart';
import 'package:haru_pos/core/utils/extensions.dart';
import 'package:haru_pos/features/auth/domain/entities/auth_entity.dart';
import 'package:haru_pos/features/orders/domain/entities/orders_entity.dart';
import 'package:haru_pos/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:haru_pos/features/orders/presentation/widgets/close_order_dialog.dart';
import 'package:haru_pos/features/orders/presentation/widgets/rejected_items_dialog.dart';

class KitchenOrderCard extends StatefulWidget {
  final OrderEntity order;
  final VoidCallback onCloseOrder;
  final VoidCallback onUpdateOrder;

  const KitchenOrderCard({
    super.key,
    required this.order,
    required this.onCloseOrder,
    required this.onUpdateOrder,
  });

  @override
  State<KitchenOrderCard> createState() => _KitchenOrderCardState();
}

class _KitchenOrderCardState extends State<KitchenOrderCard> {
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

  // void _showChangeTableDialog(BuildContext context, OrderEntity order) async {
  //   final result = await showDialog(
  //     context: context,
  //     builder: (context) => BlocProvider(
  //       create: (context) => getIt<OrderBloc>(),
  //       child: ChangeTableDialog(order: order),
  //     ),
  //   );

  //   if (result == true) {
  //     widget.onCloseOrder();
  //   }
  // }

  // void _showRemoveItemDialog(BuildContext context, OrderEntity order) async {
  //   final result = await showDialog(
  //     context: context,
  //     builder: (context) => BlocProvider(
  //       create: (context) => getIt<OrderBloc>(),
  //       child: RemoveOrderItemDialog(order: order),
  //     ),
  //   );

  //   if (result == true) {
  //     widget.onCloseOrder();
  //   }
  // }

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildKitchenOrderCardHeader(order: widget.order),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 15.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
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
                _buildOrderItemsList(
                  items: itemsToShow,
                  isExpanded: _isExpanded,
                ),
                if (hasMoreItems) ...[
                  const SizedBox(height: 10.0),
                  _buildShowMoreButton(
                    isExpanded: _isExpanded,
                    remainingCount: widget.order.orderItems.length - 2,
                    onPressed: _toggleExpanded,
                  ),
                ],
                const Divider(height: 30.0),
                if (widget.order.table != null)
                  Text(
                    'Стол - ${widget.order.table!.tableNumber}',
                    style: GoogleFonts.inter(color: const Color(0xFF797B7E)),
                  ),
                SizedBox(height: 10.0),
                _buildStatus(order: widget.order),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _buildKitchenOrderCardHeader({required OrderEntity order}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 21.0, horizontal: 25.0),
      decoration: BoxDecoration(
        color: order.type == 'dine_in'
            ? Color(0xFF0069F4).withValues(alpha: .8)
            : Color(0xFF1BB90C).withValues(alpha: .80),
        borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
      ),
      child: Row(
        spacing: 15.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Заказ #${order.id}',
                style: GoogleFonts.inter(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Text(
                "${order.createdAt.formatted} ${order.createdAt.formattedTime}",
                style: GoogleFonts.inter(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
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
                'Ед: ${item.amount}',
                style: GoogleFonts.inter(fontSize: 15.0),
              ),
              Text(
                item.product.comment ?? '',
                style: GoogleFonts.inter(color: AppColors.primary),
              ),
            ],
          ),
        ),
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

  Widget _buildStatus({required OrderEntity order}) {
    return Row(
      children: [
        Text(
          'Статус:',
          style: GoogleFonts.inter(color: const Color(0xFF797B7E)),
        ),
        const SizedBox(width: 15.0),
        InkWell(
          onTap: () {
            _showCloseOrderDialog(context, order);
          },
          child: Container(
            height: 30.0,
            decoration: BoxDecoration(
              color: order.active ? AppColors.primary : Colors.green,
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 7.0,
              horizontal: 20.0,
            ),
            child: Center(
              child: Text(
                order.active ? 'Не оплачен' : 'Оплачен',
                style: GoogleFonts.montserrat(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
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
    // Logic to determine the display name for the tooltip
    final String displayName = (widget.user.fullName.isEmpty)
        ? widget.user.username
        : widget.user.fullName;

    return Tooltip(
      message: displayName,
      waitDuration: const Duration(milliseconds: 500),
      child: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.grey[200],
        backgroundImage: widget.user.image != null
            ? NetworkImage(widget.user.image!)
            : null,
        child: widget.user.image == null
            ? Text(
                widget.user.username[0].toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              )
            : null,
      ),
    );
  }
}
