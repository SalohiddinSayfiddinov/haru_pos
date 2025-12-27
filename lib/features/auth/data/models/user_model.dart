import 'package:haru_pos/core/constants/api.dart';
import 'package:haru_pos/features/auth/domain/entities/auth_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.username,
    required super.fullName,
    required super.role,
    super.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      fullName: json['full_name'] ?? '',
      role: json['role'] ?? '',
      image: json['image'] != null ? "${Api.baseUrl}${json['image']}" : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'role': role,
      'image': image,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      username: username,
      fullName: fullName,
      role: role,
      image: image,
    );
  }
}
