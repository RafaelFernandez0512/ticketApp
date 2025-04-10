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
