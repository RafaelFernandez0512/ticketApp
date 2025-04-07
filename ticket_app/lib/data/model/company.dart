class Company {
  final int idCompany;
  final String name;
  final String phoneNumber;
  final String email;
  final String url;
  final String addressLine1;
  final String? addressLine2;
  final int zipCode;
  final int travelSequence;
  final int reservationSequence;
  final int membershipSequence;
  final bool status;

  Company({
    required this.idCompany,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.url,
    required this.addressLine1,
    this.addressLine2,
    required this.zipCode,
    required this.travelSequence,
    required this.reservationSequence,
    required this.membershipSequence,
    required this.status,
  });

  // Método para convertir un JSON en un objeto Company
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      idCompany: json['Id_Company'],
      name: json['Name'],
      phoneNumber: json['PhoneNumber'],
      email: json['Email'],
      url: json['Url'],
      addressLine1: json['AddressLine1'],
      addressLine2: json['AddressLine2'],
      zipCode: json['ZipCode'],
      travelSequence: json['TravelSequence'],
      reservationSequence: json['ReservationSequence'],
      membershipSequence: json['MembershipSequence'],
      status: json['Status'],
    );
  }

  // Método para convertir un objeto Company a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'Id_Company': idCompany,
      'Name': name,
      'PhoneNumber': phoneNumber,
      'Email': email,
      'Url': url,
      'AddressLine1': addressLine1,
      'AddressLine2': addressLine2,
      'ZipCode': zipCode,
      'TravelSequence': travelSequence,
      'ReservationSequence': reservationSequence,
      'MembershipSequence': membershipSequence,
      'Status': status,
    };
  }
}
