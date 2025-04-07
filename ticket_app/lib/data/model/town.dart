class Town {
  final String idTown;
  final String name;
  final double price;

  Town({required this.idTown, required this.name, required this.price});

  // Método para convertir un JSON en un objeto Town
  factory Town.fromJson(Map<String, dynamic> json) {
    return Town(
      idTown: json['Id_Town'].toString(),
      name: json['Name'],
      price: (json['Price'] as num)
          .toDouble(), // Convertir a double para seguridad de tipos
    );
  }

  // Método para convertir un objeto Town a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'Id_Town': idTown,
      'Name': name,
      'Price': price,
    };
  }
}
