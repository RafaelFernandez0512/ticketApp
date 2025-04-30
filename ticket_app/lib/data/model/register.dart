import 'package:ticket_app/data/model/customer.dart';

class UserRegister {
  //FirsName,LastName,Email,Password,ConfirmPassword,PhoneNumber
  // AddressLine1,AddressLine2,State,Town,City,ZipCode
  String? firsName;
  String? lastName;
  String? email;
  String? password;
  String? confirmPassword;
  String? phoneNumber;
  String? addressLine1;
  String? addressLine2;
  String? state;
  int? town;
  String? zipCode;
  DateTime? birthday;
  String? middleName;

  int? city;
  String? photo;

  static CreateUserRequest mapUserRegisterToCustomer(
      UserRegister userRegister) {
    return CreateUserRequest(
      firstName: userRegister.firsName,
      middleName: userRegister.middleName,
      lastName: userRegister.lastName,
      email: userRegister.email,
      phoneNumber: userRegister.phoneNumber,
      mobile: userRegister.phoneNumber,
      birthday: userRegister.birthday,
      addressLine1: userRegister.addressLine1,
      addressLine2: userRegister.addressLine2,
      zipCode: userRegister.zipCode,
      emergencyContact: userRegister.phoneNumber,
      contactPhoneNumber: userRegister.phoneNumber,
      confirmPassword: userRegister.confirmPassword,
      password: userRegister.password,
      creadoDesdeMovil: true,
      creationDate: DateTime.now(),
    );
  }
}
