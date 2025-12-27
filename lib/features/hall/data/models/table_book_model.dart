class TableBookModel {
  final int id;
  final String phoneNumber;
  final String fullName;
  final DateTime dateAndTime;
  final int tableId;

  TableBookModel({
    required this.id,
    required this.phoneNumber,
    required this.fullName,
    required this.dateAndTime,
    required this.tableId,
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'phone_number': phoneNumber,
        'full_name': fullName,
        'date_and_time': dateAndTime.toIso8601String(),
        'table_id': tableId,
      };
}
