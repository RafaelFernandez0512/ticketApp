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
  String? town;
  String? zipCode;

  String? middleName;

 static Customer mapUserRegisterToCustomer(UserRegister userRegister) {
    return Customer(
      firstName: userRegister.firsName,
      middleName: userRegister.middleName,
      lastName: userRegister.lastName,
      email: userRegister.email,
      phoneNumber: userRegister.phoneNumber,
      mobile: userRegister.phoneNumber,
      birthday: null,
      addressLine1: userRegister.addressLine1,
      addressLine2: userRegister.addressLine2,
      zipCode: userRegister.zipCode,
      emergencyContact: userRegister.phoneNumber,
      contactPhoneNumber: userRegister.phoneNumber,
    );
  }
}
