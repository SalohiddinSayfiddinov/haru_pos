part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  final List<ProductEntity> products;
  final bool hasReachedMax;
  final int currentPage;

  const ProductState({
    this.products = const [],
    this.hasReachedMax = false,
    this.currentPage = 0,
  });

  @override
  List<Object> get props => [products, hasReachedMax, currentPage];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  final bool isLoadMore;

  const ProductLoading({
    super.products,
    super.hasReachedMax,
    super.currentPage,
    this.isLoadMore = false,
  });

  @override
  List<Object> get props => [products, hasReachedMax, currentPage, isLoadMore];
}

class ProductsLoaded extends ProductState {
  const ProductsLoaded({
    required super.products,
    super.hasReachedMax,
    super.currentPage,
  });

  ProductsLoaded copyWith({
    List<ProductEntity>? products,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class ProductOperationSuccess extends ProductState {
  final String message;

  const ProductOperationSuccess(
    this.message, {
    super.products,
    super.hasReachedMax,
    super.currentPage,
  });

  @override
  List<Object> get props => [message, ...super.props];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(
    this.message, {
    super.products,
    super.hasReachedMax,
    super.currentPage,
  });

  @override
  List<Object> get props => [message, ...super.props];
}
