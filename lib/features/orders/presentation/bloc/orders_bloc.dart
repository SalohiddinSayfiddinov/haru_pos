import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haru_pos/core/errors/failures.dart';
import 'package:haru_pos/core/services/kitchen_printer_service.dart';
import 'package:haru_pos/core/services/thermal_priner_service.dart';
import 'package:haru_pos/features/auth/domain/usecases/auth_usecases.dart';
import 'package:haru_pos/features/hall/domain/usecases/table_usecases.dart';
import 'package:haru_pos/features/orders/data/models/orders_dto.dart';
import 'package:haru_pos/features/orders/domain/entities/orders_entity.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/order_usecases.dart';

part 'orders_event.dart';
part 'orders_state.dart';

@injectable
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final GetOrdersUseCase getOrdersUseCase;
  final GetOrderHistoryUseCase getOrdersHistoryUseCase;
  final GetTableByNumberUseCase getTableByNumberUseCase;
  final CreateOrderUseCase createOrderUseCase;
  final UpdateOrderUseCase updateOrderUseCase;
  final DeleteOrderUseCase deleteOrderUseCase;
  final CloseOrderUseCase closeOrderUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final ThermalPrinterService printerService;
  final AddItemsToOrderUseCase addItemsToOrderUseCase;
  final UpdateOrderItemsUseCase updateOrderItemsUseCase;
  final RejectOrderUseCase rejectOrderUseCase;
  final WatchOrdersUseCase watchOrdersUseCase;
  final KitchenPrinterService kitchenPrinterService;

  OrderBloc({
    required this.getOrdersUseCase,
    required this.getCurrentUserUseCase,
    required this.getTableByNumberUseCase,
    required this.createOrderUseCase,
    required this.updateOrderUseCase,
    required this.deleteOrderUseCase,
    required this.closeOrderUseCase,
    required this.printerService,
    required this.addItemsToOrderUseCase,
    required this.updateOrderItemsUseCase,
    required this.rejectOrderUseCase,
    required this.getOrdersHistoryUseCase,
    required this.watchOrdersUseCase,
    required this.kitchenPrinterService,
  }) : super(const OrderInitial()) {
    on<LoadOrdersEvent>(_onLoadOrders);
    on<LoadOrdersHistoryEvent>(_onLoadOrdersHistory);
    on<CreateOrderEvent>(_onCreateOrder);
    on<UpdateOrderEvent>(_onUpdateOrder);
    on<DeleteOrderEvent>(_onDeleteOrder);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<ClearCartEvent>(_onClearCart);
    on<CloseOrderEvent>(_onCloseOrder);
    on<AddItemsToOrderEvent>(_onAddItemsToOrder);
    on<UpdateOrderItemsEvent>(_onUpdateOrderItems);
    on<SetOrderForEditing>(_onSetOrderForEditing);
    on<RejectOrderEvent>(_onRejectOrder);
    on<WatchOrdersEvent>(_onWatchOrders);
    on<PrintBillEvent>(_onPrintBill);
  }
  StreamSubscription? _orderSubscription;

  Future<void> _onLoadOrders(
    LoadOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    if (event.loadMore) {
      emit(
        OrderLoading(
          cartItems: state.cartItems,
          orders: state.orders,
          hasReachedMax: state.hasReachedMax,
          isLoadMore: true,
        ),
      );
    } else {
      emit(
        OrderLoading(
          cartItems: state.cartItems,
          orders: const [],
          hasReachedMax: false,
          isLoadMore: false,
        ),
      );
    }

    final result = await getOrdersUseCase(
      limit: event.limit,
      offset: event.offset,
      startDt: event.startDt,
      endDt: event.endDt,
      type: event.type,
    );

    result.fold(
      (failure) => emit(
        OrderError(
          message: _mapFailureToMessage(failure),
          cartItems: state.cartItems,
          orders: state.orders,
          hasReachedMax: state.hasReachedMax,
        ),
      ),
      (newOrders) {
        final hasReachedMax = newOrders.length < event.limit;

        final allOrders = event.loadMore
            ? [...state.orders, ...newOrders]
            : newOrders;

        emit(
          OrdersLoaded(
            orders: allOrders,
            cartItems: state.cartItems,
            hasReachedMax: hasReachedMax,
          ),
        );
      },
    );
  }

  Future<void> _onLoadOrdersHistory(
    LoadOrdersHistoryEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(
      OrderLoading(
        cartItems: state.cartItems,
        orders: const [],
        hasReachedMax: false,
        isLoadMore: false,
      ),
    );

    final result = await getOrdersHistoryUseCase(
      limit: event.limit,
      offset: event.offset,
      startDt: event.startDt,
      endDt: event.endDt,
      type: event.type,
    );

    result.fold(
      (failure) => emit(
        OrderError(
          message: _mapFailureToMessage(failure),
          cartItems: state.cartItems,
          orders: state.orders,
          hasReachedMax: state.hasReachedMax,
        ),
      ),
      (orders) {
        final hasReachedMax = orders.result.length < event.limit;

        final int totalPages = (orders.total / event.limit).ceil();
        final int currentPage = (event.offset / event.limit).floor() + 1;

        emit(
          OrdersHistoryLoaded(
            orders: orders.result,
            cartItems: state.cartItems,
            hasReachedMax: hasReachedMax,
            totalPages: totalPages,
            currentPage: currentPage,
          ),
        );
      },
    );
  }

  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading(cartItems: state.cartItems, orders: state.orders));

    int? tableId;
    if (event.tableNumber != null) {
      final tableResult = await getTableByNumberUseCase(
        tableNumber: event.tableNumber!,
      );

      tableId = tableResult.fold((failure) => null, (table) => table.id);

      if (tableId == null) {
        emit(
          OrderError(
            message: 'Table not found',
            cartItems: state.cartItems,
            orders: state.orders,
          ),
        );
        return;
      }
    }

    final currentUserResult = await getCurrentUserUseCase();
    int? currentUserId = currentUserResult.fold(
      (failure) => null,
      (user) => user.id,
    );
    if (currentUserId == null) {
      emit(
        OrderError(
          message: 'User not found',
          cartItems: state.cartItems,
          orders: state.orders,
        ),
      );
      return;
    }

    final result = await createOrderUseCase(
      type: event.type,
      userId: currentUserId,
      tableId: tableId,
      discountPercent: event.discount,
      orderItems: event.orderItems,
    );

    await result.fold(
      (failure) {
        emit(
          OrderError(
            message: _mapFailureToMessage(failure),
            cartItems: state.cartItems,
            orders: state.orders,
          ),
        );
      },
      (order) async {
        try {
          final printResult = await kitchenPrinterService.printKitchenTicket(
            order,
          );

          if (emit.isDone) return;

          if (printResult) {
            emit(
              OrderOperationSuccess(
                message: 'Order created successfully',
                cartItems: const [],
                orders: [...state.orders, order],
              ),
            );
          } else {
            emit(
              OrderCreatedPrintFailed(
                order: order,
                errorMessage:
                    'Buyurtma yaratildi, oshxonadagi printer ishlamadi.',
              ),
            );
          }
        } catch (e) {
          if (emit.isDone) return;
          emit(
            OrderError(
              message: 'Xatolik yuz berdi: $e',
              cartItems: state.cartItems,
              orders: state.orders,
            ),
          );
        }
      },
    );
  }

  Future<void> _onUpdateOrder(
    UpdateOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading(cartItems: state.cartItems, orders: state.orders));

    int? tableId;
    if (event.tableNumber != null) {
      final tableResult = await getTableByNumberUseCase(
        tableNumber: event.tableNumber!,
      );

      tableId = tableResult.fold((failure) => null, (table) => table.id);

      if (tableId == null) {
        emit(
          OrderError(
            message: 'Table not found',
            cartItems: state.cartItems,
            orders: state.orders,
          ),
        );
        return;
      }
    }
    final result = await updateOrderUseCase(
      id: event.id,
      type: event.type,
      userId: event.userId,
      tableId: tableId,
    );

    result.fold(
      (failure) => emit(
        OrderError(
          message: _mapFailureToMessage(failure),
          cartItems: state.cartItems,
          orders: state.orders,
        ),
      ),
      (order) {
        final updatedOrders = state.orders.map((o) {
          return o.id == order.id ? order : o;
        }).toList();

        emit(
          OrderOperationSuccess(
            message: 'Order updated successfully',
            cartItems: state.cartItems,
            orders: updatedOrders,
          ),
        );
      },
    );
  }

  Future<void> _onRejectOrder(
    RejectOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading(cartItems: state.cartItems, orders: state.orders));

    final result = await rejectOrderUseCase(
      id: event.id,
      request: event.request,
    );

    result.fold(
      (failure) => emit(
        OrderError(
          message: _mapFailureToMessage(failure),
          cartItems: [],
          orders: state.orders,
        ),
      ),
      (order) {
        emit(
          OrderOperationSuccess(
            message: 'Order rejected successfully',
            cartItems: const [],
            orders: state.orders,
          ),
        );
      },
    );
  }

  Future<void> _onDeleteOrder(
    DeleteOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading(cartItems: state.cartItems, orders: state.orders));

    final result = await deleteOrderUseCase(event.id);

    result.fold(
      (failure) => emit(
        OrderError(
          message: _mapFailureToMessage(failure),
          cartItems: state.cartItems,
          orders: state.orders,
        ),
      ),
      (_) {
        final updatedOrders = state.orders
            .where((o) => o.id != event.id)
            .toList();
        emit(
          OrderOperationSuccess(
            message: 'Order deleted successfully',
            cartItems: state.cartItems,
            orders: updatedOrders,
          ),
        );
      },
    );
  }

  Future<void> _onPrintBill(
    PrintBillEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading(cartItems: state.cartItems, orders: state.orders));
    try {
      final printResult = await printerService.printOrderBill(event.order);
      if (printResult) {
        emit(
          OrderOperationSuccess(
            message: 'Bill printed successfully',
            cartItems: state.cartItems,
            orders: state.orders,
          ),
        );
      } else {
        emit(
          OrderError(
            message: 'Failed to print the bill',
            cartItems: state.cartItems,
            orders: state.orders,
          ),
        );
      }
    } catch (e) {
      emit(
        OrderError(
          message: e.toString(),
          cartItems: state.cartItems,
          orders: state.orders,
        ),
      );
    }
  }

  Future<void> _onCloseOrder(
    CloseOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading(cartItems: state.cartItems, orders: state.orders));
    final result = await closeOrderUseCase(event.order.id);
    result.fold(
      (failure) => emit(
        OrderError(
          message: _mapFailureToMessage(failure),
          cartItems: state.cartItems,
          orders: state.orders,
        ),
      ),
      (_) {
        final updatedOrders = state.orders
            .where((o) => o.id != event.order.id)
            .toList();
        emit(
          OrderOperationSuccess(
            message: 'Order closed successfully',
            cartItems: state.cartItems,
            orders: updatedOrders,
          ),
        );
      },
    );
  }

  Future<void> _onUpdateOrderItems(
    UpdateOrderItemsEvent event,
    Emitter<OrderState> emit,
  ) async {
    final oldOrderItems = <int, int>{};
    if (state.updatingOrder != null) {
      for (final item in state.updatingOrder!.order.orderItems) {
        oldOrderItems[item.product.id] = item.amount;
      }
    }

    emit(
      OrderLoading(
        updatingOrder: state.updatingOrder,
        cartItems: state.cartItems,
        orders: state.orders,
      ),
    );
    int? tableId;
    if (event.tableNumber != null) {
      final tableResult = await getTableByNumberUseCase(
        tableNumber: event.tableNumber!,
      );

      tableId = tableResult.fold((failure) => null, (table) => table.id);

      if (tableId == null) {
        emit(
          OrderError(
            message: 'Table not found',
            cartItems: state.cartItems,
            orders: state.orders,
          ),
        );
        return;
      }
    }
    final result = await updateOrderItemsUseCase(
      type: event.type,
      userId: event.userId,
      tableId: tableId,
      password: event.password,
      orderId: event.orderId,
      orderItems: event.orderItems,
    );

    await result.fold(
      (failure) async {
        emit(
          OrderError(
            message: _mapFailureToMessage(failure),
            cartItems: state.cartItems,
            orders: state.orders,
          ),
        );
      },
      (order) async {
        final itemsToPrint = <OrderItemEntity>[];
        for (final newItem in order.orderItems) {
          final oldQty = oldOrderItems[newItem.product.id] ?? 0;
          final diff = newItem.amount - oldQty;
          if (diff > 0) {
            itemsToPrint.add(
              OrderItemEntity(
                id: newItem.id,
                amount: diff,
                product: newItem.product,
                comment: newItem.comment,
              ),
            );
          }
        }

        final updatedOrders = state.orders.map((o) {
          return o.id == order.id ? order : o;
        }).toList();

        emit(
          OrderOperationSuccess(
            message: 'Order updated successfully',
            cartItems: const [],
            orders: updatedOrders,
          ),
        );
      },
    );
  }

  Future<void> _onAddItemsToOrder(
    AddItemsToOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    final newItemsToPrint = <Map<String, dynamic>>[];
    for (final newItem in event.orderItems) {
      final oldItem = event.oldOrderItems
          .cast<Map<String, dynamic>>()
          .firstWhere(
            (o) => o['product_id'] == newItem['product_id'],
            orElse: () => <String, dynamic>{},
          );

      if (oldItem.isEmpty) {
        newItemsToPrint.add(newItem);
      } else {
        final oldAmount = oldItem['amount'] as int;
        final newAmount = newItem['amount'] as int;
        final oldComment = (oldItem['comment'] ?? '').toString().trim();
        final newComment = (newItem['comment'] ?? '').toString().trim();

        if (newAmount > oldAmount) {
          newItemsToPrint.add({
            ...newItem,
            'amount': newAmount - oldAmount,
            // Send comment only if it changed, otherwise empty
            'comment': newComment != oldComment ? newComment : '',
          });
        }
      }
    }

    emit(OrderLoading(cartItems: state.cartItems, orders: state.orders));

    final result = await addItemsToOrderUseCase(
      orderId: event.orderId,
      type: event.type,
      tableId: event.tableId,
      orderItems: event.orderItems,
    );

    await result.fold(
      (failure) {
        emit(
          OrderError(
            message: _mapFailureToMessage(failure),
            cartItems: state.cartItems,
            orders: state.orders,
          ),
        );
      },
      (order) async {
        final updatedOrders = state.orders.map((o) {
          return o.id == order.id ? order : o;
        }).toList();

        if (newItemsToPrint.isNotEmpty) {
          try {
            final printResult = await kitchenPrinterService
                .printKitchenTicketFromMap(
                  orderNumber: event.orderNumber,
                  type: event.type,
                  items: newItemsToPrint,
                  tableNumber: event.tableId,
                  waiterName: order.user?.username,
                  createdAt: order.createdAt,
                );

            if (emit.isDone) return;

            if (!printResult) {
              emit(
                OrderCreatedPrintFailed(
                  order: order,
                  errorMessage:
                      'Buyurtma yangilandi, oshxonadagi printer ishlamadi.',
                ),
              );
              return;
            }
          } catch (e) {
            if (emit.isDone) return;
            emit(
              OrderCreatedPrintFailed(
                order: order,
                errorMessage:
                    'Buyurtma yangilandi, oshxonadagi printer ishlamadi.',
              ),
            );
            return;
          }
        }

        if (emit.isDone) return;

        emit(
          OrderOperationSuccess(
            message: 'Order updated successfully',
            cartItems: state.cartItems,
            orders: updatedOrders,
          ),
        );
      },
    );
  }

  Future<void> _onWatchOrders(
    WatchOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading(cartItems: state.cartItems, orders: state.orders));
    await emit.forEach(
      watchOrdersUseCase(),
      onData: (result) {
        return result.fold(
          (failure) => OrderError(
            message: _mapFailureToMessage(failure),
            cartItems: state.cartItems,
            orders: state.orders,
          ),
          (orders) {
            return OrdersLoaded(
              orders: orders,
              cartItems: state.cartItems,
              hasReachedMax: false,
            );
          },
        );
      },
      onError: (error, stackTrace) {
        return OrderError(
          message: error.toString(),
          cartItems: state.cartItems,
          orders: state.orders,
        );
      },
    );
  }

  void _onAddToCart(AddToCartEvent event, Emitter<OrderState> emit) {
    final existingItemIndex = state.cartItems.indexWhere(
      (item) => item.productId == event.productId,
    );

    if (existingItemIndex != -1) {
      final updatedCart = List<CartItem>.from(state.cartItems);
      updatedCart[existingItemIndex] = updatedCart[existingItemIndex].copyWith(
        quantity: updatedCart[existingItemIndex].quantity + 1,
      );
      emit(
        CartUpdated(
          updatingOrder: state.updatingOrder,
          cartItems: updatedCart,
          orders: state.orders,
        ),
      );
    } else {
      final newItem = CartItem(
        productId: event.productId,
        productName: event.productName,
        price: event.price,
        image: event.image,
        quantity: 1,
      );
      emit(
        CartUpdated(
          updatingOrder: state.updatingOrder,
          cartItems: [...state.cartItems, newItem],
          orders: state.orders,
        ),
      );
    }
  }

  void _onRemoveFromCart(RemoveFromCartEvent event, Emitter<OrderState> emit) {
    final existingItemIndex = state.cartItems.indexWhere(
      (item) => item.productId == event.productId,
    );

    if (existingItemIndex != -1) {
      final updatedCart = List<CartItem>.from(state.cartItems);
      if (updatedCart[existingItemIndex].quantity > 1) {
        updatedCart[existingItemIndex] = updatedCart[existingItemIndex]
            .copyWith(quantity: updatedCart[existingItemIndex].quantity - 1);
      } else {
        updatedCart.removeAt(existingItemIndex);
      }
      emit(
        CartUpdated(
          updatingOrder: state.updatingOrder,
          cartItems: updatedCart,
          orders: state.orders,
        ),
      );
    }
  }

  void _onClearCart(ClearCartEvent event, Emitter<OrderState> emit) {
    emit(CartUpdated(cartItems: const [], orders: state.orders));
  }

  void _onSetOrderForEditing(
    SetOrderForEditing event,
    Emitter<OrderState> emit,
  ) {
    final cartItems = event.order.orderItems
        .map(
          (item) => CartItem(
            productId: item.product.id,
            productName: item.product.nameRu,
            price: item.product.price,
            image: item.product.image,
            quantity: item.amount,
          ),
        )
        .toList();

    emit(
      CartUpdated(
        updatingOrder: UpdateOrderModel(
          order: event.order,
          cartItems: cartItems,
        ),
        cartItems: cartItems,
        orders: state.orders,
        hasReachedMax: state.hasReachedMax,
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.message;
      case ConnectionFailure:
        return failure.message;
      case DatabaseFailure:
        return failure.message;
      default:
        return 'Unexpected error';
    }
  }

  @override
  Future<void> close() {
    _orderSubscription?.cancel();
    return super.close();
  }
}
