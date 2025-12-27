import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:haru_pos/core/di/injection.dart';
import 'package:haru_pos/core/widgets/app_snack_bar.dart';
import 'package:haru_pos/features/products/presentation/bloc/product_bloc.dart';

class DeleteProductDialog extends StatelessWidget {
  final int productId;
  final String productName;

  const DeleteProductDialog({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProductBloc>(),
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Удалить продукт?'),
        content: Text('Вы уверены, что хотите удалить продукт "$productName"?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            style: TextButton.styleFrom(foregroundColor: Colors.blue),
            child: const Text('Отмена'),
          ),
          BlocConsumer<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is ProductOperationSuccess) {
                Navigator.pop(context, true);
              } else if (state is ProductError) {
                AppSnackbar.error(context, state.message);
              }
            },
            builder: (context, state) {
              return TextButton(
                onPressed: state is ProductLoading
                    ? null
                    : () {
                        context.read<ProductBloc>().add(
                          DeleteProductEvent(productId),
                        );
                      },
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                child: Text(
                  state is ProductLoading ? 'Удаление...' : 'Удалить',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
