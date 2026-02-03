class RejectOrderRequest {
  final String password;
  final String voidFault;
  final String comment;
  final List<RejectOrderItem> items;

  RejectOrderRequest({
    required this.password,
    required this.voidFault,
    required this.comment,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
    'password': password,
    'void_fault': voidFault,
    'comment': comment,
    'items': items.map((e) => e.toJson()).toList(),
  };
}

class RejectOrderItem {
  final int productId;
  final int amount;

  RejectOrderItem({required this.productId, required this.amount});

  Map<String, dynamic> toJson() => {'product_id': productId, 'amount': amount};
}
