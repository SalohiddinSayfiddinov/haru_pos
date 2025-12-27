import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:haru_pos/features/categories/presentation/bloc/categories_bloc.dart';

class CategoryFilter extends StatelessWidget {
  final int? selectedCategoryId;
  final Function(int?) onCategorySelected;

  const CategoryFilter({
    super.key,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoriesLoaded) {
          final categories = state.categories;
          return SizedBox(
            height: 40.0,
            child: ListView.separated(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: categories.length + 1,
              separatorBuilder: (context, index) => const SizedBox(width: 15.0),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return CategoryFilterItem(
                    title: 'Все',
                    isSelected: selectedCategoryId == null,
                    onTap: () => onCategorySelected(null),
                  );
                }
                final category = categories[index - 1];
                return CategoryFilterItem(
                  title: category.nameRu,
                  isSelected: selectedCategoryId == category.id,
                  onTap: () => onCategorySelected(category.id),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class CategoryFilterItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryFilterItem({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.0),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFFAEAEAE),
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 41.0),
        alignment: Alignment.center,
        child: Text(
          title,
          style: GoogleFonts.montserrat(
            height: .8,
            color: isSelected ? Colors.white : const Color(0xFF404040),
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
