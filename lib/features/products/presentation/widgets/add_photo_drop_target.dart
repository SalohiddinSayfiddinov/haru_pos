import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AddPhotoDropTarget extends StatefulWidget {
  final Function(XFile)? onImageSelected;
  final String? initialImage;
  final XFile? selectedImage;

  final double? width;
  final double? height;

  const AddPhotoDropTarget({
    super.key,
    this.onImageSelected,
    this.initialImage,
    this.selectedImage,
    this.width,
    this.height,
  });

  @override
  State<AddPhotoDropTarget> createState() => _AddPhotoDropTargetState();
}

class _AddPhotoDropTargetState extends State<AddPhotoDropTarget> {
  bool isDragging = false;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null && widget.onImageSelected != null) {
      widget.onImageSelected!(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasImage =
        widget.selectedImage != null ||
        (widget.initialImage != null && widget.initialImage!.isNotEmpty);

    return DropTarget(
      onDragEntered: (details) {
        setState(() => isDragging = true);
      },
      onDragExited: (details) {
        setState(() => isDragging = false);
      },
      onDragDone: (details) async {
        setState(() => isDragging = false);

        // Handle dropped files
        if (details.files.isNotEmpty) {
          final file = details.files.first;

          // Check if it's an image file
          final extension = file.path.toLowerCase();
          if (extension.endsWith('.jpg') ||
              extension.endsWith('.jpeg') ||
              extension.endsWith('.png') ||
              extension.endsWith('.gif') ||
              extension.endsWith('.webp')) {
            if (widget.onImageSelected != null) {
              widget.onImageSelected!(file);
            }
          } else {
            // Show error for non-image files
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Пожалуйста, выберите файл изображения'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        }
      },
      child: GestureDetector(
        onTap: !hasImage ? _pickImage : null,
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
            dashPattern: [5, 5],
            strokeWidth: 3.0,
            borderPadding: const EdgeInsets.all(1.0),
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
            radius: const Radius.circular(5.0),
          ),
          child: Container(
            height: 250,
            width: 240,
            decoration: BoxDecoration(
              color: isDragging
                  ? Colors.blue.withValues(alpha: .05)
                  : const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: hasImage ? _buildImagePreview() : _buildPlaceholder(),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: widget.selectedImage != null
                ? (kIsWeb
                      ? Image.network(
                          widget.selectedImage!.path,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(widget.selectedImage!.path),
                          fit: BoxFit.cover,
                        ))
                : widget.initialImage != null && widget.initialImage!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: widget.initialImage!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.broken_image, size: 50)),
                  )
                : const SizedBox(),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: _pickImage,
              icon: const Icon(Icons.edit, size: 18),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
              color: Colors.black87,
              tooltip: 'Изменить изображение',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add,
          color: isDragging ? Colors.blue : Colors.black,
          size: 40,
        ),
        const SizedBox(height: 5.0),
        Text(
          isDragging ? 'Отпустите файл' : 'Добавить фото',
          style: GoogleFonts.montserrat(
            fontSize: 15.0,
            color: isDragging ? Colors.blue : const Color(0xFF0D0D0D),
            fontWeight: isDragging ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        if (!isDragging) ...[
          const SizedBox(height: 10),
          Text(
            'или перетащите файл сюда',
            style: GoogleFonts.montserrat(fontSize: 12.0, color: Colors.grey),
          ),
        ],
      ],
    );
  }
}
