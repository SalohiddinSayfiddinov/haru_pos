import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/locale/locale_keys.g.dart';
import 'package:haru_pos/core/utils/validators.dart';
import 'package:haru_pos/core/widgets/app_text_field.dart';
import 'package:haru_pos/features/categories/domain/entities/categories_entity.dart';
import 'package:haru_pos/features/products/presentation/widgets/category_dropdown.dart';
import 'package:haru_pos/features/products/presentation/widgets/product_status_section.dart';

class ProductFormFields extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<CategoryEntity> categories;
  final CategoryEntity? selectedCategory;
  final Function(CategoryEntity?) onCategoryChanged;
  final TextEditingController nameUzController;
  final TextEditingController nameRuController;
  final TextEditingController priceController;
  final TextEditingController descUzController;
  final TextEditingController descRuController;
  final bool isEdit;
  final List<String>? statuses;
  final String? selectedStatus;
  final Function(String?)? onStatusChanged;
  final TextEditingController? commentController;

  const ProductFormFields({
    super.key,
    required this.formKey,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.nameUzController,
    required this.nameRuController,
    required this.priceController,
    required this.descUzController,
    required this.descRuController,
    required this.isEdit,
    this.statuses,
    this.selectedStatus,
    this.onStatusChanged,
    this.commentController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          CategoryDropdown(
            categories: categories,
            selectedCategory: selectedCategory,
            onChanged: onCategoryChanged,
            validator: (value) {
              if (value == null) {
                return LocaleKeys.products_select_category_error.tr();
              }
              return null;
            },
          ),
          const SizedBox(height: 15.0),
          _buildTextField(
            controller: nameUzController,
            hintText: LocaleKeys.products_name_uz_hint.tr(),
            validator: Validators.simpleValidator,
          ),
          const SizedBox(height: 15.0),
          _buildTextField(
            controller: nameRuController,
            hintText: LocaleKeys.products_name_ru_hint.tr(),
            validator: Validators.simpleValidator,
          ),
          const SizedBox(height: 15.0),
          _buildTextField(
            controller: priceController,
            hintText: LocaleKeys.products_price_hint.tr(),
            keyboardType: TextInputType.number,
            isNumber: true,
            validator: Validators.simpleValidator,
          ),
          const SizedBox(height: 15.0),
          _buildTextField(
            controller: descUzController,
            hintText: LocaleKeys.products_description_uz_hint.tr(),
            maxLines: 4,
          ),
          const SizedBox(height: 15.0),
          _buildTextField(
            controller: descRuController,
            hintText: LocaleKeys.products_description_ru_hint.tr(),
            maxLines: 4,
          ),
          if (isEdit &&
              statuses != null &&
              onStatusChanged != null &&
              commentController != null) ...[
            const SizedBox(height: 15.0),
            ProductStatusSection(
              statuses: statuses!,
              selectedStatus: selectedStatus,
              onStatusChanged: onStatusChanged!,
              commentController: commentController!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool isNumber = false,
    String? Function(String?)? validator,
  }) {
    return AppTextField(
      controller: controller,
      hintText: hintText,
      maxLines: maxLines,
      keyboardType: keyboardType,
      isNumber: isNumber,
      hintStyle: GoogleFonts.montserrat(
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF606060),
      ),
      textStyle: GoogleFonts.montserrat(
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      validator: validator,
    );
  }
}
