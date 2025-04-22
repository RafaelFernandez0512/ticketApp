class ZipCode {
  final int idZipCode;
  final String zipCodeT;
  final double price;

  ZipCode({
    required this.idZipCode,
    required this.zipCodeT,
    required this.price,
  });

  // Método para convertir un JSON a un objeto ZipCode
  factory ZipCode.fromJson(Map<String, dynamic> json) {
    return ZipCode(
      idZipCode: json['Id_ZipCode'] as int,
      zipCodeT: json['ZipCodeT'] as String,
      price: (json['Price'] as num).toDouble(),
    );
  }

  // Método para convertir un objeto ZipCode a JSON
  Map<String, dynamic> toJson() {
    return {
      'Id_ZipCode': idZipCode,
      'ZipCodeT': zipCodeT,
      'Price': price,
    };
  }
}