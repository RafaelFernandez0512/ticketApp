class Schedule {
  final String hour;
  final DateTime hourDumin;
  final bool status;

  Schedule({
    required this.hour,
    required this.hourDumin,
    required this.status,
  });

  // Método para convertir un JSON en un objeto Hour
  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      hour: json['Hour'],
      hourDumin: DateTime.parse(json['HourDumin']),
      status: json['Status'],
    );
  }

  // Método para convertir un objeto Hour a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'Hour': hour,
      'HourDumin': hourDumin.toIso8601String(),
      'Status': status,
    };
  }
}
