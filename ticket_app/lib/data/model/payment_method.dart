class PaymentMethod {
  final String idPaymentMethod;
  final String description;

  PaymentMethod({required this.idPaymentMethod, required this.description});

  // Método para convertir un JSON en un objeto PaymentMethod
  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      idPaymentMethod: json['Id_PaymentMethod'],
      description: json['Description'],
    );
  }

  // Método para convertir un objeto PaymentMethod a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'Id_PaymentMethod': idPaymentMethod,
      'Description': description,
    };
  }
}
