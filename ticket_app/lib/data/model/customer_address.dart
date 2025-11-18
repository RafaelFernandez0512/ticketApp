import 'package:ticket_app/data/model/city.dart';
import 'package:ticket_app/data/model/state.dart';

class CustomerAddress {
  int? idCustomerAddress;
  String? fullAddress;
  String? addressLine1;
  String? addressLine2;
  String? zipCode;
  int? reservationNumber;
  StateModel? state;
  City? city;

  CustomerAddress({
    this.idCustomerAddress,
    this.fullAddress,
    this.addressLine1,
    this.addressLine2,
    this.zipCode,
    this.reservationNumber,
    this.state,
    this.city,
  });

  // Método para convertir un JSON en un objeto CustomerAddress
  factory CustomerAddress.fromJson(Map<String, dynamic> json) {
    return CustomerAddress(
      idCustomerAddress: json['Id_CustomerAddress'] as int?,
      fullAddress: json['FullAddress'] as String?,
      addressLine1: json['AddressLine1'] as String?,
      addressLine2: json['AddressLine2'] as String?,
      zipCode: json['ZipCode'] as String?,
      reservationNumber: json['ReservationNumber'] as int?,
      state: json['State'] != null ? StateModel.fromJson(json['State']) : null,
      city: json['City'] != null ? City.fromJson(json['City']) : null,
    );
  }

  // Método para convertir un objeto CustomerAddress a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'Id_CustomerAddress': idCustomerAddress,
      'FullAddress': fullAddress,
      'AddressLine1': addressLine1,
      'AddressLine2': addressLine2,
      'ZipCode': zipCode,
      'ReservationNumber': reservationNumber,
      'State': state?.toJson(),
      'City': city?.toJson(),
    };
  }
}
