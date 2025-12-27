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
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      username: json['username'] ?? '',
      role: json['role'] ?? '',
      isSuperuser: json['is_superuser'] ?? false,
      image: json['image'] != null ? "${Api.baseUrl}${json['image']}" : '',
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
    );
  }
}
