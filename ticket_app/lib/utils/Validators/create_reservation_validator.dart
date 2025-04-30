import 'package:fluent_validation/factories/abstract_validator.dart';
import 'package:ticket_app/data/model/create_reservation.dart';
import 'package:ticket_app/data/model/register.dart';

class CreateReservationValidator extends AbstractValidator<CreateReservation> {
  CreateReservationValidator() {
    ruleFor((user) => user.fromSate, key: 'fromSate').notNull();
    ruleFor((user) => user.toState, key: 'toState').notNull();
    ruleFor((user) => user.fromAddressLine1, key: 'fromAddressLine1')
        .notEmpty();
    ruleFor((user) => user.toAddressLine1, key: 'toAddressLine1').notEmpty();
    ruleFor((user) => user.fromCity, key: 'fromCity').notNull();
    ruleFor((user) => user.toCity, key: 'toCity').notNull();
    ruleFor((user) => user.fromTown, key: 'fromTown').notNull();
    ruleFor((user) => user.toTown, key: 'toTown').notNull();
    ruleFor((user) => user.date, key: 'date').notNull();
    ruleFor((user) => user.hour, key: 'hour').notNull();
    ruleFor((user) => user.bagsCount, key: 'bagsCount').notNull();
    ruleFor((user) => user.passengerCount, key: 'passengerCount').notNull();
    ruleFor((user) => user.fromZipCode, key: 'fromZipCode').notEmpty();
    ruleFor((user) => user.toZipCode, key: 'toZipCode').notEmpty();

    ruleFor((user) => user.fromAddressLine2, key: 'fromAddressLine2')
        .notEmpty();
    ruleFor((user) => user.toAddressLine2, key: 'toAddressLine2').notEmpty();
  }
}
