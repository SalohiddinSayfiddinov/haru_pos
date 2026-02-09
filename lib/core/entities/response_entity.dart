import 'package:equatable/equatable.dart';

class ApiResponseEntity<T> extends Equatable {
  final int total;
  final bool hasMore;
  final int offset;
  final int limit;
  final List<T> result;

  const ApiResponseEntity({
    required this.total,
    required this.hasMore,
    required this.offset,
    required this.limit,
    required this.result,
  });

  @override
  List<Object?> get props => [total, hasMore, offset, limit, result];
}
