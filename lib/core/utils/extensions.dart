extension FormatExtension on num {
  String formatCurrency() {
    final amountStr = toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]} ',
    );
    return '$amountStr сум';
  }
  String formatCurrencyUz() {
    final amountStr = toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]} ',
    );
    return '$amountStr so\'m';
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
      return 'Есть в наличии';
    } else {
      return 'Нет в наличии';
    }
  }
}

extension RoleToString on String {
  String roleToString() {
    switch (this) {
      case 'ADMIN':
        return 'Админ';
      case 'CASHIER':
        return 'Кассир';
      case 'WAITER':
        return 'Официант';
      default:
        return 'Админ';
    }
  }
}

extension StringToRole on String {
  String toRole() {
    switch (this) {
      case 'Админ':
        return 'ADMIN';
      case 'Кассир':
        return 'CASHIER';
      case 'Официант':
        return 'WAITER';
      default:
        return 'ADMIN';
    }
  }
}

extension TypeToString on String {
  String typeToUz() {
    switch (this) {
      case 'dine_in':
        return 'Restoranda';
      case 'takeaway':
        return 'Olib ketish';
      case 'delivery':
        return 'Yetkazib berish';
      default:
        return 'Nomalum';
    }
  }

  String typeToRu() {
    switch (this) {
      case 'dine_in':
        return 'В ресторане';
      case 'takeaway':
        return 'С собой';
      case 'delivery':
        return 'Доставка';
      default:
        return 'Не опознано';
    }
  }
}
