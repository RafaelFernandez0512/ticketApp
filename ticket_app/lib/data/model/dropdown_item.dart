class DropdownItem {
  final int value;
  final String label;

  // Constructor
  const DropdownItem({
    this.value = 0,
    this.label = "",
  });

  // Método para convertir de JSON a objeto
  factory DropdownItem.fromJson(Map<String, dynamic> json) {
    return DropdownItem(
      value: json['value'] ?? 0,
      label: json['label'] ?? '',
    );
  }

  // Método para convertir de objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'label': label,
    };
  }
}
