import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:haru_pos/core/di/injection.dart';
import 'package:haru_pos/core/routes/app_pages.dart';
import 'package:haru_pos/core/utils/token_service.dart';
import 'package:haru_pos/core/widgets/home_scaffold.dart';
import 'package:haru_pos/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:haru_pos/features/auth/presentation/screens/auth_screen.dart';
import 'package:haru_pos/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:haru_pos/features/categories/presentation/screens/categories_screen.dart';
import 'package:haru_pos/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:haru_pos/features/employee/presentation/bloc/employee_bloc.dart';
import 'package:haru_pos/features/employee/presentation/screens/employee_screen.dart';
import 'package:haru_pos/features/hall/presentation/bloc/table_bloc.dart';
import 'package:haru_pos/features/hall/presentation/screens/hall_screen.dart';
import 'package:haru_pos/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:haru_pos/features/orders/presentation/screens/order_history_screen.dart';
import 'package:haru_pos/features/orders/presentation/screens/orders_screen.dart';
import 'package:haru_pos/features/products/data/models/products_screen_extra.dart';
import 'package:haru_pos/features/products/presentation/bloc/product_bloc.dart';
import 'package:haru_pos/features/products/presentation/screens/add_product_screen.dart';
import 'package:haru_pos/features/products/presentation/screens/products_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppPages.auth,
    redirect: (context, state) async {
      final tokenService = getIt<TokenService>();
      final isLoggedIn = await tokenService.hasTokens();

      final isGoingToAuth = state.matchedLocation == AppPages.auth;

      if (!isLoggedIn && !isGoingToAuth) {
        return AppPages.auth;
      }

      if (isLoggedIn && isGoingToAuth) {
        return AppPages.dashboard;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppPages.auth,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AuthBloc>()..add(CheckAuthStatusEvent()),
          child: const AuthScreen(),
        ),
      ),

      ShellRoute(
        builder: (context, state, child) => BlocProvider(
          create: (context) => getIt<AuthBloc>(),
          child: HomeScaffold(
            body: child,
            padding: state.fullPath == AppPages.products
                ? EdgeInsets.zero
                : null,
          ),
        ),
        routes: [
          GoRoute(
            path: AppPages.dashboard,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: DashboardScreen()),
          ),
          GoRoute(
            path: AppPages.categories,
            pageBuilder: (context, state) => NoTransitionPage(
              child: BlocProvider(
                create: (context) => getIt<CategoryBloc>(),
                child: CategoriesScreen(),
              ),
            ),
          ),
          GoRoute(
            path: AppPages.products,
            pageBuilder: (context, state) => NoTransitionPage(
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => getIt<CategoryBloc>()),
                  BlocProvider(create: (context) => getIt<ProductBloc>()),
                  BlocProvider(create: (context) => getIt<OrderBloc>()),
                  BlocProvider(create: (context) => getIt<TableBloc>()),
                ],
                child: ProductsScreen(),
              ),
            ),
          ),
          GoRoute(
            path: AppPages.addProduct,
            pageBuilder: (context, state) {
              final extra = state.extra as ProductScreenExtra;
              return NoTransitionPage(
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (context) => getIt<CategoryBloc>()),
                    BlocProvider(create: (context) => getIt<ProductBloc>()),
                  ],
                  child: AddProductScreen(extra: extra),
                ),
              );
            },
          ),
          GoRoute(
            path: AppPages.hall,
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: BlocProvider(
                  create: (context) => getIt<TableBloc>(),
                  child: HallScreen(),
                ),
              );
            },
          ),
          GoRoute(
            path: AppPages.orders,
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: BlocProvider(
                  create: (context) => getIt<OrderBloc>(),
                  child: OrdersScreen(),
                ),
              );
            },
          ),
          GoRoute(
            path: AppPages.orderHistory,
            pageBuilder: (context, state) {
              return NoTransitionPage(child: OrderHistoryScreen());
            },
          ),
          GoRoute(
            path: AppPages.employees,
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: BlocProvider(
                  create: (context) => getIt<EmployeeBloc>(),
                  child: EmployeeScreen(),
                ),
              );
            },
          ),
        ],
      ),
    ],

    // Error page
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Error: ${state.error}'))),
  );
}
