import 'package:haru_pos/core/entities/response_entity.dart';

class ApiResponseModel<T> extends ApiResponseEntity<T> {
  const ApiResponseModel({
    required super.total,
    required super.hasMore,
    required super.offset,
    required super.limit,
    required super.result,
  });

  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ApiResponseModel<T>(
      total: json['total'] ?? 0,
      hasMore: json['has_more'] ?? false,
      offset: json['offset'] ?? 0,
      limit: json['limit'] ?? 0,
      result: json['result'] != null
          ? List<T>.from(json['result'].map((x) => fromJsonT(x)))
          : [],
    );
  }

  ApiResponseEntity<T> toEntity() {
    return ApiResponseEntity<T>(
      total: total,
      hasMore: hasMore,
      offset: offset,
      limit: limit,
      result: result,
    );
  }
}
