enum OrderStatus {
  newOrder,
  cooking,
  done,
  pickUp;

  static OrderStatus fromString(String status) {
    switch (status) {
      case 'new':
        return OrderStatus.newOrder;
      case 'cooking':
        return OrderStatus.cooking;
      case 'done':
        return OrderStatus.done;
      case 'pick_up':
        return OrderStatus.pickUp;
      default:
        return OrderStatus.newOrder;
    }
  }

  String get apiKey {
    switch (this) {
      case OrderStatus.newOrder:
        return 'new';
      case OrderStatus.cooking:
        return 'cooking';
      case OrderStatus.done:
        return 'done';
      case OrderStatus.pickUp:
        return 'pick_up';
    }
  }
}
