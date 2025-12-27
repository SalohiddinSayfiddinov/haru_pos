import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AppSnackbar {
  static void success(BuildContext context, String message) {
    showTopSnackBar(
      displayDuration: Duration(milliseconds: 100),
      Overlay.of(context),
      Align(
        alignment: .topRight,
        child: SizedBox(
          width: 400,
          child: CustomSnackBar.success(message: message),
        ),
      ),
    );
  }

  static void error(BuildContext context, String message) {
    showTopSnackBar(
      displayDuration: Duration(milliseconds: 100),
      Overlay.of(context),
      Align(
        alignment: .topRight,
        child: SizedBox(
          width: 400,
          child: CustomSnackBar.error(message: message),
        ),
      ),
    );
  }

  static void info(BuildContext context, String message) {
    showTopSnackBar(
      displayDuration: Duration(milliseconds: 100),
      Overlay.of(context),
      Align(
        alignment: .topRight,
        child: SizedBox(
          width: 400,
          child: CustomSnackBar.info(message: message),
        ),
      ),
    );
  }
}
