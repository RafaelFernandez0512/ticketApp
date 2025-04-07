class Session {
  String? username;
  String? password;
  DateTime? expirationDate;
  DateTime? expirationTemporalTokenDate;
  String? token;
  String? refreshToken;

  Session({
    this.username,
    this.password,
    this.expirationDate,
    this.expirationTemporalTokenDate,
    this.token,
    this.refreshToken,
  });

  // Método para convertir el modelo a un Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'expirationDate': expirationDate?.toIso8601String(),
      'token': token,
      'refreshToken': refreshToken,
      'expirationTemporalTokenDate':
          expirationTemporalTokenDate?.toIso8601String(),
    };
  }

  // Método para crear un modelo a partir de un Map (JSON)
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      username: json['username'],
      password: json['password'],
      expirationDate: DateTime.tryParse(json['expirationDate'] ?? ''),
      token: json['token'],
      refreshToken: json['refreshToken'],
      expirationTemporalTokenDate:
          DateTime.tryParse(json['expirationTemporalTokenDate'] ?? ''),
    );
  }

  // Método para verificar si la sesión está expirada
  bool isSessionExpired() {
    if (expirationDate == null) return true;
    return DateTime.now().isAfter(expirationDate!);
  }

  bool isSessionTemporalExpired() {
    if (expirationTemporalTokenDate == null) return true;
    return DateTime.now().difference(expirationTemporalTokenDate!).inMinutes >
        30;
  }
}
