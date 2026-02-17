import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:haru_pos/core/di/injection.dart';
import 'package:haru_pos/core/locale/locale_keys.g.dart';
import 'package:haru_pos/core/widgets/app_snack_bar.dart';
import 'package:haru_pos/features/categories/presentation/bloc/categories_bloc.dart';

class DeleteCategoryDialog extends StatelessWidget {
  final int categoryId;
  final String categoryName;

  const DeleteCategoryDialog({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CategoryBloc>(),
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: Text(LocaleKeys.categories_delete_dialog_title.tr()),
        content: Text(
          LocaleKeys.categories_delete_confirmation.tr(args: [categoryName]),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            style: TextButton.styleFrom(foregroundColor: Colors.blue),
            child: Text(LocaleKeys.categories_cancel.tr()),
          ),
          BlocConsumer<CategoryBloc, CategoryState>(
            listener: (context, state) {
              if (state is CategoryOperationSuccess) {
                Navigator.pop(context, true);
              } else if (state is CategoryError) {
                AppSnackbar.error(context, state.message);
              }
            },
            builder: (context, state) {
              return TextButton(
                onPressed: state is CategoryLoading
                    ? null
                    : () {
                        context.read<CategoryBloc>().add(
                          DeleteCategoryEvent(categoryId),
                        );
                      },
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                child: Text(
                  state is CategoryLoading
                      ? LocaleKeys.categories_deleting.tr()
                      : LocaleKeys.categories_delete.tr(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
