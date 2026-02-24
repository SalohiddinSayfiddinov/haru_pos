import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:haru_pos/core/locale/locale_keys.g.dart';
import 'package:haru_pos/core/utils/extensions.dart';
import 'package:haru_pos/core/widgets/app_snack_bar.dart';
import 'package:haru_pos/core/widgets/app_text_field.dart';
import 'package:haru_pos/features/orders/presentation/bloc/orders_bloc.dart';

class OrderDrawer extends StatefulWidget {
  final int? tableNumber;
  const OrderDrawer({super.key, this.tableNumber});

  @override
  State<OrderDrawer> createState() => _OrderDrawerState();
}

class _OrderDrawerState extends State<OrderDrawer> {
  late final TextEditingController _tableController;
  int _selectedOrderType = 0;
  final Map<int, TextEditingController> _productCommentControllers = {};

  @override
  void initState() {
    super.initState();
    if (widget.tableNumber != null) {
      _tableController = TextEditingController(
        text: widget.tableNumber!.toString(),
      );
      _selectedOrderType = 1;
    }
  }

  @override
  void dispose() {
    _tableController.dispose();
    for (var controller in _productCommentControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _getCommentController(int productId) {
    if (!_productCommentControllers.containsKey(productId)) {
      _productCommentControllers[productId] = TextEditingController();
    }
    return _productCommentControllers[productId]!;
  }

  void _onCheckout() {
    int? tableNumber = int.tryParse(_tableController.text.replaceAll(' ', ''));

    if (getOrderType == 'dine_in' && tableNumber == null) {
      AppSnackbar.error(context, LocaleKeys.orders_select_table_error.tr());
      return;
    }

    final orderItems = context.read<OrderBloc>().state.cartItems.map((item) {
      final commentController = _getCommentController(item.productId);
      final comment = commentController.text.trim();
      return {
        'product_id': item.productId,
        'amount': item.quantity,
        if (comment.isNotEmpty) 'comment': comment,
      };
    }).toList();

    context.read<OrderBloc>().add(
      CreateOrderEvent(
        type: getOrderType,
        tableNumber: getOrderType == 'dine_in' ? tableNumber : null,
        orderItems: orderItems,
      ),
    );
  }

  String get getOrderType => _selectedOrderType == 0 ? 'takeaway' : 'dine_in';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        return Container(
          width: 360.0,
          height: MediaQuery.sizeOf(context).height - 73.0,
          margin: EdgeInsets.only(top: 3.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(10.0),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .1),
                blurRadius: 10,
                offset: const Offset(-2, 0),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0).copyWith(right: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order List Section
                  _buildOrderListSection(state.cartItems),
                  const SizedBox(height: 25),

                  // Order Type Section
                  _buildOrderTypeSection(),
                  const SizedBox(height: 20),

                  // Payment Methods Section
                  // _buildPaymentMethodsSection(),
                  // const SizedBox(height: 20),

                  // Total Section
                  _buildTotalSection(),
                  const SizedBox(height: 20),

                  // Action Buttons
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderListSection(List<CartItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.orders_list.tr(),
          style: GoogleFonts.inter(fontSize: 23.0, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 35.0),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Column(
              spacing: 10,
              children: [
                Row(
                  children: [
                    Container(
                      height: 50.0,
                      width: 50.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFD8D8D8)),
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: NetworkImage(item.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Text(
                      item.productName,
                      style: GoogleFonts.inter(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        context.read<OrderBloc>().add(
                          RemoveFromCartEvent(item.productId),
                        );
                      },
                      style: IconButton.styleFrom(
                        foregroundColor: AppColors.primary,
                      ),
                      icon: Icon(Icons.remove, size: 15.0),
                    ),
                    Text(
                      item.quantity.toString(),
                      style: GoogleFonts.inter(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<OrderBloc>().add(
                          AddToCartEvent(
                            image: item.image,
                            price: item.price,
                            productId: item.productId,
                            productName: item.productName,
                          ),
                        );
                      },
                      style: IconButton.styleFrom(
                        foregroundColor: AppColors.primary,
                      ),
                      icon: Icon(Icons.add, size: 15.0),
                    ),
                  ],
                ),
                AppTextField(
                  controller: _getCommentController(item.productId),
                  hintText: LocaleKeys.orders_comment_hint.tr(),
                  contentPadding: const EdgeInsets.all(16.0),
                  hintStyle: GoogleFonts.inter(
                    fontSize: 13.0,
                    color: const Color(0xFF7A7A7A),
                  ),
                  textStyle: GoogleFonts.inter(fontSize: 13.0),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Divider(color: Color(0xFF979797), thickness: .4, height: 0),
      ],
    );
  }

  Widget _buildOrderTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.orders_order_type.tr(),
          style: GoogleFonts.inter(fontSize: 20.0, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 25.0),
        Row(
          children: [
            Expanded(
              child: _buildOrderTypeButton(
                LocaleKeys.orders_takeaway.tr(),
                () {
                  if (_selectedOrderType != 0) {
                    setState(() {
                      _selectedOrderType = 0;
                    });
                  }
                },
                isSelected: _selectedOrderType == 0,
              ),
            ),
            const SizedBox(width: 40),
            Expanded(
              child: _buildOrderTypeButton(LocaleKeys.orders_dine_in.tr(), () {
                if (_selectedOrderType != 1) {
                  setState(() {
                    _selectedOrderType = 1;
                  });
                }
              }, isSelected: _selectedOrderType == 1),
            ),
          ],
        ),
        if (_selectedOrderType == 1) ...[
          SizedBox(height: 20),
          AppTextField(
            controller: _tableController,
            isNumber: true,
            hintText: LocaleKeys.orders_enter_table_number.tr(),
            hintStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFFA5AAB5),
            ),
            textStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 11.0,
              horizontal: 15.0,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOrderTypeButton(
    String text,
    VoidCallback onPressed, {
    bool isSelected = false,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          border: Border.all(color: AppColors.primary, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 17.0,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTotalSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          LocaleKeys.orders_total.tr(),
          style: GoogleFonts.inter(fontSize: 18.0, fontWeight: FontWeight.w600),
        ),
        Text(
          context.read<OrderBloc>().state.cartTotalPrice.formatCurrency(
            context,
          ),
          style: GoogleFonts.inter(fontSize: 18.0, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildOrderTypeButton(LocaleKeys.orders_cancel_order.tr(), () {
            context.read<OrderBloc>().add(ClearCartEvent());
          }, isSelected: false),
        ),
        const SizedBox(width: 40),
        BlocConsumer<OrderBloc, OrderState>(
          listener: (context, state) {
            if (state is OrderError) {
              AppSnackbar.error(context, state.message);
            } else if (state is OrderOperationSuccess) {
              AppSnackbar.success(context, state.message);
            }
          },
          builder: (context, state) {
            return Expanded(
              child: state is OrderLoading
                  ? CircularProgressIndicator.adaptive()
                  : _buildOrderTypeButton(
                      LocaleKeys.orders_confirm_order.tr(),
                      _onCheckout,
                      isSelected: true,
                    ),
            );
          },
        ),
      ],
    );
  }
}
