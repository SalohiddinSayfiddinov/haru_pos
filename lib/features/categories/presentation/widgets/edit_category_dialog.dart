import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/di/injection.dart';
import 'package:haru_pos/core/widgets/app_buttons.dart';
import 'package:haru_pos/core/widgets/app_snack_bar.dart';
import 'package:haru_pos/core/widgets/app_text_field.dart';
import 'package:haru_pos/features/categories/domain/entities/categories_entity.dart';
import 'package:haru_pos/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditCategoryDialog extends StatefulWidget {
  final CategoryEntity category;

  const EditCategoryDialog({super.key, required this.category});

  @override
  State<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  late TextEditingController ruNameController;
  late TextEditingController uzNameController;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    ruNameController = TextEditingController(text: widget.category.nameRu);
    uzNameController = TextEditingController(text: widget.category.nameUz);
  }

  @override
  void dispose() {
    ruNameController.dispose();
    uzNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CategoryBloc>(),
      child: AlertDialog(
        backgroundColor: const Color(0xFFF9FAFB),
        content: Material(
          color: const Color(0xFFF9FAFB),
          child: SizedBox(
            width: 750,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Изменить категорию',
                      style: GoogleFonts.inter(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.clear),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                AppTextField(
                  controller: ruNameController,
                  hintText: 'Наименование на русском',
                  contentPadding: const EdgeInsets.all(16.0),
                  hintStyle: GoogleFonts.inter(
                    fontSize: 13.0,
                    color: const Color(0xFF7A7A7A),
                  ),
                  textStyle: GoogleFonts.inter(fontSize: 13.0),
                ),
                const SizedBox(height: 8.0),
                AppTextField(
                  controller: uzNameController,
                  hintText: 'Наименование на узбекском',
                  contentPadding: const EdgeInsets.all(16.0),
                  hintStyle: GoogleFonts.inter(
                    fontSize: 13.0,
                    color: const Color(0xFF7A7A7A),
                  ),
                  textStyle: GoogleFonts.inter(fontSize: 13.0),
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    if (widget.category.image.isNotEmpty) ...[
                      Column(
                        children: [
                          Text(
                            'Текущее изображение',
                            style: GoogleFonts.inter(fontSize: 12.0),
                          ),
                          const SizedBox(height: 5.0),
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: CachedNetworkImage(
                              imageUrl: widget.category.image,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  const Center(child: Icon(Icons.broken_image)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20.0),
                    ],
                    if (selectedImage != null) ...[
                      Column(
                        children: [
                          Text(
                            'Новое изображение',
                            style: GoogleFonts.inter(fontSize: 12.0),
                          ),
                          const SizedBox(height: 5.0),
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: _pickImage,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF0069F4),
                    ),
                    child: Text(
                      selectedImage == null
                          ? 'Изменить изображение'
                          : 'Выбрать другое изображение',
                      style: GoogleFonts.inter(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          BlocConsumer<CategoryBloc, CategoryState>(
            listener: (context, state) {
              if (state is CategoryOperationSuccess) {
                Navigator.pop(context, true);
              } else if (state is CategoryError) {
                AppSnackbar.error(context, state.message);
              }
            },
            builder: (context, state) {
              return PrimaryButton(
                height: 30.0,
                title: state is CategoryLoading ? 'Сохранение...' : 'Сохранить',
                textStyle: GoogleFonts.inter(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                onPressed: state is CategoryLoading
                    ? null
                    : () {
                        if (ruNameController.text.trim().isEmpty ||
                            uzNameController.text.trim().isEmpty) {
                          AppSnackbar.error(context, 'Заполните все поля');
                          return;
                        }

                        context.read<CategoryBloc>().add(
                          UpdateCategoryEvent(
                            id: widget.category.id,
                            nameRu: ruNameController.text.trim(),
                            nameUz: uzNameController.text.trim(),
                            imagePath: selectedImage?.path ?? '',
                          ),
                        );
                      },
              );
            },
          ),
        ],
      ),
    );
  }
}
