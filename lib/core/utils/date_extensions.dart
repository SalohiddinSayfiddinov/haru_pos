extension FancyDate on DateTime {
  String toRuFancy() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(year, month, day);

    final difference = date.difference(today).inDays;

    const weekdays = [
      "Понедельник",
      "Вторник",
      "Среда",
      "Четверг",
      "Пятница",
      "Суббота",
      "Воскресенье",
    ];

    if (difference == 0) return "Сегодня в $formattedTime";
    if (difference == -1) return "Вчера в $formattedTime";
    if (difference == 1) return "Завтра в $formattedTime";

    if (difference > 1 && difference <= 7) {
      return "${weekdays[weekday - 1]} в $formattedTime";
    }

    return "$formatted в $formattedTime";
  }

  String toUzFancy() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(year, month, day);

    final difference = date.difference(today).inDays;

    const weekdays = [
      "Dushanba",
      "Seshanba",
      "Chorshanba",
      "Payshanba",
      "Juma",
      "Shanba",
      "Yakshanba",
    ];

    if (difference == 0) return "Bugun в $formattedTime";
    if (difference == -1) return "Kecha в $formattedTime";
    if (difference == 1) return "Ertaga в $formattedTime";

    if (difference > 1 && difference <= 7) {
      return "${weekdays[weekday - 1]} в $formattedTime";
    }

    return formatted;
  }

  String get formatted {
    final d = day.toString().padLeft(2, '0');
    final m = month.toString().padLeft(2, '0');
    return "$d-$m-$year";
  }

  String get formattedTime {
    return "$hour:${minute.toString().padLeft(2, '0')}";
  }
}

extension WeekdayShort on int {
  String get ruShortWeekday {
    const ru = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"];
    return ru[this];
  }

  String get uzShortWeekday {
    const uz = ["Du", "Se", "Ch", "Pa", "Ju", "Sh", "Ya"];
    return uz[this];
  }
}
