import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/widgets/app_buttons.dart';
import 'package:haru_pos/features/categories/domain/entities/categories_entity.dart';
import 'package:haru_pos/features/categories/presentation/widgets/category_card.dart';

class CategoriesGrid extends StatelessWidget {
  final List<CategoryEntity> categories;
  final VoidCallback onAddCategory;
  final Function(CategoryEntity) onEditCategory;
  final Function(int, String) onDeleteCategory;

  const CategoriesGrid({
    super.key,
    required this.categories,
    required this.onAddCategory,
    required this.onEditCategory,
    required this.onDeleteCategory,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Категории не найдены',
              style: GoogleFonts.inter(fontSize: 16.0),
            ),
            const SizedBox(height: 10.0),
            PrimaryButton(
              title: 'Добавить категорию',
              onPressed: onAddCategory,
            ),
          ],
        ),
      );
    }

    return Wrap(
      spacing: 15.0,
      runSpacing: 15.0,
      children: categories.map((category) {
        return CategoryCard(
          category: category,
          onEdit: () => onEditCategory(category),
          onDelete: () => onDeleteCategory(category.id, category.nameRu),
        );
      }).toList(),
    );
  }
}
