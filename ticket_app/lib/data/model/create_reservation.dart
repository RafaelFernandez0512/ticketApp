import 'package:ticket_app/data/model/city.dart';
import 'package:ticket_app/data/model/schedule.dart';
import 'package:ticket_app/data/model/state.dart';
import 'package:ticket_app/data/model/travel.dart';

class CreateReservation {
  int? id = 0;
  StateModel? fromSate;
  String? fromAddressLine1;
  String? fromAddressLine2;
  City? fromCity;
  int? fromZipCode;
  StateModel? toState;
  String? toAddressLine1;
  String? toAddressLine2;
  City? toCity;
  int? toZipCode;
  int customerId;

  DateTime? date;
  int? serviceType;
  Schedule? hour;
  int? bagsCount;
  int? passengerCount = 1;
  int? items;
  int? idCustomerAddress;
  int? idCustomerAddressTo;
  double? price;

  String? fromFullAddress;
  Travel? travel;
  String? photo;
  String? toFullAddress;
  bool? additional;
  String? comment;
  CreateReservation(
      {this.fromSate,
      this.toState,
      this.fromCity,
      this.toCity,
      this.date,
      this.serviceType,
      required this.customerId,
      this.travel,
      this.description,
      this.quantity = 1,
      this.id,additional = false,});

  String? description;

  int? quantity = 1;

  Map<String, dynamic> toJson() {
    return {
      'ReservationNumber': id,
      'ReservationStatus': 'IN',
      'OneWay': false,
      'RoundTrip': false,
      'Travel': travel?.travelNumber,
      'Customer': customerId,
      'PassengerNumber': passengerCount,
      'AddressLine1From': fromAddressLine1,
      'StateFrom': fromSate?.idState,
      'CityFrom': fromCity?.idCity,
      'ZipCodeFrom': fromZipCode,
      'StateTo': toState?.idState,
      'CityTo': toCity?.idCity,
      'ZipCodeTo': toZipCode,
      'Description': '',
      'Bag': bagsCount,
      'Amount': price,
      'CreateDate': DateTime.now().toIso8601String(),
      'Additional': (additional??false),
      'AdditionalNo': !(additional??false),
      'Comment': comment,
    };
  }

  Map<String, dynamic> toJsonService() {
    return {
      'ServiceNumber': id,
      'ServiceStatus': 'I',
      'OneWay': false,
      'RoundTrip': false,
      'Travel': travel?.travelNumber,
      'Customer': customerId,
      'Item': items,
      'AddressLine1From': fromAddressLine1,
      'AddressLine2From': fromAddressLine2,
      'StateFrom': fromSate?.idState,
      'CityFrom': fromCity?.idCity,
      'ZipCodeFrom': fromZipCode,
      'AddressLine1To': toAddressLine1,
      'AddressLine2To': toAddressLine2,
      'StateTo': toState?.idState,
      'CityTo': toCity?.idCity,
      'ZipCodeTo': toZipCode,
      'Description': description,
      'Amount': price,
      'CreateDate': DateTime.now().toIso8601String(),
      'Image': null,
      'Quantity': quantity
    };
  }
}
