class ReservationStatus {
  final String idReservationStatus;
  final String description;

  ReservationStatus({
    required this.idReservationStatus,
    required this.description,
  });

  // Método para convertir un JSON a un objeto ReservationStatus
  factory ReservationStatus.fromJson(Map<String, dynamic> json) {
    return ReservationStatus(
      idReservationStatus: json['Id_ReservationStatus'] as String,
      description: json['Description'] as String,
    );
  }

  // Método para convertir un objeto ReservationStatus a JSON
  Map<String, dynamic> toJson() {
    return {
      'Id_ReservationStatus': idReservationStatus,
      'Description': description,
    };
  }
}