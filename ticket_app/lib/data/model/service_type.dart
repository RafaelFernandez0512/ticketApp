class ServiceType {
  int? id;
  String? name;
  ServiceType({
    this.id,
    this.name,
  });
  //json
  ServiceType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['Name'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Name'] = this.name;
    return data;
  }
}
