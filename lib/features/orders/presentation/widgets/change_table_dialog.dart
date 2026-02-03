import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/di/injection.dart';
import 'package:haru_pos/core/widgets/app_buttons.dart';
import 'package:haru_pos/core/widgets/app_snack_bar.dart';
import 'package:haru_pos/core/widgets/app_text_field.dart';
import 'package:haru_pos/features/orders/domain/entities/orders_entity.dart';
import 'package:haru_pos/features/orders/presentation/bloc/orders_bloc.dart';

class ChangeTableDialog extends StatefulWidget {
  final OrderEntity order;

  const ChangeTableDialog({super.key, required this.order});

  @override
  State<ChangeTableDialog> createState() => _ChangeTableDialogState();
}

class _ChangeTableDialogState extends State<ChangeTableDialog> {
  late TextEditingController tableNumberController;

  @override
  void initState() {
    super.initState();
    tableNumberController = TextEditingController(
      text: widget.order.table?.tableNumber.toString(),
    );
  }

  @override
  void dispose() {
    tableNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OrderBloc>(),
      child: AlertDialog(
        backgroundColor: const Color(0xFFF9FAFB),
        content: Material(
          color: const Color(0xFFF9FAFB),
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Пересадить',
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
                AppTextField(
                  controller: tableNumberController,
                  hintText: 'Номер стола',
                  contentPadding: const EdgeInsets.all(16.0),
                  hintStyle: GoogleFonts.inter(
                    fontSize: 13.0,
                    color: const Color(0xFF7A7A7A),
                  ),
                  textStyle: GoogleFonts.inter(fontSize: 13.0),
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
        actions: [
          BlocConsumer<OrderBloc, OrderState>(
            listener: (context, state) {
              if (state is OrderOperationSuccess) {
                Navigator.pop(context, true);
              } else if (state is OrderError) {
                AppSnackbar.error(context, state.message);
              }
            },
            builder: (context, state) {
              return PrimaryButton(
                height: 30.0,
                title: state is OrderLoading ? 'Сохранение...' : 'Сохранить',
                textStyle: GoogleFonts.inter(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                onPressed: state is OrderLoading
                    ? null
                    : () {
                        final tableNumber = int.tryParse(
                          tableNumberController.text.trim(),
                        );
                        if (tableNumber == null) {
                          AppSnackbar.error(
                            context,
                            'Номер стола должен быть числом',
                          );
                          return;
                        }
                        // print(widget.order.user?.id);
                        context.read<OrderBloc>().add(
                          UpdateOrderEvent(
                            id: widget.order.id,
                            tableNumber: tableNumber,
                            type: widget.order.type,
                            userId: 1,
                          ),
                        );
                      },
              );
            },
          ),
        ],
      ),
    );
  }
}
