class Payment {
  final int idPayment;
  final String nameOnCard;
  final String cardNumber;
  final String expirationDate;
  final String cvv;
  final double subtotal;
  final double discount;
  final double total;
  final String description;
  final DateTime paymentDate;

  Payment({
    required this.idPayment,
    required this.nameOnCard,
    required this.cardNumber,
    required this.expirationDate,
    required this.cvv,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.description,
    required this.paymentDate,
  });

  // Método para convertir un JSON en un objeto Payment
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      idPayment: json['Id_Payment'],
      nameOnCard: json['NameOnCard'],
      cardNumber: json['CardNumber'],
      expirationDate: json['ExpirationDate'],
      cvv: json['CVV'],
      subtotal: (json['Subtotal'] as num).toDouble(),
      discount: (json['Discount'] as num).toDouble(),
      total: (json['Total'] as num).toDouble(),
      description: json['Description'],
      paymentDate: DateTime.parse(json['PaymentDate']),
    );
  }

  // Método para convertir un objeto Payment a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'Id_Payment': idPayment,
      'NameOnCard': nameOnCard,
      'CardNumber': cardNumber,
      'ExpirationDate': expirationDate,
      'CVV': cvv,
      'Subtotal': subtotal,
      'Discount': discount,
      'Total': total,
      'Description': description,
      'PaymentDate': paymentDate.toIso8601String(),
    };
  }
}
