part of 'orders_bloc.dart';

class CartItem {
  final int productId;
  final String productName;
  final int price;
  final String image;
  int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.image,
    this.quantity = 1,
  });

  int get totalPrice => price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      productId: productId,
      productName: productName,
      price: price,
      image: image,
      quantity: quantity ?? this.quantity,
    );
  }
}

abstract class OrderState extends Equatable {
  final List<CartItem> cartItems;
  final int? orderId;
  final List<OrderEntity> orders;
  final bool hasReachedMax;
  final bool isLoadMore;

  const OrderState({
    this.orderId,
    this.cartItems = const [],
    this.orders = const [],
    this.hasReachedMax = false,
    this.isLoadMore = false,
  });

  int get cartTotalPrice {
    return cartItems.fold(0, (total, item) => total + item.totalPrice);
  }

  @override
  List<Object> get props => [cartItems, orders, hasReachedMax, isLoadMore];
}

class OrderInitial extends OrderState {
  const OrderInitial();
}

class OrderLoading extends OrderState {
  const OrderLoading({
    super.cartItems,
    super.orders,
    super.hasReachedMax,
    super.isLoadMore,
  });
}

class OrdersLoaded extends OrderState {
  const OrdersLoaded({
    required super.orders,
    super.cartItems,
    super.hasReachedMax,
  });
}

class CartUpdated extends OrderState {
  const CartUpdated({
    super.orderId,
    required super.cartItems,
    super.orders,
    super.hasReachedMax,
  });
}

class OrderCreatedPrintFailed extends OrderState {
  final OrderEntity order;
  final String errorMessage;

  const OrderCreatedPrintFailed({
    required this.order,
    required this.errorMessage,
  });
}

class OrderOperationSuccess extends OrderState {
  final String message;

  const OrderOperationSuccess({
    required this.message,
    super.cartItems,
    super.orders,
    super.hasReachedMax,
  });

  @override
  List<Object> get props => [message, ...super.props];
}

class OrderError extends OrderState {
  final String message;

  const OrderError({
    required this.message,
    super.cartItems,
    super.orders,
    super.hasReachedMax,
  });

  @override
  List<Object> get props => [message, ...super.props];
}
