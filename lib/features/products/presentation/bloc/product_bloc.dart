import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:haru_pos/core/errors/failures.dart';
import 'package:haru_pos/features/products/domain/entities/product_entity.dart';
import 'package:haru_pos/features/products/domain/usecases/product_usecases.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

part 'product_event.dart';
part 'product_state.dart';

@injectable
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;
  final CreateProductUseCase createProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;

  static const int _productsPerPage = 10;

  ProductBloc({
    required this.getProductsUseCase,
    required this.createProductUseCase,
    required this.updateProductUseCase,
    required this.deleteProductUseCase,
  }) : super(const ProductInitial()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<CreateProductEvent>(_onCreateProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
    on<ClearProductsEvent>(_onClearProducts);
  }

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    if (event.loadMore) {
      if (state.hasReachedMax) {
        return;
      }
    }

    if (!event.loadMore) {
      emit(const ProductLoading());
    } else {
      emit(
        ProductLoading(
          products: state.products,
          hasReachedMax: state.hasReachedMax,
          currentPage: state.currentPage,
          isLoadMore: true,
        ),
      );
    }

    final nextPage = event.loadMore ? state.currentPage + 1 : 0;

    final result = await getProductsUseCase(
      limit: _productsPerPage,
      offset: nextPage * _productsPerPage,
      categoryId: event.categoryId,
      search: event.search,
    );

    result.fold(
      (failure) => emit(
        ProductError(
          _mapFailureToMessage(failure),
          products: state.products,
          hasReachedMax: state.hasReachedMax,
          currentPage: state.currentPage,
        ),
      ),
      (products) {
        if (event.loadMore) {
          final allProducts = [...state.products, ...products];
          emit(
            ProductsLoaded(
              products: allProducts,
              hasReachedMax: products.length < _productsPerPage,
              currentPage: nextPage,
            ),
          );
        } else {
          emit(
            ProductsLoaded(
              products: products,
              hasReachedMax: products.length < _productsPerPage,
              currentPage: 0,
            ),
          );
        }
      },
    );
  }

  Future<void> _onCreateProduct(
    CreateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      ProductLoading(
        products: state.products,
        hasReachedMax: state.hasReachedMax,
        currentPage: state.currentPage,
      ),
    );

    final result = await createProductUseCase(
      nameRu: event.nameRu,
      nameUz: event.nameUz,
      price: event.price,
      image: event.image,
      categoryId: event.categoryId,
      status: event.status,
      comment: event.comment,
      descriptionRu: event.descriptionRu,
      descriptionUz: event.descriptionUz,
    );

    result.fold(
      (failure) => emit(
        ProductError(
          _mapFailureToMessage(failure),
          products: state.products,
          hasReachedMax: state.hasReachedMax,
          currentPage: state.currentPage,
        ),
      ),
      (product) {
        emit(
          ProductOperationSuccess(
            'Product created successfully',
            products: state.products,
            hasReachedMax: state.hasReachedMax,
            currentPage: state.currentPage,
          ),
        );
      },
    );
  }

  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      ProductLoading(
        products: state.products,
        hasReachedMax: state.hasReachedMax,
        currentPage: state.currentPage,
      ),
    );

    final result = await updateProductUseCase(
      id: event.id,
      nameRu: event.nameRu,
      nameUz: event.nameUz,
      price: event.price,
      image: event.image,
      categoryId: event.categoryId,
      status: event.status,
      comment: event.comment,
      descriptionRu: event.descriptionRu,
      descriptionUz: event.descriptionUz,
    );

    result.fold(
      (failure) => emit(
        ProductError(
          _mapFailureToMessage(failure),
          products: state.products,
          hasReachedMax: state.hasReachedMax,
          currentPage: state.currentPage,
        ),
      ),
      (product) {
        emit(
          ProductOperationSuccess(
            'Product updated successfully',
            products: state.products,
            hasReachedMax: state.hasReachedMax,
            currentPage: state.currentPage,
          ),
        );
      },
    );
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      ProductLoading(
        products: state.products,
        hasReachedMax: state.hasReachedMax,
        currentPage: state.currentPage,
      ),
    );

    final result = await deleteProductUseCase(event.id);

    result.fold(
      (failure) => emit(
        ProductError(
          _mapFailureToMessage(failure),
          products: state.products,
          hasReachedMax: state.hasReachedMax,
          currentPage: state.currentPage,
        ),
      ),
      (_) {
        emit(
          ProductOperationSuccess(
            'Product deleted successfully',
            products: state.products,
            hasReachedMax: state.hasReachedMax,
            currentPage: state.currentPage,
          ),
        );
      },
    );
  }

  Future<void> _onClearProducts(
    ClearProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductInitial());
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (ServerFailure):
        return failure.message;
      case const (ConnectionFailure):
        return failure.message;
      case const (DatabaseFailure):
        return failure.message;
      default:
        return 'Unexpected error';
    }
  }
}
