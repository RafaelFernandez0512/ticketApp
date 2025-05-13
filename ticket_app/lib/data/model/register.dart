import 'package:ticket_app/data/model/customer.dart';

class UserRegister {
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
  String? gender;
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
      state: userRegister.state,
      town: userRegister.town,
      gender: userRegister.gender,
      city: userRegister.city.toString(),
      creationDate: DateTime.now(),
    );
  }
}
