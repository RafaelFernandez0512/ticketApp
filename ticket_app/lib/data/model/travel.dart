import 'package:ticket_app/data/model/employee.dart';
import 'package:ticket_app/data/model/state.dart';
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
  });

  // Método para convertir un JSON en un objeto Travel
  factory Travel.fromJson(Map<String, dynamic> json) {
    return Travel(
      travelNumber: json['TravelNumber'],
      departureDate: DateTime.parse(json['DepartureDate']),
      route: json['Route'],
      seatsNumber: json['SeatsNumber'],
      seatsAvailable: json['SeatsAvailable'],
      stateFrom: StateModel.fromJson(json['StateFrom']),
      stateTo: StateModel.fromJson(json['StateTo']),
      vehicle: json['Vehicle'] != null
          ? Vehicle.fromJson(json['Vehicle'])
          : null, // Manejo de vehículo nulo
      employee:
          json['Employee'] != null ? Employee.fromJson(json['Employee']) : null,
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
