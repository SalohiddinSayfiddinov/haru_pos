import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/widgets/app_buttons.dart';
import 'package:haru_pos/features/orders/domain/entities/orders_entity.dart';
import 'package:haru_pos/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:haru_pos/features/orders/presentation/widgets/order_card.dart';

class OrdersGrid extends StatelessWidget {
  final VoidCallback onRefresh;
  final VoidCallback onLoadMore;
  final Function(OrderEntity order) onUpdateOrder;

  const OrdersGrid({
    super.key,
    required this.onRefresh,
    required this.onLoadMore,
    required this.onUpdateOrder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderLoading && state.orders.isEmpty) {
          return const _LoadingState();
        }

        if (state is OrderError && state.orders.isEmpty) {
          return _ErrorState(onRetry: onRefresh);
        }

        final orders = state.orders;
        final isLoadingMore = state is OrderLoading && state.isLoadMore;
        final hasReachedMax = state.hasReachedMax;

        if (orders.isEmpty) {
          return _EmptyState(onRefresh: onRefresh);
        }

        return Column(
          children: [
            Wrap(
              spacing: 25.0,
              runSpacing: 25.0,
              children: orders
                  .map(
                    (order) => OrderCard(
                      order: order,
                      onCloseOrder: onRefresh,
                      onUpdateOrder: () {
                        onUpdateOrder(order);
                      },
                    ),
                  )
                  .toList(),
            ),
            if (isLoadingMore)
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            // if (!hasReachedMax && !isLoadingMore)
            //   Padding(
            //     padding: const EdgeInsets.symmetric(vertical: 20.0),
            //     child: PrimaryButton(
            //       title: 'Загрузить еще',
            //       onPressed: onLoadMore,
            //     ),
            //   ),
          ],
        );
      },
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(50.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Text(
              'Ошибка загрузки заказов',
              style: GoogleFonts.inter(fontSize: 16.0, color: Colors.red),
            ),
            const SizedBox(height: 15.0),
            PrimaryButton(title: 'Попробовать снова', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onRefresh;

  const _EmptyState({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64.0,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Заказы не найдены',
              style: GoogleFonts.inter(
                fontSize: 16.0,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Попробуйте изменить фильтры',
              style: GoogleFonts.inter(
                fontSize: 14.0,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 20.0),
            PrimaryButton(title: 'Обновить', onPressed: onRefresh),
          ],
        ),
      ),
    );
  }
}
