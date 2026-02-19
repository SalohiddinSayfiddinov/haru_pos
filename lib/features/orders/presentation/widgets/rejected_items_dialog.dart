import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:haru_pos/core/utils/extensions.dart';
import 'package:haru_pos/features/orders/domain/entities/orders_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:haru_pos/core/locale/locale_keys.g.dart';

class RejectedItemsDialog extends StatefulWidget {
  final OrderEntity order;

  const RejectedItemsDialog({super.key, required this.order});

  @override
  State<RejectedItemsDialog> createState() => _RejectedItemsDialogState();
}

class _RejectedItemsDialogState extends State<RejectedItemsDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFF9FAFB),
      content: Material(
        color: const Color(0xFFF9FAFB),
        child: SizedBox(
          width: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.orders_rejected_items_title.tr(),
                    style: GoogleFonts.inter(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.clear),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.order.rejectedSessions.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index != 0) const Divider(),
                      ...widget.order.rejectedSessions[index].items.map(
                        (item) => _buildOrderItem(item: item),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        LocaleKeys.orders_rejection_reason.tr(),
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        widget.order.rejectedSessions[index].voidFault
                            .faultToRu(),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        LocaleKeys.orders_rejection_comment.tr(),
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5.0),
                      Text(widget.order.rejectedSessions[index].comment),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItem({required OrderItemEntity item}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.locale.languageCode == 'ru'
                    ? item.product.nameRu
                    : item.product.nameUz,
                style: GoogleFonts.inter(fontSize: 16.0),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                (item.product.price * item.amount).formatCurrency(context),
                style: GoogleFonts.inter(
                  fontSize: 14.0,
                  color: AppColors.hintColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Text(item.amount.toString(), style: GoogleFonts.inter(fontSize: 16.0)),
      ],
    );
  }
}
