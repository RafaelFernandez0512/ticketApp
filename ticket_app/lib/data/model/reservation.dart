import 'package:ticket_app/data/model/city.dart';
import 'package:ticket_app/data/model/reservation_status.dart';
import 'package:ticket_app/data/model/state.dart';
import 'package:ticket_app/data/model/town.dart';
import 'package:ticket_app/data/model/travel.dart';

class Reservation {
  final int reservationNumber;
  final DateTime? departureDate;
  final DateTime? departureDateFilter;
  final DateTime? createDate;
  final bool? oneWay;
  final bool? roundTrip;
  final int? passengerNumber;
  final String addressLine1From;
  final String? addressLine2From;
  final String? zipCodeFrom;
  final String? addressLine1To;
  final String? addressLine2To;
  final String? zipCodeTo;
  final String? description;
  final int? bag;
  final double? amount;
  final StateModel? stateFrom;
  final StateModel? stateTo;
  final City? cityFrom;
  final City? cityTo;
  final Town? townFrom;
  final Town? townTo;
  final Travel? travel;
  final ReservationStatus? status;

  Reservation({
    required this.reservationNumber,
    required this.departureDate,
    required this.departureDateFilter,
    required this.createDate,
    required this.oneWay,
    required this.roundTrip,
    required this.passengerNumber,
    required this.addressLine1From,
    this.addressLine2From,
    required this.zipCodeFrom,
    required this.addressLine1To,
    this.addressLine2To,
    required this.zipCodeTo,
    required this.description,
    required this.bag,
    required this.amount,
    required this.stateFrom,
    required this.stateTo,
    required this.cityFrom,
    required this.cityTo,
    required this.townFrom,
    required this.townTo,
    required this.travel,
    required this.status,
  });

// Factory method to create a Reservation object from JSON
  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      reservationNumber: json['ReservationNumber'] as int,
      departureDate: json['DepartureDate'] != null
          ? DateTime.parse(json['DepartureDate'] as String)
          : null,
      departureDateFilter: json['DepartureDateFilter'] != null
          ? DateTime.parse(json['DepartureDateFilter'] as String)
          : null,
      createDate: json['CreateDate'] != null
          ? DateTime.parse(json['CreateDate'] as String)
          : null,
      oneWay: json['OneWay'] as bool?,
      roundTrip: json['RoundTrip'] as bool?,
      passengerNumber: json['PassengerNumber'] as int?,
      addressLine1From: json['AddressLine1From'] as String? ?? '',
      addressLine2From: json['AddressLine2From'] as String?,
      zipCodeFrom: json['ZipCodeFrom'] as String?,
      addressLine1To: json['AddressLine1To'] as String? ?? '',
      addressLine2To: json['AddressLine2To'] as String?,
      zipCodeTo: json['ZipCodeTo'] as String?,
      description: json['Description'] as String?,
      bag: json['Bag'] as int?,
      amount:
          json['Amount'] != null ? (json['Amount'] as num).toDouble() : null,
      stateFrom: json['StateFrom'] != null
          ? StateModel.fromJson(json['StateFrom'])
          : null,
      stateTo:
          json['StateTo'] != null ? StateModel.fromJson(json['StateTo']) : null,
      cityFrom:
          json['CityFrom'] != null ? City.fromJson(json['CityFrom']) : null,
      cityTo: json['CityTo'] != null ? City.fromJson(json['CityTo']) : null,
      townFrom:
          json['TownFrom'] != null ? Town.fromJson(json['TownFrom']) : null,
      townTo: json['TownTo'] != null ? Town.fromJson(json['TownTo']) : null,
      travel: json['Travel'] != null ? Travel.fromJson(json['Travel']) : null,
      status: json['ReservationStatus'] != null
          ? ReservationStatus.fromJson(json['ReservationStatus'])
          : null,
    );
  }

  // Method to convert a Reservation object to JSON
  Map<String, dynamic> toJson() {
    return {
      'ReservationNumber': reservationNumber,
      'DepartureDate': departureDate?.toIso8601String(),
      'DepartureDateFilter': departureDateFilter?.toIso8601String(),
      'CreateDate': createDate?.toIso8601String(),
      'OneWay': oneWay,
      'RoundTrip': roundTrip,
      'PassengerNumber': passengerNumber,
      'AddressLine1From': addressLine1From,
      'AddressLine2From': addressLine2From,
      'ZipCodeFrom': zipCodeFrom,
      'AddressLine1To': addressLine1To,
      'AddressLine2To': addressLine2To,
      'ZipCodeTo': zipCodeTo,
      'Description': description,
      'Bag': bag,
      'Amount': amount,
      'StateFrom': stateFrom?.toJson(),
      'StateTo': stateTo?.toJson(),
      'CityFrom': cityFrom?.toJson(),
      'CityTo': cityTo?.toJson(),
      'TownFrom': townFrom?.toJson(),
      'TownTo': townTo?.toJson(),
      'Travel': travel?.toJson(),
    };
  }
}
