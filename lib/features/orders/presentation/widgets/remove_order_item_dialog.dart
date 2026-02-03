import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:haru_pos/core/di/injection.dart';
import 'package:haru_pos/core/utils/extensions.dart';
import 'package:haru_pos/core/utils/validators.dart';
import 'package:haru_pos/core/widgets/app_buttons.dart';
import 'package:haru_pos/core/widgets/app_snack_bar.dart';
import 'package:haru_pos/core/widgets/app_text_field.dart';
import 'package:haru_pos/features/orders/data/models/orders_dto.dart';
import 'package:haru_pos/features/orders/domain/entities/orders_entity.dart';
import 'package:haru_pos/features/orders/presentation/bloc/orders_bloc.dart';

class RemoveOrderItemDialog extends StatefulWidget {
  final OrderEntity order;

  const RemoveOrderItemDialog({super.key, required this.order});

  @override
  State<RemoveOrderItemDialog> createState() => _RemoveOrderItemDialogState();
}

class _RemoveOrderItemDialogState extends State<RemoveOrderItemDialog> {
  final List<TextEditingController> controllers = [];
  final TextEditingController commentController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String fault = 'staff';
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.order.orderItems.length; i++) {
      controllers.add(TextEditingController(text: '0'));
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    _passwordController.dispose();
    for (var controller in controllers) {
      controller.dispose();
    }
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
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Отказ блюд',
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
                  Text(
                    'Блюда',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5.0),
                  for (var i = 0; i < widget.order.orderItems.length; i++) ...[
                    _buildOrderItem(
                      item: widget.order.orderItems[i],
                      controller: controllers[i],
                    ),
                    const Divider(),
                  ],
                  const SizedBox(height: 10.0),
                  Text(
                    'Причина отказа',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    padding: const EdgeInsets.only(left: 2, right: 12.0),
                    child: DropdownButton2(
                      items: [
                        DropdownMenuItem(
                          value: 'staff',
                          child: Text('staff'.faultToRu()),
                        ),
                        DropdownMenuItem(
                          value: 'kitchen',
                          child: Text('kitchen'.faultToRu()),
                        ),
                        DropdownMenuItem(
                          value: 'customer',
                          child: Text('customer'.faultToRu()),
                        ),
                      ],
                      value: fault,
                      style: GoogleFonts.inter(
                        fontSize: 13.0,
                        color: const Color(0xFF7A7A7A),
                      ),
                      iconStyleData: IconStyleData(
                        icon: Icon(Icons.keyboard_arrow_down, size: 12.0),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                      ),
                      underline: SizedBox(),
                      onChanged: (v) {
                        setState(() {
                          fault = v!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  AppTextField(
                    controller: commentController,
                    hintText: 'Комментарий',
                    maxLines: 3,
                    contentPadding: const EdgeInsets.all(16.0),
                    hintStyle: GoogleFonts.inter(
                      fontSize: 13.0,
                      color: const Color(0xFF7A7A7A),
                    ),
                    textStyle: GoogleFonts.inter(fontSize: 13.0),
                    validator: Validators.simpleValidator,
                  ),
                  const SizedBox(height: 10.0),
                  AppTextField(
                    controller: _passwordController,
                    hintText: 'Пароль',
                    obscureText: true,
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16,

                      color: Color(0xFFA5AAB5),
                    ),
                    textStyle: GoogleFonts.inter(fontSize: 16),
                  ),
                ],
              ),
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
                        if (!formKey.currentState!.validate()) return;
                        final items = widget.order.orderItems
                            .asMap()
                            .entries
                            .map((entry) {
                              final index = entry.key;
                              final amount =
                                  int.tryParse(controllers[index].text) ?? 0;

                              if (amount < 1) return null;

                              return RejectOrderItem(
                                amount: amount,
                                productId: entry.value.product.id,
                              );
                            })
                            .whereType<RejectOrderItem>()
                            .toList();

                        context.read<OrderBloc>().add(
                          RejectOrderEvent(
                            id: widget.order.id,
                            request: RejectOrderRequest(
                              password: _passwordController.text.trim(),
                              comment: commentController.text.trim(),
                              voidFault: fault,
                              items: items,
                            ),
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

  Widget _buildOrderItem({
    required OrderItemEntity item,
    required TextEditingController controller,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            item.product.nameRu,
            style: GoogleFonts.inter(fontSize: 16.0),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          width: 100,
          child: AppTextField(
            controller: controller,
            isNumber: true,
            validator: (value) {
              if (!RegExp(r'^\d+$').hasMatch(value!)) {
                return 'Только числа';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
