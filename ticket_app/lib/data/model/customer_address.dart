class CustomerAddress {
   int? idCustomerAddress;
   String? fullAddress;
   String? addressLine1;
   String? addressLine2;
   String? zipCode;
   int? reservationNumber;

  CustomerAddress({
     this.idCustomerAddress,
     this.fullAddress,
     this.addressLine1,
     this.addressLine2,
     this.zipCode,
     this.reservationNumber,
  });

  // Método para convertir un JSON en un objeto CustomerAddress
  factory CustomerAddress.fromJson(Map<String, dynamic> json) {
    return CustomerAddress(
      idCustomerAddress: json['Id_CustomerAddress'],
      fullAddress: json['FullAddress'],
      addressLine1: json['AddressLine1'],
      addressLine2: json['AddressLine2'],
      zipCode: json['ZipCode'],
      reservationNumber: json['ReservationNumber'],
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
    };
  }
}
