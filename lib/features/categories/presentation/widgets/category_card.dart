import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/locale/locale_keys.g.dart';
import 'package:haru_pos/features/categories/domain/entities/categories_entity.dart';

class CategoryCard extends StatelessWidget {
  final CategoryEntity category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 170,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: category.image,
            fit: BoxFit.cover,
            width: 140,
            height: 170,
            errorWidget: (context, url, error) =>
                const Center(child: Icon(Icons.broken_image)),
          ),
          Container(
            width: 140,
            height: 170,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.black.withValues(alpha: .09),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PopupMenuButton<String>(
                color: Colors.white,
                icon: const Icon(Icons.more_vert, color: Colors.white),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text(LocaleKeys.categories_popup_edit.tr()),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(LocaleKeys.categories_popup_delete.tr()),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 13.0, bottom: 9.0),
                  child: Text(
                    context.locale.languageCode == 'ru'
                        ? category.nameRu
                        : category.nameUz,
                    style: GoogleFonts.inter(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
