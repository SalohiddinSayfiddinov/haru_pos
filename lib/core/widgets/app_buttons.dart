import 'package:flutter/material.dart';
import 'package:haru_pos/core/constants/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final bool isLoading;
  final VoidCallback? onPressed;
  final double? width;
  final double height;
  final Color backgroundColor;
  final Color foregroundColor;
  final TextStyle? textStyle;

  const PrimaryButton({
    super.key,
    required this.title,
    this.isLoading = false,
    required this.onPressed,
    this.width,
    this.height = 60,
    this.backgroundColor = AppColors.primary,
    this.foregroundColor = Colors.white,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          shadowColor: backgroundColor.withValues(alpha: .2),
          elevation: 0,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? CircularProgressIndicator.adaptive()
            : Text(
                title,
                style:
                    textStyle ??
                    TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: foregroundColor,
                    ),
              ),
      ),
    );
  }
}
