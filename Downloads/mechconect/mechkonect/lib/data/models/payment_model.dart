import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_model.g.dart';

enum PaymentStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed,
  @JsonValue('refunded')
  refunded,
}

enum TransactionType {
  @JsonValue('credit')
  credit, // Add funds to wallet
  @JsonValue('debit')
  debit, // Payment for service
  @JsonValue('refund')
  refund,
}

@JsonSerializable()
class PaymentModel extends Equatable {
  final String id;
  final String? bookingId;
  final String userId;
  final double amount;
  final TransactionType type;
  final PaymentStatus status;
  final String? transactionId;
  final String? description;
  final DateTime createdAt;
  final String? paymentMethod;

  const PaymentModel({
    required this.id,
    this.bookingId,
    required this.userId,
    required this.amount,
    required this.type,
    required this.status,
    this.transactionId,
    this.description,
    required this.createdAt,
    this.paymentMethod,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);

  PaymentModel copyWith({
    String? id,
    String? bookingId,
    String? userId,
    double? amount,
    TransactionType? type,
    PaymentStatus? status,
    String? transactionId,
    String? description,
    DateTime? createdAt,
    String? paymentMethod,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      status: status ?? this.status,
      transactionId: transactionId ?? this.transactionId,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  @override
  List<Object?> get props => [
        id,
        bookingId,
        userId,
        amount,
        type,
        status,
        transactionId,
        description,
        createdAt,
        paymentMethod,
      ];
}

