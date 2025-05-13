import 'package:ticket_app/data/model/city.dart';
import 'package:ticket_app/data/model/employee.dart';
import 'package:ticket_app/data/model/schedule.dart';
import 'package:ticket_app/data/model/state.dart';
import 'package:ticket_app/data/model/town.dart';
import 'package:ticket_app/data/model/vehicle.dart';

class Travel {
  final int travelNumber;
  final DateTime departureDate;
  final String route;
  final int seatsNumber;
  final int seatsAvailable;
  final StateModel? stateFrom;
  final StateModel? stateTo;
  final Vehicle? vehicle;
  final Employee? employee;
  final City? cityFrom;
  final City? cityTo;
  final Town? townFrom;
  final Town? townTo;
  final Schedule? schedule;

  Travel({
    required this.travelNumber,
    required this.departureDate,
    required this.route,
    required this.seatsNumber,
    required this.seatsAvailable,
    required this.stateFrom,
    required this.stateTo,
    required this.vehicle,
    required this.employee,
    required this.cityFrom,
    required this.cityTo,
    required this.townFrom,
    required this.townTo,
    required this.schedule,
  });

  // Método para convertir un JSON en un objeto Travel
  factory Travel.fromJson(Map<String, dynamic> json) {
    return Travel(
      travelNumber: json['TravelNumber'],
      departureDate: DateTime.parse(json['DepartureDate']).toLocal(),
      route: json['Route'],
      seatsNumber: json['SeatsNumber'],
      seatsAvailable: json['SeatsAvailable'],
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
      vehicle: json['Vehicle'] != null
          ? Vehicle.fromJson(json['Vehicle'])
          : null, // Manejo de vehículo nulo
      employee:
          json['Employee'] != null ? Employee.fromJson(json['Employee']) : null,
      schedule: json['DepartureTime'] != null
          ? Schedule.fromJson(json['DepartureTime'])
          : null, // Manejo de horario nulo
    );
  }

  // Método para convertir un objeto Travel a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'TravelNumber': travelNumber,
      'DepartureDate': departureDate.toIso8601String(),
      'Route': route,
      'SeatsNumber': seatsNumber,
      'SeatsAvailable': seatsAvailable,
      'StateFrom': stateFrom?.toJson(),
      'StateTo': stateTo?.toJson(),
      'Vehicle': vehicle?.toJson(),
      'Employee': employee?.toJson(), // Manejo de empleado nulo
    };
  }

  Map<String, dynamic> toTicket() {
    return {
      'TravelNumber': travelNumber.toString(),
      'DepartureDate': departureDate.toIso8601String(),
      'Route': route,
      'SeatsNumber': seatsNumber.toString(),
      'SeatsAvailable': seatsAvailable.toString(),
      'StateFrom': stateFrom?.name ?? '',
      'StateTo': stateTo?.name ?? '',
      'Vehicle': vehicle?.name ?? '',
      'Employee': employee?.fullName ?? '',
    };
  }
}
