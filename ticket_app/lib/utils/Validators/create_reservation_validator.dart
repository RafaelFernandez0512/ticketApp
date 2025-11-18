import 'package:fluent_validation/factories/abstract_validator.dart';
import 'package:ticket_app/data/model/create_reservation.dart';
class CreateReservationValidator extends AbstractValidator<CreateReservation> {
  CreateReservationValidator() 
  {
    ruleFor((user) => user.fromSate, key: 'fromSate')
        .must((value) => value != null, 'Departure state is required.');
    ruleFor((user) => user.toState, key: 'toState')
        .must((value) => value != null, 'Destination state is required.');
    ruleFor((user) => user.fromAddressLine1, key: 'fromAddressLine1').must(
        (value) => value != null && value.isNotEmpty,
        'Departure address is required.');
    ruleFor((user) => user.toAddressLine1, key: 'toAddressLine1').must(
        (value) => value != null && value.isNotEmpty,
        'Destination address is required.');
    ruleFor((user) => user.fromCity, key: 'fromCity')
        .must((value) => value != null, 'Departure County (City) is required.');
    ruleFor((user) => user.toCity, key: 'toCity')
        .must((value) => value != null, 'Destination County (City) is required.');
    ruleFor((user) => user.date, key: 'date')
        .must((value) => value != null, 'Travel date is required.');
    ruleFor((user) => user.hour, key: 'hour')
        .must((value) => value != null, 'Travel time is required.');
    ruleFor((user) => user.passengerCount, key: 'passengerCount')
        .must((value) => value != null, 'Number of passengers is required.');
    ruleFor((user) => user.fromZipCode, key: 'fromZipCode').must(
        (value) => value != null && value > 0,
        'Departure zip code is required.');
    ruleFor((user) => user.toZipCode, key: 'toZipCode').must(
        (value) => value != null && value > 0,
        'Destination zip code is required.');
  }
}

class CreateServiceReservationValidator
    extends AbstractValidator<CreateReservation> {
  CreateServiceReservationValidator() 
  {
    ruleFor((user) => user.fromSate, key: 'fromSate')
        .must((value) => value != null, 'Departure state is required.');
    ruleFor((user) => user.toState, key: 'toState')
        .must((value) => value != null, 'Destination state is required.');
    ruleFor((user) => user.fromAddressLine1, key: 'fromAddressLine1').must(
        (value) => value != null && value.isNotEmpty,
        'Departure address is required.'); 
    ruleFor((user) => user.toAddressLine1, key: 'toAddressLine1').must(
        (value) => value != null && value.isNotEmpty,
        'Destination address is required.');
    ruleFor((user) => user.fromCity, key: 'fromCity')
        .must((value) => value != null, 'Departure County (City) is required.');
    ruleFor((user) => user.toCity, key: 'toCity')
        .must((value) => value != null, 'Destination County (City) is required.');

    ruleFor((user) => user.date, key: 'date')
        .must((value) => value != null, 'Travel date is required.');
    ruleFor((user) => user.hour, key: 'hour')
        .must((value) => value != null, 'Travel time is required.');
    ruleFor((user) => user.items, key: 'items')
        .must((value) => value != null, 'Number of items is required.');
    ruleFor((user) => user.fromZipCode, key: 'fromZipCode').must(
        (value) => value != null && value > 0,
        'Departure zip code is required.');
    ruleFor((user) => user.toZipCode, key: 'toZipCode').must(
        (value) => value != null && value > 0,
        'Destination zip code is required.');
    ruleFor((user) => user.photo, key: 'photo')
        .must((value) => value != null, 'Image is required.');
    ruleFor((user) => user.description, key: 'description')
        .must((value) => value != null, 'Description is required.');
  }
}
