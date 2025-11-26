// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'mechanic_model.dart';

MechanicModel _$MechanicModelFromJson(Map<String, dynamic> json) => MechanicModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['totalReviews'] as int?) ?? 0,
      distance: (json['distance'] as num?)?.toDouble(),
      services: (json['services'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      priceRange: json['priceRange'] as String?,
      verified: (json['verified'] as bool?) ?? false,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      workshopName: json['workshopName'] as String?,
      workshopAddress: json['workshopAddress'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isAvailable: (json['isAvailable'] as bool?) ?? true,
      estimatedArrivalMinutes: (json['estimatedArrivalMinutes'] as int?),
      specialization: json['specialization'] as String?,
    );

Map<String, dynamic> _$MechanicModelToJson(MechanicModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'rating': instance.rating,
      'totalReviews': instance.totalReviews,
      'distance': instance.distance,
      'services': instance.services,
      'priceRange': instance.priceRange,
      'verified': instance.verified,
      'profilePictureUrl': instance.profilePictureUrl,
      'workshopName': instance.workshopName,
      'workshopAddress': instance.workshopAddress,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'isAvailable': instance.isAvailable,
      'estimatedArrivalMinutes': instance.estimatedArrivalMinutes,
      'specialization': instance.specialization,
    };




