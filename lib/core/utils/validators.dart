abstract class Validators {
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    final phoneRegExp = RegExp(r'^\+998\d{9}$');

    if (!phoneRegExp.hasMatch(cleaned)) {
      return 'Enter a valid phone number';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    final passwordRegExp = RegExp(r'^.{8,}$');

    if (!passwordRegExp.hasMatch(value)) {
      return "Parol eng kamida 8 ta harfdan iborat bo'lishi kerak";
    }

    return null;
  }

  static String? simpleValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Iltimos to'ldiring";
    }

    return null;
  }
}
