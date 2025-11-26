import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review_model.g.dart';

@JsonSerializable()
class ReviewModel extends Equatable {
  final String id;
  final String bookingId;
  final String userId;
  final String? userName;
  final String? userPhotoUrl;
  final String mechanicId;
  final int rating;
  final String? comment;
  final List<String>? photoUrls;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ReviewModel({
    required this.id,
    required this.bookingId,
    required this.userId,
    this.userName,
    this.userPhotoUrl,
    required this.mechanicId,
    required this.rating,
    this.comment,
    this.photoUrls,
    required this.createdAt,
    this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);

  ReviewModel copyWith({
    String? id,
    String? bookingId,
    String? userId,
    String? userName,
    String? userPhotoUrl,
    String? mechanicId,
    int? rating,
    String? comment,
    List<String>? photoUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
      mechanicId: mechanicId ?? this.mechanicId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      photoUrls: photoUrls ?? this.photoUrls,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        bookingId,
        userId,
        userName,
        userPhotoUrl,
        mechanicId,
        rating,
        comment,
        photoUrls,
        createdAt,
        updatedAt,
      ];
}

