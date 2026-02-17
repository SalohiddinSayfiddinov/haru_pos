import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:haru_pos/core/locale/locale_keys.g.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/widgets/app_buttons.dart';
import 'package:haru_pos/core/widgets/app_text_field.dart';

class PasswordConfirmDialog extends StatefulWidget {
  const PasswordConfirmDialog({super.key});

  @override
  State<PasswordConfirmDialog> createState() => _PasswordConfirmDialogState();
}

class _PasswordConfirmDialogState extends State<PasswordConfirmDialog> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    Navigator.of(context).pop(_passwordController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        LocaleKeys.products_password_title.tr(),
        style: GoogleFonts.inter(fontSize: 18.0, fontWeight: FontWeight.w600),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.products_password_confirmation_message.tr(),
            style: GoogleFonts.inter(
              fontSize: 14.0,
              color: const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 15),
          AppTextField(
            controller: _passwordController,
            hintText: LocaleKeys.products_password_hint.tr(),
            obscureText: true,
            hintStyle: GoogleFonts.inter(
              fontSize: 16,

              color: Color(0xFFA5AAB5),
            ),
            textStyle: GoogleFonts.inter(fontSize: 16),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  LocaleKeys.products_cancel.tr(),
                  style: GoogleFonts.inter(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              PrimaryButton(
                height: 40,
                title: LocaleKeys.products_confirm.tr(),
                textStyle: GoogleFonts.inter(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                onPressed: _onConfirm,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
