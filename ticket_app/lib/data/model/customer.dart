class Customer {
   String? firstName;
   String? middleName;
   String? lastName;
   String? email;
   String? phoneNumber;
   String? mobile;
   DateTime? birthday;
   String? addressLine1;
   String? addressLine2;
   String? zipCode;
   String? emergencyContact;
   String? contactPhoneNumber;

  Customer({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.mobile,
    required this.birthday,
    required this.addressLine1,
    required this.addressLine2,
    required this.zipCode,
    required this.emergencyContact,
    required this.contactPhoneNumber,
  });

  // Método para convertir un JSON en un objeto Customer
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      firstName: json['FirstName'],
      middleName: json['MiddleName'],
      lastName: json['LastName'],
      email: json['Email'],
      phoneNumber: json['PhoneNumber'],
      mobile: json['Mobile'],
      birthday: DateTime.parse(json['Birthday']),
      addressLine1: json['AddressLine1'],
      addressLine2: json['AddressLine2'],
      zipCode: json['ZipCode'],
      emergencyContact: json['EmergencyContact'],
      contactPhoneNumber: json['ContactPhoneNumber'],
    );
  }

  // Método para convertir un objeto Customer a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'MiddleName': middleName,
      'LastName': lastName,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'Mobile': mobile,
      'Birthday': birthday?.toIso8601String(),
      'AddressLine1': addressLine1,
      'AddressLine2': addressLine2,
      'ZipCode': zipCode,
      'EmergencyContact': emergencyContact,
      'ContactPhoneNumber': contactPhoneNumber,
    };
  }
}