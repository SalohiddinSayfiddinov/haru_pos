import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/utils/extensions.dart';
import 'package:haru_pos/core/widgets/app_buttons.dart';
import 'package:haru_pos/core/widgets/app_snack_bar.dart';
import 'package:haru_pos/features/categories/domain/entities/categories_entity.dart';
import 'package:haru_pos/features/products/data/models/products_screen_extra.dart';
import 'package:haru_pos/features/products/presentation/bloc/product_bloc.dart';
import 'package:haru_pos/features/products/presentation/widgets/add_photo_drop_target.dart';
import 'package:haru_pos/features/products/presentation/widgets/delete_product_dialog.dart';
import 'package:haru_pos/features/products/presentation/widgets/product_form_fields.dart';
import 'package:haru_pos/features/products/presentation/widgets/product_form_header.dart';

class AddProductScreen extends StatefulWidget {
  final ProductScreenExtra extra;

  const AddProductScreen({super.key, required this.extra});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late final TextEditingController _nameUzController;
  late final TextEditingController _nameRuController;
  late final TextEditingController _priceController;
  late final TextEditingController _descUzController;
  late final TextEditingController _descRuController;
  late final TextEditingController _commentController;

  // State variables
  CategoryEntity? _selectedCategory;
  String? _selectedStatus = 'Есть в наличии';
  File? _selectedImage;
  final List<String> _statuses = ['Есть в наличии', 'Нет в наличии'];

  bool get isEdit => widget.extra.isEdit;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    if (isEdit && widget.extra.product != null) {
      _initializeEditData();
      _initializeSelectedCategory();
    }
  }

  void _initializeControllers() {
    _nameUzController = TextEditingController();
    _nameRuController = TextEditingController();
    _priceController = TextEditingController();
    _descUzController = TextEditingController();
    _descRuController = TextEditingController();
    _commentController = TextEditingController();
  }

  void _initializeEditData() {
    final product = widget.extra.product!;
    _nameUzController.text = product.nameUz;
    _nameRuController.text = product.nameRu;
    _priceController.text = product.price.toString();
    _descUzController.text = product.comment ?? '';
    _descRuController.text = product.comment ?? '';
    _commentController.text = product.comment ?? '';
    _selectedStatus = product.status == true
        ? 'Есть в наличии'
        : 'Нет в наличии';
  }

  void _initializeSelectedCategory() {
    final categories = widget.extra.categories;
    if (categories.isNotEmpty) {
      _selectedCategory = categories.firstWhere(
        (category) => category.id == widget.extra.product!.categoryId,
        orElse: () => categories.first,
      );
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _nameUzController.dispose();
    _nameRuController.dispose();
    _priceController.dispose();
    _descUzController.dispose();
    _descRuController.dispose();
    _commentController.dispose();
  }

  void _onImageSelected(File image) {
    setState(() => _selectedImage = image);
  }

  void _onCategoryChanged(CategoryEntity? category) {
    setState(() => _selectedCategory = category);
  }

  void _onStatusChanged(String? status) {
    setState(() => _selectedStatus = status);
  }

  bool _validateForm() {
    if (!_formKey.currentState!.validate()) return false;

    if (_selectedCategory == null) {
      AppSnackbar.error(context, 'Выберите категорию');
      return false;
    }

    if (!isEdit && _selectedImage == null) {
      AppSnackbar.error(context, 'Выберите изображение');
      return false;
    }

    return true;
  }

  int? _parsePrice() {
    final price = int.tryParse(_priceController.text.replaceAll(' ', ''));
    if (price == null) {
      AppSnackbar.error(context, 'Введите корректную цену');
    }
    return price;
  }

  void _onSave() {
    if (!_validateForm()) return;

    final price = _parsePrice();
    if (price == null) return;

    if (isEdit) {
      _updateProduct(price);
    } else {
      _createProduct(price);
    }
  }

  void _createProduct(int price) {
    context.read<ProductBloc>().add(
      CreateProductEvent(
        nameRu: _nameRuController.text.trim(),
        nameUz: _nameUzController.text.trim(),
        price: price,
        imagePath: _selectedImage!.path,
        categoryId: _selectedCategory!.id,
        status: _selectedStatus?.statusToBool(),
        comment: _commentController.text.trim().isNotEmpty
            ? _commentController.text.trim()
            : null,
      ),
    );
  }

  void _updateProduct(int price) {
    context.read<ProductBloc>().add(
      UpdateProductEvent(
        id: widget.extra.product!.id,
        nameRu: _nameRuController.text.trim(),
        nameUz: _nameUzController.text.trim(),
        price: price,
        imagePath: _selectedImage?.path ?? '',
        categoryId: _selectedCategory!.id,
        status: _selectedStatus!.statusToBool(),
        comment: _commentController.text.trim().isNotEmpty
            ? _commentController.text.trim()
            : null,
      ),
    );
  }

  Future<void> _onDelete() async {
    final product = widget.extra.product!;
    final result = await showDialog(
      context: context,
      builder: (context) => DeleteProductDialog(
        productId: product.id,
        productName: product.nameRu,
      ),
    );

    if (result == true && mounted) {
      context.pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: _handleProductStateChanges,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductFormHeader(
                isEdit: isEdit,
                onDelete: isEdit ? _onDelete : null,
              ),
              const SizedBox(height: 40.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AddPhotoDropTarget(
                    onImageSelected: _onImageSelected,
                    initialImage: isEdit ? widget.extra.product?.image : null,
                    selectedImage: _selectedImage,
                  ),
                  const SizedBox(width: 24.0),
                  Expanded(
                    child: Column(
                      children: [
                        ProductFormFields(
                          formKey: _formKey,
                          categories: widget.extra.categories,
                          selectedCategory: _selectedCategory,
                          onCategoryChanged: _onCategoryChanged,
                          nameUzController: _nameUzController,
                          nameRuController: _nameRuController,
                          priceController: _priceController,
                          descUzController: _descUzController,
                          descRuController: _descRuController,
                          isEdit: isEdit,
                          statuses: _statuses,
                          selectedStatus: _selectedStatus,
                          onStatusChanged: _onStatusChanged,
                          commentController: _commentController,
                        ),
                        const SizedBox(height: 30.0),
                        _buildSaveButton(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 150),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleProductStateChanges(BuildContext context, ProductState state) {
    if (state is ProductOperationSuccess) {
      AppSnackbar.success(context, state.message);
      context.pop(true);
    } else if (state is ProductError) {
      AppSnackbar.error(context, state.message);
    }
  }

  Widget _buildSaveButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          return PrimaryButton(
            height: 30.0,
            textStyle: GoogleFonts.montserrat(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            title: state is ProductLoading ? 'Сохранение...' : 'Сохранить',
            onPressed: state is ProductLoading ? null : _onSave,
          );
        },
      ),
    );
  }
}
