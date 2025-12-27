// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:haru_pos/core/network/dio_module.dart' as _i178;
import 'package:haru_pos/core/services/kitchen_printer_service.dart' as _i114;
import 'package:haru_pos/core/services/thermal_priner_service.dart' as _i950;
import 'package:haru_pos/core/utils/register_module.dart' as _i1069;
import 'package:haru_pos/core/utils/token_service.dart' as _i471;
import 'package:haru_pos/features/auth/data/datasources/auth_remote_data_source.dart'
    as _i107;
import 'package:haru_pos/features/auth/data/repositories/auth_repository_impl.dart'
    as _i1056;
import 'package:haru_pos/features/auth/domain/repositories/auth_repository.dart'
    as _i731;
import 'package:haru_pos/features/auth/domain/usecases/auth_usecases.dart'
    as _i1016;
import 'package:haru_pos/features/auth/presentation/bloc/auth_bloc.dart'
    as _i746;
import 'package:haru_pos/features/categories/data/datasources/category_remote_data_source.dart'
    as _i140;
import 'package:haru_pos/features/categories/data/repositories/categories_repository_impl.dart'
    as _i605;
import 'package:haru_pos/features/categories/domain/repositories/categories_repository.dart'
    as _i440;
import 'package:haru_pos/features/categories/domain/usecases/category_usecases.dart'
    as _i802;
import 'package:haru_pos/features/categories/presentation/bloc/categories_bloc.dart'
    as _i1045;
import 'package:haru_pos/features/employee/data/datasources/employee_remote_data_source.dart'
    as _i181;
import 'package:haru_pos/features/employee/data/repository/employee_repository_impl.dart'
    as _i78;
import 'package:haru_pos/features/employee/domain/repositories/employee_repository.dart'
    as _i222;
import 'package:haru_pos/features/employee/domain/usecases/employee_usecases.dart'
    as _i355;
import 'package:haru_pos/features/employee/presentation/bloc/employee_bloc.dart'
    as _i102;
import 'package:haru_pos/features/hall/data/datasources/table_remote_data_source.dart'
    as _i431;
import 'package:haru_pos/features/hall/data/repositories/table_repository_impl.dart'
    as _i1061;
import 'package:haru_pos/features/hall/domain/repositories/table_repository.dart.dart'
    as _i758;
import 'package:haru_pos/features/hall/domain/usecases/table_usecases.dart'
    as _i57;
import 'package:haru_pos/features/hall/presentation/bloc/table_bloc.dart'
    as _i1016;
import 'package:haru_pos/features/orders/data/datasources/orders_remote_datasource.dart'
    as _i652;
import 'package:haru_pos/features/orders/data/repositories/orders_repository_impl.dart'
    as _i72;
import 'package:haru_pos/features/orders/domain/repositories/orders_repository.dart'
    as _i740;
import 'package:haru_pos/features/orders/domain/usecases/order_usecases.dart'
    as _i949;
import 'package:haru_pos/features/orders/presentation/bloc/orders_bloc.dart'
    as _i1019;
import 'package:haru_pos/features/products/data/datasources/product_remote_data_source.dart'
    as _i256;
import 'package:haru_pos/features/products/data/repositories/product_repository_impl.dart'
    as _i385;
import 'package:haru_pos/features/products/domain/repositories/product_repository.dart'
    as _i411;
import 'package:haru_pos/features/products/domain/usecases/product_usecases.dart'
    as _i791;
