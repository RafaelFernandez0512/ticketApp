class Configuration {
  final String? idConfiguracion;
  final String? descripcion;
  final String? nota;

  Configuration({
    required this.idConfiguracion,
    required this.descripcion,
    this.nota,
  });

  // Método para convertir un JSON a un objeto Configuration
  factory Configuration.fromJson(Map<String, dynamic> json) {
    return Configuration(
      idConfiguracion: json['Id_Configuracion'] as String?,
      descripcion: json['Descripcion'] as String?,
      nota: json['Nota'] as String?,
    );
  }

  // Método para convertir un objeto Configuration a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'Id_Configuracion': idConfiguracion,
      'Descripcion': descripcion,
      'Nota': nota,
    };
  }
}