import 'package:ticket_app/data/model/city.dart';
import 'package:ticket_app/data/model/schedule.dart';
import 'package:ticket_app/data/model/state.dart';
import 'package:ticket_app/data/model/town.dart';
import 'package:ticket_app/data/model/travel.dart';

class CreateReservation {
  StateModel? fromSate;
  String? fromAddressLine1;
  String? fromAddressLine2;
  Town? fromTown;
  City? fromCity;
  String? fromZipCode;
  StateModel? toState;
  String? toAddressLine1;
  String? toAddressLine2;
  Town? toTown;
  City? toCity;
  String? toZipCode;
  int customerId;

  DateTime? date;
  int? serviceType;
  Schedule? hour;
  int? bagsCount;
  int? passengerCount = 1;
  int? idCustomerAddress;
  int? idCustomerAddressTo;
  double? price;

  String? fromFullAddress;
  Travel? travel;

  String? toFullAddress;
  CreateReservation(
      {this.fromSate,
      this.toState,
      this.fromCity,
      this.toCity,
      this.fromTown,
      this.toTown,
      this.date,
      this.serviceType,
     required  this.customerId,
      this.travel});

  Map<String, dynamic> toJson() {
    return {
      'ReservationNumber': 0,
      'ReservationStatus': 'IN',
      'OneWay': false,
      'RoundTrip': false,
      'Travel': travel?.travelNumber,
      'Customer': customerId,
      'PassengerNumber': passengerCount,
      'AddressLine1From': fromAddressLine1,
      'AddressLine2From': fromAddressLine2,
      'StateFrom': fromSate?.idState,
      'CityFrom': fromCity?.idCity,
      'TownFrom': fromTown?.idTown,
      'ZipCodeFrom': fromZipCode,
      'AddressLine1To': toAddressLine1,
      'AddressLine2To': toAddressLine2,
      'StateTo': toState?.idState,
      'CityTo': toCity?.idCity,
      'TownTo': toTown?.idTown,
      'ZipCodeTo': toZipCode,
      'Description': '',
      'Bag': bagsCount,
      'Amount': price,
      'CreateDate': DateTime.now().toIso8601String(),
    };
  }
}