import 'package:haru_pos/features/products/presentation/bloc/product_bloc.dart'
    as _i101;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    final dioModule = _$DioModule();
    gh.factory<_i114.KitchenPrinterService>(
      () => _i114.KitchenPrinterService(),
    );
    gh.factory<_i950.ThermalPrinterService>(
      () => _i950.ThermalPrinterService(),
    );
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i361.Dio>(() => dioModule.dio());
    gh.lazySingleton<_i471.TokenService>(
      () => _i471.TokenServiceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i652.OrderRemoteDataSource>(
      () => _i652.OrderRemoteDataSourceImpl(dio: gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i107.AuthRemoteDataSource>(
      () => _i107.AuthRemoteDataSourceImpl(dio: gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i181.EmployeeRemoteDataSource>(
      () => _i181.EmployeeRemoteDataSourceImpl(dio: gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i740.OrderRepository>(
      () => _i72.OrderRepositoryImpl(
        remoteDataSource: gh<_i652.OrderRemoteDataSource>(),
      ),
    );
    gh.factory<_i949.GetOrdersUseCase>(
      () => _i949.GetOrdersUseCase(gh<_i740.OrderRepository>()),
    );
    gh.factory<_i949.CreateOrderUseCase>(
      () => _i949.CreateOrderUseCase(gh<_i740.OrderRepository>()),
    );
    gh.factory<_i949.UpdateOrderUseCase>(
      () => _i949.UpdateOrderUseCase(gh<_i740.OrderRepository>()),
    );
    gh.factory<_i949.DeleteOrderUseCase>(
      () => _i949.DeleteOrderUseCase(gh<_i740.OrderRepository>()),
    );
    gh.factory<_i949.CloseOrderUseCase>(
      () => _i949.CloseOrderUseCase(gh<_i740.OrderRepository>()),
    );
    gh.factory<_i949.AddItemsToOrderUseCase>(
      () => _i949.AddItemsToOrderUseCase(gh<_i740.OrderRepository>()),
    );
    gh.factory<_i949.UpdateOrderItemsUseCase>(
      () => _i949.UpdateOrderItemsUseCase(gh<_i740.OrderRepository>()),
    );
    gh.lazySingleton<_i140.CategoryRemoteDataSource>(
      () => _i140.CategoryRemoteDataSourceImpl(dio: gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i431.TableRemoteDataSource>(
      () => _i431.TableRemoteDataSourceImpl(dio: gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i222.EmployeeRepository>(
      () => _i78.EmployeeRepositoryImpl(
        remoteDataSource: gh<_i181.EmployeeRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i256.ProductRemoteDataSource>(
      () => _i256.ProductRemoteDataSourceImpl(dio: gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i758.TableRepository>(
      () => _i1061.TableRepositoryImpl(
        remoteDataSource: gh<_i431.TableRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i440.CategoryRepository>(
      () => _i605.CategoryRepositoryImpl(
        remoteDataSource: gh<_i140.CategoryRemoteDataSource>(),
      ),
    );
    gh.factory<_i802.GetCategoriesUseCase>(
      () => _i802.GetCategoriesUseCase(gh<_i440.CategoryRepository>()),
    );
    gh.factory<_i802.CreateCategoryUseCase>(
      () => _i802.CreateCategoryUseCase(gh<_i440.CategoryRepository>()),
    );
    gh.factory<_i802.UpdateCategoryUseCase>(
      () => _i802.UpdateCategoryUseCase(gh<_i440.CategoryRepository>()),
    );
    gh.factory<_i802.DeleteCategoryUseCase>(
      () => _i802.DeleteCategoryUseCase(gh<_i440.CategoryRepository>()),
    );
    gh.lazySingleton<_i731.AuthRepository>(
      () => _i1056.AuthRepositoryImpl(
        remoteDataSource: gh<_i107.AuthRemoteDataSource>(),
        tokenService: gh<_i471.TokenService>(),
      ),
    );
    gh.factory<_i1045.CategoryBloc>(
      () => _i1045.CategoryBloc(
        getCategoriesUseCase: gh<_i802.GetCategoriesUseCase>(),
        createCategoryUseCase: gh<_i802.CreateCategoryUseCase>(),
        updateCategoryUseCase: gh<_i802.UpdateCategoryUseCase>(),
        deleteCategoryUseCase: gh<_i802.DeleteCategoryUseCase>(),
      ),
    );
    gh.factory<_i57.GetTablesUseCase>(
      () => _i57.GetTablesUseCase(gh<_i758.TableRepository>()),
    );
    gh.factory<_i57.CreateTableUseCase>(
      () => _i57.CreateTableUseCase(gh<_i758.TableRepository>()),
    );
    gh.factory<_i57.GetTableByNumberUseCase>(
      () => _i57.GetTableByNumberUseCase(gh<_i758.TableRepository>()),
    );
    gh.factory<_i57.UpdateTableUseCase>(
      () => _i57.UpdateTableUseCase(gh<_i758.TableRepository>()),
    );
    gh.factory<_i57.DeleteTableUseCase>(
      () => _i57.DeleteTableUseCase(gh<_i758.TableRepository>()),
    );
    gh.factory<_i57.DeleteTableBookUseCase>(
      () => _i57.DeleteTableBookUseCase(gh<_i758.TableRepository>()),
    );
    gh.factory<_i57.BookTableUseCase>(
      () => _i57.BookTableUseCase(gh<_i758.TableRepository>()),
    );
    gh.lazySingleton<_i411.ProductRepository>(
      () => _i385.ProductRepositoryImpl(
        remoteDataSource: gh<_i256.ProductRemoteDataSource>(),
      ),
    );
    gh.factory<_i355.GetEmployeesUseCase>(
      () => _i355.GetEmployeesUseCase(gh<_i222.EmployeeRepository>()),
    );
    gh.factory<_i355.CreateEmployeeUseCase>(
      () => _i355.CreateEmployeeUseCase(gh<_i222.EmployeeRepository>()),
    );
    gh.factory<_i355.UpdateEmployeeUseCase>(
      () => _i355.UpdateEmployeeUseCase(gh<_i222.EmployeeRepository>()),
    );
    gh.factory<_i355.DeleteEmployeeUseCase>(
      () => _i355.DeleteEmployeeUseCase(gh<_i222.EmployeeRepository>()),
    );
    gh.factory<_i1016.LoginUseCase>(
      () => _i1016.LoginUseCase(gh<_i731.AuthRepository>()),
    );
    gh.factory<_i1016.LogoutUseCase>(
      () => _i1016.LogoutUseCase(gh<_i731.AuthRepository>()),
    );
    gh.factory<_i1016.RefreshTokenUseCase>(
      () => _i1016.RefreshTokenUseCase(gh<_i731.AuthRepository>()),
    );
    gh.factory<_i1016.IsLoggedInUseCase>(
      () => _i1016.IsLoggedInUseCase(gh<_i731.AuthRepository>()),
    );
    gh.factory<_i1016.GetAccessTokenUseCase>(
      () => _i1016.GetAccessTokenUseCase(gh<_i731.AuthRepository>()),
    );
    gh.factory<_i1016.GetCurrentUserUseCase>(
      () => _i1016.GetCurrentUserUseCase(gh<_i731.AuthRepository>()),
    );
    gh.factory<_i1016.TableBloc>(
      () => _i1016.TableBloc(
        getTablesUseCase: gh<_i57.GetTablesUseCase>(),
        getTableByNumberUseCase: gh<_i57.GetTableByNumberUseCase>(),
        createTableUseCase: gh<_i57.CreateTableUseCase>(),
        updateTableUseCase: gh<_i57.UpdateTableUseCase>(),
        deleteTableUseCase: gh<_i57.DeleteTableUseCase>(),
        bookTableUseCase: gh<_i57.BookTableUseCase>(),
        deleteTableBookUseCase: gh<_i57.DeleteTableBookUseCase>(),
      ),
    );
    gh.factory<_i746.AuthBloc>(
      () => _i746.AuthBloc(
        loginUseCase: gh<_i1016.LoginUseCase>(),
        logoutUseCase: gh<_i1016.LogoutUseCase>(),
        isLoggedInUseCase: gh<_i1016.IsLoggedInUseCase>(),
        getCurrentUserUseCase: gh<_i1016.GetCurrentUserUseCase>(),
      ),
    );
    gh.factory<_i791.GetProductsUseCase>(
      () => _i791.GetProductsUseCase(gh<_i411.ProductRepository>()),
    );
    gh.factory<_i791.CreateProductUseCase>(
      () => _i791.CreateProductUseCase(gh<_i411.ProductRepository>()),
    );
    gh.factory<_i791.UpdateProductUseCase>(
      () => _i791.UpdateProductUseCase(gh<_i411.ProductRepository>()),
    );
    gh.factory<_i791.DeleteProductUseCase>(
      () => _i791.DeleteProductUseCase(gh<_i411.ProductRepository>()),
    );
    gh.factory<_i101.ProductBloc>(
      () => _i101.ProductBloc(
        getProductsUseCase: gh<_i791.GetProductsUseCase>(),
        createProductUseCase: gh<_i791.CreateProductUseCase>(),
        updateProductUseCase: gh<_i791.UpdateProductUseCase>(),
        deleteProductUseCase: gh<_i791.DeleteProductUseCase>(),
      ),
    );
    gh.factory<_i1019.OrderBloc>(
      () => _i1019.OrderBloc(
        getOrdersUseCase: gh<_i949.GetOrdersUseCase>(),
        getCurrentUserUseCase: gh<_i1016.GetCurrentUserUseCase>(),
        getTableByNumberUseCase: gh<_i57.GetTableByNumberUseCase>(),
        createOrderUseCase: gh<_i949.CreateOrderUseCase>(),
        updateOrderUseCase: gh<_i949.UpdateOrderUseCase>(),
        deleteOrderUseCase: gh<_i949.DeleteOrderUseCase>(),
        closeOrderUseCase: gh<_i949.CloseOrderUseCase>(),
        printerService: gh<_i950.ThermalPrinterService>(),
        kitchenPrinterService: gh<_i114.KitchenPrinterService>(),
        addItemsToOrderUseCase: gh<_i949.AddItemsToOrderUseCase>(),
        updateOrderItemsUseCase: gh<_i949.UpdateOrderItemsUseCase>(),
      ),
    );
    gh.factory<_i102.EmployeeBloc>(
      () => _i102.EmployeeBloc(
        getEmployeesUseCase: gh<_i355.GetEmployeesUseCase>(),
        createEmployeeUseCase: gh<_i355.CreateEmployeeUseCase>(),
        updateEmployeeUseCase: gh<_i355.UpdateEmployeeUseCase>(),
        deleteEmployeeUseCase: gh<_i355.DeleteEmployeeUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i1069.RegisterModule {}

class _$DioModule extends _i178.DioModule {}
