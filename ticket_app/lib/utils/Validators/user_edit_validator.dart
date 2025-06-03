import 'package:fluent_validation/factories/abstract_validator.dart';
import 'package:ticket_app/data/model/customer.dart';
import 'package:ticket_app/data/model/register.dart';

class UpdateCustemerValidator extends AbstractValidator<Customer> {
  UpdateCustemerValidator() {
    ruleFor((user) => user.firstName, key: 'firsName').must(
        (value) => value != null && value.isNotEmpty,
        'First name is required.');
    ruleFor((user) => user.lastName, key: 'lastName').must(
        (value) => value != null && value.isNotEmpty, 'Last name is required.');
    ruleFor((user) => user.email, key: 'email').must(
        (value) => value != null && value.isNotEmpty, 'Email is required.');
    ruleFor((user) => user.password, key: 'password').must(
        (value) => value != null && value.isNotEmpty, 'Password is required.');
    ruleFor((user) => user.confirmPassword, key: 'confirmPassword').must(
        (value) => value != null && value.isNotEmpty,
        'Confirm password is required.');

    ruleFor((user) => user, key: 'confirmPassword').must((value) {
      var user = value as Customer;
      return user.confirmPassword == user.password;
    }, 'Password and Confirm Password must match.');
    ruleFor((user) => user.phoneNumber, key: 'phoneNumber').must(
        (value) => value != null && value.isNotEmpty,
        'Phone number is required.');
    ruleFor((user) => user.gender, key: 'gender').must(
        (value) => value != null && value.isNotEmpty, 'gender is required.');
    ruleFor((user) => user.addressLine1, key: 'addressLine1').must(
        (value) => value != null && value.isNotEmpty,
        'Address Line 1 is required.');

    ruleFor((user) => user.state, key: 'state').must(
        (value) => value != null && value.isNotEmpty, 'State is required.');
    ruleFor((user) => user.city, key: 'city')
        .must((value) => value != null, 'County (City) is required.');
    ruleFor((user) => user.town, key: 'town')
        .must((value) => value != null, 'Town (Neighborhood) is required.');
    ruleFor((user) => user.zipCode, key: 'zipCode').must(
        (value) => value != null && value.isNotEmpty, 'Zip Code is required.');
  }
}
