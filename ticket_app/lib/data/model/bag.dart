class Bag {
  final int idBag;
  final String name;
  final double price;

  Bag({required this.idBag, required this.name, required this.price});

  // Método para convertir un JSON en un objeto Bag
  factory Bag.fromJson(Map<String, dynamic> json) {
    return Bag(
      idBag: json['Id_Bag'],
      name: json['Name'],
      price: (json['Price'] as num).toDouble(),  // Asegura que el precio sea un double
    );
  }

  // Método para convertir un objeto Bag a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'Id_Bag': idBag,
      'Name': name,
      'Price': price,
    };
  }
}
