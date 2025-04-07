import 'package:fluent_validation/factories/abstract_validator.dart';
import 'package:ticket_app/data/model/register.dart';

class UserRegisterValidator extends AbstractValidator<UserRegister> {
  UserRegisterValidator() {
    ruleFor((user) => user.firsName, key: 'firsName').notEmpty();
    ruleFor((user) => user.lastName, key: 'lastName').notEmpty();
    ruleFor((user) => user.email, key: 'email').notEmpty();
    ruleFor((user) => user.password, key: 'password').notEmpty();
    ruleFor((user) => user.confirmPassword, key: 'confirmPassword').notEmpty();

    ruleFor((user) => user, key: 'confirmPassword').must((value) {
      var user = value as UserRegister;
      return user.confirmPassword == user.password;
    }, 'Password and Confirm Password must be the same');
    ruleFor((user) => user.phoneNumber, key: 'phoneNumber').notEmpty();
  }
}

class UserRegisterAddressValidator extends AbstractValidator<UserRegister> {
  UserRegisterAddressValidator() {
    ruleFor((user) => user.addressLine1, key: 'addressLine1').notEmpty();
    ruleFor((user) => user.addressLine2, key: 'addressLine2').notEmpty();
    ruleFor((user) => user.state, key: 'state').notEmpty();
    ruleFor((user) => user.town, key: 'town').notEmpty();
    ruleFor((user) => user.zipCode, key: 'zipCode').notEmpty();
  }
}
