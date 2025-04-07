class Day {
  final int idDay;
  final String name;

  Day({required this.idDay, required this.name});

  // Método para convertir un JSON en un objeto Day
  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      idDay: json['Id_Day'],
      name: json['Name'],
    );
  }

  // Método para convertir un objeto Day a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'Id_Day': idDay,
      'Name': name,
    };
  }
}
