
class TourisModel{
  final String name;
  final String phoneNumber;


  TourisModel({
    required this.name,
    required this.phoneNumber,
  });

  factory TourisModel.fromJson(Map<String, dynamic> json) {
    return TourisModel(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }
}
