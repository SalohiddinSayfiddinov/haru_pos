import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/di/injection.dart';
import 'package:haru_pos/core/widgets/app_buttons.dart';
import 'package:haru_pos/core/widgets/app_snack_bar.dart';
import 'package:haru_pos/core/widgets/app_text_field.dart';
import 'package:haru_pos/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({super.key});

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final TextEditingController ruNameController = TextEditingController();
  final TextEditingController uzNameController = TextEditingController();
  File? selectedImage;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Добавить категорию',
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
                const SizedBox(height: 16.0),
                if (selectedImage != null) ...[
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.file(selectedImage!, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 10.0),
                ],
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _pickImage,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF0069F4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 8.0,
                      ),
                    ),
                    icon: Icon(
                      selectedImage == null ? Icons.upload_file : Icons.edit,
                      size: 18,
                    ),
                    label: Text(
                      selectedImage == null
                          ? 'Загрузить изображение'
                          : 'Изменить изображение',
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

                        if (selectedImage == null) {
                          AppSnackbar.error(context, 'Выберите изображение');
                          return;
                        }

                        context.read<CategoryBloc>().add(
                          CreateCategoryEvent(
                            nameRu: ruNameController.text.trim(),
                            nameUz: uzNameController.text.trim(),
                            imagePath: selectedImage!.path,
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
