class CreateReservation {
  String? idFromSate;
  String? fromAddressLine1;
  String? fromAddressLine2;
  String? idFromTown;
  String? fromZipCode;
  String? idToSate;
  String? toAddressLine1;
  String? toAddressLine2;
  String? idToTown;
  String? toZipCode;
  String? customerId;

  DateTime? date;
  int? serviceType;
  String? hour;
  int? bagsCount;
  int? passengerCount;

  CreateReservation({
    this.idFromSate,
    this.idToSate,
    this.date,
    this.serviceType,
    this.customerId
  });
}
