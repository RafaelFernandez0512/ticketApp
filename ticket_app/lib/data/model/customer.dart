class CreateUserRequest {
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? fullName;
  final DateTime? birthday;
  final DateTime? creationDate;
  final String? email;
  final String? password;
  final String? confirmPassword;
  final String? phoneNumber;
  final String? mobile;
  final String? addressLine1;
  final String? addressLine2;
  final String? zipCode;
  final String? photo;
  final bool? status;
  final String? emergencyContact;
  final String? contactPhoneNumber;
  final bool? creadoDesdeMovil;

  CreateUserRequest({
    this.firstName,
    this.middleName,
    this.lastName,
    this.fullName,
    this.birthday,
    this.creationDate,
    this.email,
    this.password,
    this.confirmPassword,
    this.phoneNumber,
    this.mobile,
    this.addressLine1,
    this.addressLine2,
    this.zipCode,
    this.photo,
    this.status,
    this.emergencyContact,
    this.contactPhoneNumber,
    this.creadoDesdeMovil,
  });

  factory CreateUserRequest.fromJson(Map<String, dynamic> json) {
    return CreateUserRequest(
      firstName: json['FirstName'],
      middleName: json['MiddleName'],
      lastName: json['LastName'],
      fullName: json['FullName'],
      birthday: DateTime.parse(json['Birthday']),
      creationDate: DateTime.parse(json['CreationDate']),
      email: json['Email'],
      password: json['Password'],
      confirmPassword: json['ConfirmPassword'],
      phoneNumber: json['PhoneNumber'],
      mobile: json['Mobile'],
      addressLine1: json['AddressLine1'],
      addressLine2: json['AddressLine2'],
      zipCode: json['ZipCode'],
      photo: json['Photo'],
      status: json['Status'],
      emergencyContact: json['EmergencyContact'],
      contactPhoneNumber: json['ContactPhoneNumber'],
      creadoDesdeMovil: json['CreadoDesdeMovil'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'MiddleName': middleName,
      'LastName': lastName,
      'FullName': fullName,
      'Birthday': birthday?.toIso8601String(),
      'CreationDate': creationDate?.toIso8601String(),
      'Email': email,
      'Password': password,
      'ConfirmPassword': confirmPassword,
      'PhoneNumber': phoneNumber,
      'Mobile': mobile,
      'AddressLine1': addressLine1,
      'AddressLine2': addressLine2,
      'ZipCode': zipCode,
      'Photo': photo,
      'Status': status,
      'EmergencyContact': emergencyContact,
      'ContactPhoneNumber': contactPhoneNumber,
      'CreadoDesdeMovil': creadoDesdeMovil,
    };
  }
}

class Customer {
  final int idCustomer;
  final DateTime? birthday;
  final DateTime? creationDate;
  final String? fullName;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? email;
  final String? password;
  final String? confirmPassword;
  final String? phoneNumber;
  final String? mobile;
  final String? addressLine1;
  final String? addressLine2;
  final String? zipCode;
  final String? photo;
  final bool? status;
  final String? emergencyContact;
  final String? contactPhoneNumber;
  final bool? creadoDesdeMovil;

  Customer({
    required this.idCustomer,
    required this.birthday,
    required this.creationDate,
    required this.fullName,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.phoneNumber,
    required this.mobile,
    required this.addressLine1,
    this.addressLine2,
    required this.zipCode,
    this.photo,
    required this.status,
    this.emergencyContact,
    this.contactPhoneNumber,
    required this.creadoDesdeMovil,
  });

  // Método para convertir un JSON a un objeto Customer
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      idCustomer: json['Id_Customer'] as int,
      birthday: DateTime.parse(json['Birthday'] as String),
      creationDate: DateTime.parse(json['CreationDate'] as String),
      fullName: json['FullName'] as String,
      firstName: json['FirstName'] as String,
      middleName: json['MiddleName'] as String?,
      lastName: json['LastName'] as String,
      email: json['Email'] as String,
      password: json['Password'] as String,
      confirmPassword: json['ConfirmPassword'] as String,
      phoneNumber: json['PhoneNumber'] as String?,
      mobile: json['Mobile'] as String,
      addressLine1: json['AddressLine1'] as String,
      addressLine2: json['AddressLine2'] as String?,
      zipCode: json['ZipCode'] as String,
      photo: json['Photo'] as String?,
      status: json['Status'] as bool,
      emergencyContact: json['EmergencyContact'] as String?,
      contactPhoneNumber: json['ContactPhoneNumber'] as String?,
      creadoDesdeMovil: json['CreadoDesdeMovil'] as bool,
    );
  }

  // Método para convertir un objeto Customer a JSON
  Map<String, dynamic> toJson() {
    return {
      'Id_Customer': idCustomer,
      'Birthday': birthday?.toIso8601String(),
      'CreationDate': creationDate?.toIso8601String(),
      'FullName': fullName,
      'FirstName': firstName,
      'MiddleName': middleName,
      'LastName': lastName,
      'Email': email,
      'Password': password,
      'ConfirmPassword': confirmPassword,
      'PhoneNumber': phoneNumber,
      'Mobile': mobile,
      'AddressLine1': addressLine1,
      'AddressLine2': addressLine2,
      'ZipCode': zipCode,
      'Photo': photo,
      'Status': status,
      'EmergencyContact': emergencyContact,
      'ContactPhoneNumber': contactPhoneNumber,
      'CreadoDesdeMovil': creadoDesdeMovil,
    };
  }
}
