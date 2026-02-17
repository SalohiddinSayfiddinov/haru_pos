import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:haru_pos/core/locale/locale_keys.g.dart';

extension CurrencyFormat on num {
  String formatCurrency([BuildContext? context]) {
    final NumberFormat format;
    if (context != null) {
      final locale = context.locale.languageCode;

      format = NumberFormat.currency(
        locale: locale == 'ru' ? 'ru_RU' : 'uz_UZ',
        symbol: locale == 'ru' ? 'сум' : "so'm",
        decimalDigits: 0,
      );
    } else {
      format = NumberFormat.currency(
        locale: 'ru_RU',
        symbol: 'сум',
        decimalDigits: 0,
      );
    }
    return format.format(this);
  }
}

extension StatusToBoolExtension on String {
  bool statusToBool() {
    return this == 'Есть в наличии';
  }
}

extension StatusToStringExtension on bool {
  String statusToString() {
    if (this) {
      return LocaleKeys.common_status_in_stock.tr();
    } else {
      return LocaleKeys.common_status_out_of_stock.tr();
    }
  }
}

extension RoleToString on String {
  String roleToString() {
    switch (this) {
      case 'ADMIN':
        return LocaleKeys.common_roles_admin.tr();
      case 'CASHIER':
        return LocaleKeys.common_roles_cashier.tr();
      case 'WAITER':
        return LocaleKeys.common_roles_waiter.tr();
      default:
        return LocaleKeys.common_roles_admin.tr();
    }
  }
}

extension StringToRole on String {
  String toRole() {
    if (this == LocaleKeys.common_roles_admin.tr()) return 'ADMIN';
    if (this == LocaleKeys.common_roles_cashier.tr()) return 'CASHIER';
    if (this == LocaleKeys.common_roles_waiter.tr()) return 'WAITER';
    return 'ADMIN';
  }
}

extension TypeToString on String {
  String typeToLocalized() {
    switch (this) {
      case 'dine_in':
        return LocaleKeys.common_order_types_dine_in.tr();
      case 'takeaway':
        return LocaleKeys.common_order_types_takeaway.tr();
      case 'delivery':
        return LocaleKeys.common_order_types_delivery.tr();
      default:
        return LocaleKeys.common_order_types_unknown.tr();
    }
  }

  // Keeping legacy methods for compatibility but redirecting to localized version
  String typeToUz() => typeToLocalized();
  String typeToRu() => typeToLocalized();
}

extension FaultToString on String {
  String faultToLocalized() {
    switch (this) {
      case 'customer':
        return LocaleKeys.common_faults_customer.tr();
      case 'kitchen':
        return LocaleKeys.common_faults_kitchen.tr();
      case 'staff':
        return LocaleKeys.common_faults_staff.tr();
      default:
        return LocaleKeys.common_faults_unknown.tr();
    }
  }

  String faultToRu() => faultToLocalized();
  String faultToUz() => faultToLocalized();
}

extension CapitalizeExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
