import '../../domain/entities/table_entity.dart';

class TableBookModel extends TableBookEntity {
  const TableBookModel({
    required super.id,
    required super.phoneNumber,
    required super.fullName,
    required super.dateAndTime,
    required super.tableId,
  });

  factory TableBookModel.fromJson(Map<String, dynamic> json) {
    return TableBookModel(
      id: json['id'] ?? 0,
      phoneNumber: json['phone_number'] ?? '',
      fullName: json['full_name'] ?? '',
      dateAndTime: DateTime.parse(
        json['date_and_time'] ?? DateTime.now().toString(),
      ),
      tableId: json['table_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone_number': phoneNumber,
      'full_name': fullName,
      'date_and_time': dateAndTime.toIso8601String(),
      'table_id': tableId,
    };
  }

  TableBookEntity toEntity() {
    return TableBookEntity(
      id: id,
      phoneNumber: phoneNumber,
      fullName: fullName,
      dateAndTime: dateAndTime,
      tableId: tableId,
    );
  }
}

class TableModel extends TableEntity {
  const TableModel({
    required super.id,
    required super.tableNumber,
    required super.status,
    required super.createdAt,
    super.tableBooks,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    final tableBooks =
        (json['table_books'] as List?)
            ?.map((book) => TableBookModel.fromJson(book))
            .toList() ??
        [];

    return TableModel(
      id: json['id'] ?? 0,
      tableNumber: json['table_number'] ?? 0,
      status: json['status'] ?? false,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toString(),
      ),
      tableBooks: tableBooks,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'table_number': tableNumber,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'table_books': tableBooks
          .map((book) => (book as TableBookModel).toJson())
          .toList(),
    };
  }

  Map<String, dynamic> toCreateRequest() {
    return {'table_number': tableNumber};
  }

  Map<String, dynamic> toUpdateRequest() {
    return {'table_number': tableNumber, 'status': status};
  }

  TableEntity toEntity() {
    return TableEntity(
      id: id,
      tableNumber: tableNumber,
      status: status,
      createdAt: createdAt,
      tableBooks: tableBooks,
    );
  }
}
