import 'package:easy_localization/easy_localization.dart';
import 'package:haru_pos/core/locale/locale_keys.g.dart';
import 'package:haru_pos/core/utils/extensions.dart';

extension FancyDate on DateTime {
  String toFancy() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(year, month, day);

    final difference = date.difference(today).inDays;

    if (difference == 0) {
      return LocaleKeys.date_today_at.tr(args: [formattedTime]);
    }
    if (difference == -1) {
      return LocaleKeys.date_yesterday_at.tr(args: [formattedTime]);
    }
    if (difference == 1) {
      return LocaleKeys.date_tomorrow_at.tr(args: [formattedTime]);
    }

    if (difference > 1 && difference <= 7) {
      return "${DateFormat('EEEE').format(this).capitalize()} ${LocaleKeys.date_at.tr(args: [formattedTime])}";
    }

    return "$formatted ${LocaleKeys.date_at.tr(args: [formattedTime])}";
  }

  String get formatted {
    final d = day.toString().padLeft(2, '0');
    final m = month.toString().padLeft(2, '0');
    return "$d-$m-$year";
  }

  String get formattedTime {
    return "$hour:${minute.toString().padLeft(2, '0')}";
  }

  String get formattedYearFirst {
    final d = day.toString().padLeft(2, '0');
    final m = month.toString().padLeft(2, '0');
    return "$year-$m-$d";
  }
}

extension WeekdayShort on int {
  String get localizedShortWeekday {
    // 1 = Monday, 7 = Sunday
    // DateFormat.E() expects a date.
    // We can create a dummy date for the weekday.
    // Jan 5 1970 was a Monday.
    final date = DateTime(1970, 1, 4 + this);
    return DateFormat.E().format(date);
  }
}
