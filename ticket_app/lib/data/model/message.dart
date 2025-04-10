class Message {
  String? message;

  Message({ this.message});
  // Método para convertir JSON a un objeto Employee
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['Mensaje'],
    );
  }
  // Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'Mensaje': message,
    };
  }
}

class EmailMessage {
  String? message;

  EmailMessage({ this.message});
  // Método para convertir JSON a un objeto Employee
  factory EmailMessage.fromJson(Map<String, dynamic> json) {
    return EmailMessage(
      message: json['Email'],
    );
  }
  // Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'Email': message,
    };
  }
}