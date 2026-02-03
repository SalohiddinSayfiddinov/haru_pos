import 'package:haru_pos/core/constants/api.dart';

import '../../domain/entities/employee_entity.dart';

class EmployeeModel extends EmployeeEntity {
  const EmployeeModel({
    required super.id,
    required super.fullName,
    required super.username,
    required super.role,
    required super.isSuperuser,
    required super.image,
    required super.limit,
    required super.limits,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      username: json['username'] ?? '',
      role: json['role'] ?? '',
      isSuperuser: json['is_superuser'] ?? false,
      image: json['image'] != null ? "${Api.baseUrl}${json['image']}" : '',
      limit: json['limit'] ?? 0,
      limits: json['limits'] != null
          ? List<LimitModel>.from(
              json['limits'].map((x) => LimitModel.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'username': username,
      'role': role,
      'is_superuser': isSuperuser,
      'image': image,
      'limit': limit,
      'limits': limits,
    };
  }

  Map<String, dynamic> toCreateRequest() {
    return {'full_name': fullName, 'username': username, 'role': role};
  }

  EmployeeEntity toEntity() {
    return EmployeeEntity(
      id: id,
      fullName: fullName,
      username: username,
      role: role,
      isSuperuser: isSuperuser,
      image: image,
      limit: limit,
      limits: limits,
    );
  }
}

class LimitModel extends LimitEntity {
  const LimitModel({
    required super.id,
    required super.money,
    required super.createdAt,
    required super.updatedAt,
  });

  factory LimitModel.fromJson(Map<String, dynamic> json) {
    return LimitModel(
      id: json['id'] ?? 0,
      money: json['money'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'money': money,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  LimitEntity toEntity() {
    return LimitEntity(
      id: id,
      money: money,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
