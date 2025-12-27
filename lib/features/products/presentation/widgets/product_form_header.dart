import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/widgets/app_buttons.dart';
import 'package:haru_pos/features/products/presentation/bloc/product_bloc.dart';

class ProductFormHeader extends StatelessWidget {
  final bool isEdit;
  final VoidCallback? onDelete;

  const ProductFormHeader({super.key, required this.isEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        Text(
          isEdit ? 'Изменить продукт' : 'Добавить продукт',
          style: GoogleFonts.inter(fontSize: 25.0, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        if (isEdit && onDelete != null)
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              return PrimaryButton(
                height: 30.0,
                textStyle: GoogleFonts.montserrat(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                title: state is ProductLoading ? 'Удаление...' : 'Удалить',
                onPressed: state is ProductLoading ? null : onDelete,
              );
            },
          ),
        const SizedBox(width: 150),
      ],
    );
  }
}
