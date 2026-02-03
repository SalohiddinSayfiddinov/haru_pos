import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:haru_pos/features/orders/presentation/widgets/kitchen_order_card.dart';

class KitchenOrdersScreen extends StatefulWidget {
  const KitchenOrdersScreen({super.key});

  @override
  State<KitchenOrdersScreen> createState() => KitchenOrdersScreenState();
}

class KitchenOrdersScreenState extends State<KitchenOrdersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(WatchOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrdersLoaded) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Заказы',
                          style: GoogleFonts.inter(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 30),
                        Wrap(
                          spacing: 25.0,
                          runSpacing: 25.0,
                          children: state.orders
                              .map(
                                (order) => KitchenOrderCard(
                                  order: order,
                                  onCloseOrder: () {},
                                  onUpdateOrder: () {},
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 240,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 35.0,
                    horizontal: 25.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Все заказы ${state.orders.length}',
                        style: GoogleFonts.inter(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      ...state.orders.map(
                        (order) => Text(
                          "Заказ №${order.id}",
                          style: GoogleFonts.inter(color: Color(0xFF797B7E)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
            // ListView.builder(
            //   itemCount: state.orders.length,
            //   itemBuilder: (context, index) {
            //     final order = state.orders[index];
            //     return ListTile(
            //       title: Text(order.id.toString()),
            //       subtitle: Text(order.table?.id.toString() ?? 'No table'),
            //     );
            //   },
            // );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
