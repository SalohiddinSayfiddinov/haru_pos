import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/utils/extensions.dart';
import 'package:haru_pos/core/widgets/app_buttons.dart';
import 'package:haru_pos/core/widgets/app_snack_bar.dart';
import 'package:haru_pos/features/orders/domain/entities/orders_entity.dart';
import 'package:haru_pos/features/orders/presentation/bloc/orders_bloc.dart';

class CloseOrderDialog extends StatelessWidget {
  final OrderEntity order;

  const CloseOrderDialog({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        'Закрыть заказ?',
        style: GoogleFonts.inter(fontSize: 18.0, fontWeight: FontWeight.w600),
      ),
      content: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          Text(
            'Вы уверены, что хотите закрыть заказ №${order.id}?',
            style: GoogleFonts.inter(
              fontSize: 14.0,
              color: const Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Сумма: ${order.fullPrice.formatCurrency()}',
            style: GoogleFonts.inter(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              BlocConsumer<OrderBloc, OrderState>(
                listener: (context, state) {
                  if (state is OrderOperationSuccess) {
                    Navigator.pop(context, true);
                  } else if (state is OrderError) {
                    AppSnackbar.error(context, state.message);
                    Navigator.pop(context);
                  }
                },
                builder: (context, state) {
                  return PrimaryButton(
                    height: 40,
                    backgroundColor: Colors.green,
                    textStyle: GoogleFonts.inter(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      context.read<OrderBloc>().add(CloseOrderEvent(order));
                    },
                    title: state is OrderLoading
                        ? 'Потдверждение...'
                        : 'Потдвердить',
                    isLoading: state is OrderLoading,
                  );
                },
              ),
              PrimaryButton(
                height: 40,
                textStyle: GoogleFonts.inter(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                title: 'Отменить',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
