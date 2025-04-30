class PriceOnlineRequest {
  final int travel;
  final int customer;
  final int passengerNumber;
  final String stateFrom;
  final int cityFrom;
  final int townFrom;
  final String zipCodeFrom;
  final String stateTo;
  final int cityTo;
  final int townTo;
  final String zipCodeTo;
  final int bag;

  PriceOnlineRequest({
    required this.travel,
    required this.customer,
    required this.passengerNumber,
    required this.stateFrom,
    required this.cityFrom,
    required this.townFrom,
    required this.zipCodeFrom,
    required this.stateTo,
    required this.cityTo,
    required this.townTo,
    required this.zipCodeTo,
    required this.bag,
  });

  // Método para convertir un JSON a un objeto PriceOnlineRequest
  factory PriceOnlineRequest.fromJson(Map<String, dynamic> json) {
    return PriceOnlineRequest(
      travel: json['Travel'] as int,
      customer: json['Customer'] as int,
      passengerNumber: json['PassengerNumber'] as int,
      stateFrom: json['StateFrom'] as String,
      cityFrom: json['CityFrom'] as int,
      townFrom: json['TownFrom'] as int,
      zipCodeFrom: json['ZipCodeFrom'] as String,
      stateTo: json['StateTo'] as String,
      cityTo: json['CityTo'] as int,
      townTo: json['TownTo'] as int,
      zipCodeTo: json['ZipCodeTo'] as String,
      bag: json['Bag'] as int,
    );
  }

  // Método para convertir un objeto PriceOnlineRequest a JSON
  Map<String, dynamic> toJson() {
    return {
      'Travel': travel,
      'Customer': customer,
      'PassengerNumber': passengerNumber,
      'StateFrom': stateFrom,
      'CityFrom': cityFrom,
      'TownFrom': townFrom,
      'ZipCodeFrom': zipCodeFrom,
      'StateTo': stateTo,
      'CityTo': cityTo,
      'TownTo': townTo,
      'ZipCodeTo': zipCodeTo,
      'Bag': bag,
    };
  }
}