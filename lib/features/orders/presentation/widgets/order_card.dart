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

  @override
  Widget build(BuildContext context) {
    final hasMoreItems = widget.order.orderItems.length > 2;
    final itemsToShow = _isExpanded
        ? widget.order.orderItems
        : widget.order.orderItems.take(2).toList();

    return InkWell(
      onTap: widget.onUpdateOrder,
      child: Container(
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
            const SizedBox(height: 25.0),
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
      ),
    );
  }

  Row _buildOrderCardHeader({required OrderEntity order}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
            if (order.user != null)
              Text(
                order.user!.fullName.isEmpty
                    ? order.user!.username
                    : order.user!.fullName,
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
        if (order.user != null) _buildUserAvatar(user: order.user!),
      ],
    );
  }

  Widget _buildUserAvatar({required UserEntity user}) {
    return CircleAvatar(
      radius: 25.0,
      backgroundColor: Colors.transparent,
      backgroundImage: user.image != null ? NetworkImage(user.image!) : null,
      child: user.image == null
          ? Text(
              user.username[0].toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildOrderInfo(order: order),
        _buildStatus(order: order),
      ],
    );
  }

  Widget _buildOrderInfo({required OrderEntity order}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (order.table != null)
          Text(
            'Стол - ${order.table!.tableNumber}',
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
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Статус:',
          style: GoogleFonts.inter(color: const Color(0xFF797B7E)),
        ),
        const SizedBox(height: 5.0),
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
