class PeoplesModel {
  final int id;
  final String name;
  final String connectionLink;
  final String mobileNumber;
  final String email;
  final String currentRole;
  final String designation;
  PeoplesModel({
    required this.id,
    required this.name,
    required this.connectionLink,
    required this.mobileNumber,
    required this.email,
    required this.currentRole,
    required this.designation,
  });

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'connectionLink': connectionLink});
    result.addAll({'mobileNumber': mobileNumber});
    result.addAll({'email': email});
    result.addAll({'role': currentRole});
    result.addAll({'desgination': designation});
  
    return result;
  }

  factory PeoplesModel.fromJson(Map<String, dynamic> map) {
    return PeoplesModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      connectionLink: map['connection_link'] ?? '',
      mobileNumber: map['mobile_number'] ?? '',
      email: map['email'] ?? '',
      currentRole: map['role'] ?? '',
      designation: map['designation'] ?? ''
    );
  }

}
