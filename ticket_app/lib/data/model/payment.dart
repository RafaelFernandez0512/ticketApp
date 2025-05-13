class Payment {
  final int? reservationNumber;
  final int? membership;
  final int? service;
  final int? customer;
  final String? paymentMethod;
  final double? subtotal;
  final double? discount;
  final double? total;
  final String? description;
  final DateTime? paymentDate;
  final String? reference;

  Payment({
    this.reservationNumber,
    this.membership,
    this.service,
    this.customer,
    this.paymentMethod,
    this.subtotal,
    this.discount,
    this.total,
    this.description,
    this.paymentDate,
    this.reference,
  });

  // Método para convertir un JSON a un objeto Payment
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      reservationNumber: json['ReservationNumber'] as int?,
      membership: json['Membership'] as int?,
      service: json['Service'] as int?,
      customer: json['Customer'] as int?,
      paymentMethod: json['paymentMethod'] as String?,
      subtotal: json['Subtotal'] != null
          ? (json['Subtotal'] as num).toDouble()
          : null,
      discount: json['Discount'] != null
          ? (json['Discount'] as num).toDouble()
          : null,
      total: json['Total'] != null ? (json['Total'] as num).toDouble() : null,
      description: json['Description'] as String?,
      paymentDate: json['PaymentDate'] != null
          ? DateTime.parse(json['PaymentDate'] as String)
          : null,
      reference: json['Reference'] as String?,
    );
  }

  // Método para convertir un objeto Payment a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'ReservationNumber': reservationNumber,
      'Membership': membership,
      'Service': service,
      'Customer': customer,
      'paymentMethod': paymentMethod,
      'Subtotal': subtotal,
      'Discount': discount,
      'Total': total,
      'Description': description,
      'PaymentDate': paymentDate?.toIso8601String(),
      'Reference': reference,
    };
  }
}
