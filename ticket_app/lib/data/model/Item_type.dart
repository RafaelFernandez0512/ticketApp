class ItemType {
  final int idItem;
  final String description;
  final double price;

  ItemType({
    required this.idItem,
    required this.description,
    required this.price,
  });

  factory ItemType.fromJson(Map<String, dynamic> json) {
    return ItemType(
      idItem: json['Id_Item'] as int,
      description: json['Description'] as String,
      price: (json['Price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id_Item': idItem,
      'Description': description,
      'Price': price,
    };
  }
}