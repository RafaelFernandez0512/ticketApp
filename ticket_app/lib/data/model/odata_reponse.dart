class ODataResponse<T> {
  final List<T> value;

  ODataResponse({required this.value});

  // Método para convertir JSON OData en ODataResponse<T>
  factory ODataResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return ODataResponse<T>(
      value: (json['value'] as List).map((item) => fromJsonT(item as Map<String, dynamic>)).toList(),
    );
  }

  // Método para convertir ODataResponse<T> a JSON
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'value': value.map((item) => toJsonT(item)).toList(),
    };
  }
}
