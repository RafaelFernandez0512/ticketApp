class PriceEngine {
  double? priceWithoutDiscount;
  double? priceWithDiscount;
  double? discount;
  int? travel;
  int? customer;
  int? passengerNumber;
  int? bag;

  PriceEngine({
    this.priceWithoutDiscount,
    this.priceWithDiscount,
    this.discount,
    this.travel,
    this.customer,
    this.passengerNumber,
    this.bag,
  });

  // Método para convertir un JSON a un objeto PriceEngine
  factory PriceEngine.fromJson(Map<String, dynamic> json) {
    return PriceEngine(
      travel: json['Travel'] as int?,
      customer: json['Customer'] as int?,
      passengerNumber: json['PassengerNumber'] as int?,
      priceWithoutDiscount: (json['PrecioSinDescuento'] as num?)?.toDouble(),
      priceWithDiscount: (json['PrecioConDescuento'] as num?)?.toDouble(),
      discount: (json['Descuento'] as num?)?.toDouble(),
      bag: json['Bag'] as int?,
    );
  }

  // Método para convertir un objeto PriceEngine a JSON
  Map<String, dynamic> toJson() {
    return {
      'Travel': travel,
      'Customer': customer,
      'PassengerNumber': passengerNumber,
      'PrecioSinDescuento': priceWithoutDiscount,
      'PrecioConDescuento': priceWithDiscount,
      'Descuento': discount,
      'Bag': bag,
    };
  }
}