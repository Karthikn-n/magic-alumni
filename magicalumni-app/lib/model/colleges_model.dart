class CollegesModel {
  final String id;
  final String collegeName;
  final String address;
  final String city;
  final List<DepartmentModel> departments;
  CollegesModel({
    required this.id,
    required this.collegeName,
    required this.address,
    required this.city,
    required this.departments,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'_id': id});
    result.addAll({'name': collegeName});
    result.addAll({'address': address});
    result.addAll({'city': city});
    result.addAll({'departments': departments.map((x) => x.toMap()).toList()});
  
    return result;
  }

  factory CollegesModel.fromMap(Map<String, dynamic> map) {
    return CollegesModel(
      id: map['_id'] ?? '',
      collegeName: map['name'] ?? '',
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      departments: (map['departments'] ?? []).map<DepartmentModel>((department) => DepartmentModel.fromMap(department)).toList(), 
    );
  }
}

class DepartmentModel {
  final String id;
  final String departmentName;
  DepartmentModel({
    required this.id,
    required this.departmentName,
  });
  

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'_id': id});
    result.addAll({'departmentName': departmentName});
  
    return result;
  }

  factory DepartmentModel.fromMap(Map<String, dynamic> map) {
    return DepartmentModel(
      id: map['_id'] ?? '',
      departmentName: map['name'] ?? '',
    );
  }
}
