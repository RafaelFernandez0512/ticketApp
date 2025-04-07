class Reservation {
  final int reservationNumber;
  final bool oneWay;
  final bool roundTrip;
  final DateTime departureDateFilter;
  final int passengerNumber;
  final String addressLine1From;
  final String addressLine2From;
  final String zipCodeFrom;
  final String addressLine1To;
  final String addressLine2To;
  final String zipCodeTo;
  final String description;
  final int bag;
  final double amount;
  final DateTime createDate;

  Reservation({
    required this.reservationNumber,
    required this.oneWay,
    required this.roundTrip,
    required this.departureDateFilter,
    required this.passengerNumber,
    required this.addressLine1From,
    required this.addressLine2From,
    required this.zipCodeFrom,
    required this.addressLine1To,
    required this.addressLine2To,
    required this.zipCodeTo,
    required this.description,
    required this.bag,
    required this.amount,
    required this.createDate,
  });

  // Método para convertir un JSON en un objeto Reservation
  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      reservationNumber: json['ReservationNumber'],
      oneWay: json['OneWay'],
      roundTrip: json['RoundTrip'],
      departureDateFilter: DateTime.parse(json['DepartureDateFilter']),
      passengerNumber: json['PassengerNumber'],
      addressLine1From: json['AddressLine1From'],
      addressLine2From: json['AddressLine2From'],
      zipCodeFrom: json['ZipCodeFrom'],
      addressLine1To: json['AddressLine1To'],
      addressLine2To: json['AddressLine2To'],
      zipCodeTo: json['ZipCodeTo'],
      description: json['Description'],
      bag: json['Bag'],
      amount: (json['Amount'] as num).toDouble(),
      createDate: DateTime.parse(json['CreateDate']),
    );
  }

  // Método para convertir un objeto Reservation a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'ReservationNumber': reservationNumber,
      'OneWay': oneWay,
      'RoundTrip': roundTrip,
      'DepartureDateFilter': departureDateFilter.toIso8601String(),
      'PassengerNumber': passengerNumber,
      'AddressLine1From': addressLine1From,
      'AddressLine2From': addressLine2From,
      'ZipCodeFrom': zipCodeFrom,
      'AddressLine1To': addressLine1To,
      'AddressLine2To': addressLine2To,
      'ZipCodeTo': zipCodeTo,
      'Description': description,
      'Bag': bag,
      'Amount': amount,
      'CreateDate': createDate.toIso8601String(),
    };
  }
}
