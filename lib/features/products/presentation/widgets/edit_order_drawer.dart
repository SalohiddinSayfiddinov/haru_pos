import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/assets/app_images.dart';
import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:haru_pos/core/utils/extensions.dart';
import 'package:haru_pos/core/widgets/app_snack_bar.dart';
import 'package:haru_pos/core/widgets/app_text_field.dart';
import 'package:haru_pos/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:haru_pos/features/products/presentation/widgets/password_confirm_dialog.dart';

class EditOrderDrawer extends StatefulWidget {
  const EditOrderDrawer({super.key});

  @override
  State<EditOrderDrawer> createState() => _EditOrderDrawerState();
}

class _EditOrderDrawerState extends State<EditOrderDrawer> {
  final TextEditingController _tableController = TextEditingController();
  int _selectedOrderType = 0;

  @override
  void initState() {
    super.initState();
    final state = context.read<OrderBloc>().state;
    if (state.updatingOrder != null) {
      _selectedOrderType = state.updatingOrder!.order.type == 'dine_in' ? 1 : 0;
      _tableController.text =
          state.updatingOrder!.order.table?.tableNumber.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _tableController.dispose();
    super.dispose();
  }

  void _onCheckout() async {
    final String? password = await showDialog<String>(
      context: context,
      builder: (ctx) => const PasswordConfirmDialog(),
    );

    if (password == null || !mounted) return;

    final orderItems = context.read<OrderBloc>().state.cartItems.map((item) {
      return {'product_id': item.productId, 'amount': item.quantity};
    }).toList();

    final updatingOrder = context.read<OrderBloc>().state.updatingOrder!;

    context.read<OrderBloc>().add(
      UpdateOrderItemsEvent(
        type: getOrderType,
        userId: updatingOrder.order.user!.id,
        tableNumber: _selectedOrderType == 1
            ? int.tryParse(_tableController.text)
            : null,
        password: password,
        orderId: updatingOrder.order.id,
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
          'Список',
          style: GoogleFonts.inter(fontSize: 23.0, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 35.0),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Row(
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
          'Вид заказа',
          style: GoogleFonts.inter(fontSize: 20.0, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 25.0),
        Row(
          children: [
            Expanded(
              child: _buildOrderTypeButton('Собой', () {
                if (_selectedOrderType != 0) {
                  setState(() {
                    _selectedOrderType = 0;
                  });
                }
              }, isSelected: _selectedOrderType == 0),
            ),
            const SizedBox(width: 40),
            Expanded(
              child: _buildOrderTypeButton('В зале', () {
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
            hintText: 'Введите номер стола',
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

  Widget _buildPaymentMethodsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Способ оплаты',
          style: GoogleFonts.inter(fontSize: 20.0, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _paymentMethods
              .map((method) => _buildPaymentMethodChip(method))
              .toList(),
        ),
      ],
    );
  }

  String _selectedMethod = 'Click';

  Widget _buildPaymentMethodChip(String method) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RadioGroup<String>(
          groupValue: _selectedMethod,
          onChanged: (String? value) {
            setState(() {
              _selectedMethod = value ?? 'Click';
            });
          },
          child: SizedBox(
            height: 50,
            width: 150,
            child: Row(
              children: <Widget>[
                Radio<String>(
                  value: method,
                  fillColor: WidgetStateProperty.resolveWith(
                    (states) => AppColors.primary,
                  ),
                ),
                SizedBox(width: 10.0),
                method == _paymentMethods[3] || method == _paymentMethods[4]
                    ? Text(
                        method,
                        style: GoogleFonts.inter(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : Image(
                        image: AssetImage(AppImages.click),
                        height: 59,
                        width: 100,
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Итого:',
          style: GoogleFonts.inter(fontSize: 18.0, fontWeight: FontWeight.w600),
        ),
        Text(
          context.read<OrderBloc>().state.cartTotalPrice.formatCurrency(),
          style: GoogleFonts.inter(fontSize: 18.0, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildOrderTypeButton('Отменить', () {
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
              context.read<OrderBloc>().add(const LoadOrdersEvent());
            }
          },
          builder: (context, state) {
            return Expanded(
              child: state is OrderLoading
                  ? CircularProgressIndicator.adaptive()
                  : _buildOrderTypeButton(
                      'Подтвердить',
                      _onCheckout,
                      isSelected: true,
                    ),
            );
          },
        ),
      ],
    );
  }

  final List<String> _paymentMethods = [
    'Click',
    'PayMe',
    'Uzum',
    'Наличными',
    'Терминал',
  ];
}
