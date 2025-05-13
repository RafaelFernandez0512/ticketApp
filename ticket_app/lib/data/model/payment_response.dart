class PaymentResponse {
  final int? idPayment;
  final DateTime? paymentDate;
  final String? nameOnCard;
  final String? cardNumber;
  final String? expirationDate;
  final String? cvv;
  final double? subtotal;
  final double? discount;
  final double? total;
  final String? description;
  final String? reference;

  PaymentResponse({
    this.idPayment,
    this.paymentDate,
    this.nameOnCard,
    this.cardNumber,
    this.expirationDate,
    this.cvv,
    this.subtotal,
    this.discount,
    this.total,
    this.description,
    this.reference,
  });

  // Método para convertir un JSON a un objeto Payment
  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      idPayment: json['Id_Payment'] as int?,
      paymentDate: json['PaymentDate'] != null
          ? DateTime.parse(json['PaymentDate'] as String)
          : null,
      nameOnCard: json['NameOnCard'] as String?,
      cardNumber: json['CardNumber'] as String?,
      expirationDate: json['ExpirationDate'] as String?,
      cvv: json['CVV'] as String?,
      subtotal: json['Subtotal'] != null
          ? (json['Subtotal'] as num).toDouble()
          : null,
      discount: json['Discount'] != null
          ? (json['Discount'] as num).toDouble()
          : null,
      total: json['Total'] != null ? (json['Total'] as num).toDouble() : null,
      description: json['Description'] as String?,
      reference: json['Reference'] as String?,
    );
  }

  // Método para convertir un objeto Payment a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'Id_Payment': idPayment,
      'PaymentDate': paymentDate?.toIso8601String(),
      'NameOnCard': nameOnCard,
      'CardNumber': cardNumber,
      'ExpirationDate': expirationDate,
      'CVV': cvv,
      'Subtotal': subtotal,
      'Discount': discount,
      'Total': total,
      'Description': description,
      'Reference': reference,
    };
  }
}