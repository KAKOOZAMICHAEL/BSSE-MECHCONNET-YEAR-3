import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String username;
  final String phone;
  final String? email;
  final String? nin;
  final String? permitNumber;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? profilePictureUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.username,
    required this.phone,
    this.email,
    this.nin,
    this.permitNumber,
    this.dateOfBirth,
    this.gender,
    this.profilePictureUrl,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? username,
    String? phone,
    String? email,
    String? nin,
    String? permitNumber,
    DateTime? dateOfBirth,
    String? gender,
    String? profilePictureUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      nin: nin ?? this.nin,
      permitNumber: permitNumber ?? this.permitNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        username,
        phone,
        email,
        nin,
        permitNumber,
        dateOfBirth,
        gender,
        profilePictureUrl,
        createdAt,
        updatedAt,
      ];
}

