class CollegesModel {
  final String id;
  final String collegeName;
  final String address;
  final String city;
  final String currentYear;
  final String completedYear;
  final List<DepartmentModel> departments;
  final String status;
  CollegesModel({
    required this.id,
    required this.collegeName,
    required this.address,
    required this.city,
    required this.completedYear,
    required this.currentYear,
    required this.departments,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'_id': id});
    result.addAll({'name': collegeName});
    result.addAll({'address': address});
    result.addAll({'city': city});
    result.addAll({'departments': departments.map((x) => x.toMap()).toList()});
    result.addAll({'approvalStatus': status});
    result.addAll({'completed_year': completedYear});
    result.addAll({'current_year': currentYear});
  
    return result;
  }

  factory CollegesModel.fromMap(Map<String, dynamic> map) {
    return CollegesModel(
      id: map['_id'] ?? '',
      collegeName: map['name'] ?? '',
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      currentYear: map["current_year"] ?? "",
      completedYear: map["completed_year"] ?? '',
      status: map['approvalStatus'] ?? '',
      departments: (map['departments'] ?? []).map<DepartmentModel>((department) => DepartmentModel.fromMap(department)).toList(), 
    );
  }
}

class DepartmentModel {
  final String id;
  final String collegeId;
  final String departmentName;
  DepartmentModel({
    required this.id,
    required this.collegeId,
    required this.departmentName,
  });
  

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'_id': id});
    result.addAll({'name': departmentName});
    result.addAll({'college_id': collegeId});
  
    return result;
  }

  factory DepartmentModel.fromMap(Map<String, dynamic> map) {
    return DepartmentModel(
      id: map['_id'] ?? '',
      departmentName: map['name'] ?? '',
      collegeId: map['college_id'] ?? '',
    );
  }
}
