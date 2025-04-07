class Vehicle {
  final int? idVehicle;
  final String? name;
  final int? seatsNumber;
  final String? photo;
  final bool? status;

  Vehicle({
    required this.idVehicle,
    required this.name,
    required this.seatsNumber,
    this.photo,
    required this.status,
  });

  // Método para convertir JSON a un objeto Vehicle
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      idVehicle: json['Id_Vehicle'],
      name: json['Name'],
      seatsNumber: json['SeatsNumber'],
      photo: json['Photo'], // Puede ser null
      status: json['Status'],
    );
  }

  // Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'Id_Vehicle': idVehicle,
      'Name': name,
      'SeatsNumber': seatsNumber,
      'Photo': photo,
      'Status': status,
    };
  }
}
