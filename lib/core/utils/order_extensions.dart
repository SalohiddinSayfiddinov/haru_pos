import 'package:haru_pos/features/orders/data/models/order_status.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:haru_pos/core/locale/locale_keys.g.dart';

extension OrderStatusExtension on OrderStatus {
  String toLocalizedText(String languageCode) {
    switch (this) {
      case OrderStatus.newOrder:
        return LocaleKeys.orders_status_new.tr();
      case OrderStatus.cooking:
        return LocaleKeys.orders_status_cooking.tr();
      case OrderStatus.done:
        return LocaleKeys.orders_status_done.tr();
      case OrderStatus.pickUp:
        return LocaleKeys.orders_status_pickup.tr();
    }
  }
}
