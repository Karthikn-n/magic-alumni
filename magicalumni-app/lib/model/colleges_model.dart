class CollegesModel {
  final int id;
  final String collegeName;
  final List<DepartmentModel> departments;
  CollegesModel({
    required this.id,
    required this.collegeName,
    required this.departments,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'collegeName': collegeName});
    result.addAll({'departments': departments.map((x) => x.toMap()).toList()});
  
    return result;
  }

  factory CollegesModel.fromMap(Map<String, dynamic> map) {
    return CollegesModel(
      id: map['id']?.toInt() ?? 0,
      collegeName: map['collegeName'] ?? '',
      departments: (map['departments'] ?? []).map<DepartmentModel>((department) => DepartmentModel.fromMap(department)).toList(), 
    );
  }
}

class DepartmentModel {
  final int id;
  final String departmentName;
  DepartmentModel({
    required this.id,
    required this.departmentName,
  });
  

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'departmentName': departmentName});
  
    return result;
  }

  factory DepartmentModel.fromMap(Map<String, dynamic> map) {
    return DepartmentModel(
      id: map['id']?.toInt() ?? 0,
      departmentName: map['departmentName'] ?? '',
    );
  }
}
