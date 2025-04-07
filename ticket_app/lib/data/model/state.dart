class StateModel {
  final String idState;
  final String name;

  StateModel({required this.idState, required this.name});

  // Método para convertir un JSON en un objeto State
  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      idState: json['Id_State'],
      name: json['Name'],
    );
  }

  // Método para convertir un objeto State a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'Id_State': idState,
      'Name': name,
    };
  }
}
