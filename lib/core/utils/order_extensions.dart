import 'package:haru_pos/features/orders/data/models/order_status.dart';

extension OrderStatusExtension on OrderStatus {
  String toLocalizedText(String languageCode) {
    switch (this) {
      case OrderStatus.newOrder:
        return languageCode == 'uz' ? 'Yangi' : 'Новый';
      case OrderStatus.cooking:
        return languageCode == 'uz' ? 'Tayyorlanmoqda' : 'Готовится';
      case OrderStatus.done:
        return languageCode == 'uz' ? 'Tayyor' : 'Готово';
      case OrderStatus.pickUp:
        return languageCode == 'uz' ? 'Olib ketildi' : 'Подано';
    }
  }
}
