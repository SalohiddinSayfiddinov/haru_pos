import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/widgets/app_buttons.dart';
import 'package:haru_pos/core/widgets/app_snack_bar.dart';
import 'package:haru_pos/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:haru_pos/features/categories/presentation/widgets/categories_grid.dart';

import '../widgets/add_category_dialog.dart';
import '../widgets/delete_category_dialog.dart';
import '../widgets/edit_category_dialog.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(LoadCategoriesEvent());
  }

  void _showAddCategoryDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) => const AddCategoryDialog(),
    );
    if (result == true && mounted) {
      context.read<CategoryBloc>().add(LoadCategoriesEvent());
    }
  }

  void _showEditCategoryDialog(category) async {
    final result = await showDialog(
      context: context,
      builder: (context) => EditCategoryDialog(category: category),
    );
    if (result == true && mounted) {
      context.read<CategoryBloc>().add(LoadCategoriesEvent());
    }
  }

  void _showDeleteConfirmationDialog(
    int categoryId,
    String categoryName,
  ) async {
    final result = await showDialog(
      context: context,
      builder: (context) => DeleteCategoryDialog(
        categoryId: categoryId,
        categoryName: categoryName,
      ),
    );
    if (result == true && mounted) {
      context.read<CategoryBloc>().add(LoadCategoriesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategoryError) {
            AppSnackbar.error(context, state.message);
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Категории',
                      style: GoogleFonts.inter(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    PrimaryButton(
                      width: 185.0,
                      height: 30.0,
                      textStyle: GoogleFonts.montserrat(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      title: 'Добавить категорию',
                      onPressed: _showAddCategoryDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoading) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is CategoriesLoaded) {
                      return CategoriesGrid(
                        categories: state.categories,
                        onAddCategory: _showAddCategoryDialog,
                        onEditCategory: _showEditCategoryDialog,
                        onDeleteCategory: _showDeleteConfirmationDialog,
                      );
                    } else if (state is CategoryError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Ошибка загрузки категорий',
                              style: GoogleFonts.inter(
                                fontSize: 16.0,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            PrimaryButton(
                              title: 'Попробовать снова',
                              onPressed: () {
                                context.read<CategoryBloc>().add(
                                  LoadCategoriesEvent(),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Center(child: Text(state.runtimeType.toString()));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
