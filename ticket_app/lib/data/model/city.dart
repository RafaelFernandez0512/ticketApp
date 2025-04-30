class City {
  final int idCity;
  final String name;
  final double price;

  City({
    required this.idCity,
    required this.name,
    required this.price,
  });

  // Método para convertir un JSON a un objeto City
  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      idCity: json['Id_City'] as int,
      name: json['Name'] as String,
      price: (json['Price'] as num).toDouble(),
    );
  }

  // Método para convertir un objeto City a JSON
  Map<String, dynamic> toJson() {
    return {
      'Id_City': idCity,
      'Name': name,
      'Price': price,
    };
  }
}