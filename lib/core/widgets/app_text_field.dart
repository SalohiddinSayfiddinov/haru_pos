import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final TextInputType? keyboardType;
  final String? Function(String? value)? validator;
  final bool obscureText;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final bool isPhone;
  final bool isNumber;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final EdgeInsets? contentPadding;
  final bool? autofocus;

  const AppTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.keyboardType,
    this.validator,
    this.obscureText = false,
    this.maxLines = 1,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.isPhone = false,
    this.isNumber = false,
    this.textStyle,
    this.hintStyle,
    this.contentPadding,
    this.autofocus,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _isObscured = true;

  late final MaskTextInputFormatter _phoneFormatter;

  @override
  void initState() {
    super.initState();
    if (widget.isPhone) {
      widget.controller?.text = "+998 ";
    }
    _phoneFormatter = MaskTextInputFormatter(
      mask: '+998 (##) ### ## ##',
      filter: {"#": RegExp(r'\d')},
      type: MaskAutoCompletionType.lazy,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      onChanged: widget.onChanged,
      controller: widget.controller,
      enabled: widget.enabled,
      autofocus: widget.autofocus ?? false,
      keyboardType:
          widget.keyboardType ??
          (widget.isPhone ? TextInputType.phone : TextInputType.text),
      obscureText: widget.obscureText ? _isObscured : false,
      maxLines: widget.maxLines,
      validator: widget.validator,
      cursorColor: Colors.black,
      cursorWidth: 1.0,
      style:
          widget.textStyle ??
          TextStyle(color: AppColors.textPrimary, fontSize: 18),
      inputFormatters: widget.isPhone
          ? <TextInputFormatter>[_phoneFormatter]
          : widget.isNumber
          ? <TextInputFormatter>[_ThousandsSeparatorInputFormatter()]
          : null,
      decoration: InputDecoration(
        isDense: true,
        hintText: widget.hintText,
        hintStyle:
            widget.hintStyle ??
            TextStyle(
              color: isDark
                  ? AppColors.hintColor.withValues(alpha: .6)
                  : AppColors.hintColor,
              fontSize: 18,
            ),

        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border),
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon:
            widget.suffixIcon ??
            (widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _isObscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _isObscured = !_isObscured),
                  )
                : null),
        contentPadding:
            widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      ),
    );
  }
}

class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final RegExp _digitOnly = RegExp(r'\D');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(_digitOnly, '');
    final formatted = _format(digits);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _format(String digits) {
    if (digits.isEmpty) return '';
    final chars = digits.split('').reversed.toList();
    final buffer = StringBuffer();

    for (int i = 0; i < chars.length; i++) {
      buffer.write(chars[i]);
      if ((i + 1) % 3 == 0 && i != chars.length - 1) buffer.write(' ');
    }

    return buffer.toString().split('').reversed.join('');
  }
}
