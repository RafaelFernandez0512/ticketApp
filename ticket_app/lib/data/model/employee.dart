class Employee {
  final String fullName;

  Employee({required this.fullName});

  // Método para convertir JSON a un objeto Employee
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      fullName: json['FullName'],
    );
  }

  // Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'FullName': fullName,
    };
  }
}
