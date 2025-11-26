// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'booking_model.dart';

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      mechanicId: json['mechanicId'] as String,
      mechanicName: json['mechanicName'] as String?,
      mechanicPhone: json['mechanicPhone'] as String?,
      mechanicPhotoUrl: json['mechanicPhotoUrl'] as String?,
      serviceType: $enumDecode(_$ServiceTypeEnumMap, json['serviceType']),
      vehicleModel: json['vehicleModel'] as String?,
      specialInstructions: json['specialInstructions'] as String?,
      cost: (json['cost'] as num?)?.toDouble(),
      status: $enumDecode(_$BookingStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      scheduledTime: json['scheduledTime'] == null
          ? null
          : DateTime.parse(json['scheduledTime'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      userLatitude: (json['userLatitude'] as num?)?.toDouble(),
      userLongitude: (json['userLongitude'] as num?)?.toDouble(),
      userAddress: json['userAddress'] as String?,
      diagnosticAnswers: json['diagnosticAnswers'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'mechanicId': instance.mechanicId,
      'mechanicName': instance.mechanicName,
      'mechanicPhone': instance.mechanicPhone,
      'mechanicPhotoUrl': instance.mechanicPhotoUrl,
      'serviceType': _$ServiceTypeEnumMap[instance.serviceType]!,
      'vehicleModel': instance.vehicleModel,
      'specialInstructions': instance.specialInstructions,
      'cost': instance.cost,
      'status': _$BookingStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'scheduledTime': instance.scheduledTime?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'userLatitude': instance.userLatitude,
      'userLongitude': instance.userLongitude,
      'userAddress': instance.userAddress,
      'diagnosticAnswers': instance.diagnosticAnswers,
    };

const _$ServiceTypeEnumMap = {
  ServiceType.minor: 'minor',
  ServiceType.severe: 'severe',
  ServiceType.unsure: 'unsure',
};

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 'pending',
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.inProgress: 'inProgress',
  BookingStatus.completed: 'completed',
  BookingStatus.cancelled: 'cancelled',
};

T $enumDecode<T>(
  Map<T, Object> enumValues,
  Object? source, {
  T? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue as T, unknownValue as Object); // FIXED: Changed T to Object
    },
  ).key;
}