class AlumniModel {
  final int id;
  final String name;
  final List<CollegeApprovalModel> colleges;
  final String mobile;
  final String email;
  final bool mobilePrefs;
  final bool emailPrefs;
  final String linkedUrl;
  final String designation;
  AlumniModel({
    required this.id,
    required this.name,
    required this.colleges,
    required this.mobile,
    required this.email,
    required this.mobilePrefs,
    required this.emailPrefs,
    required this.linkedUrl,
    required this.designation,
  });
  
  factory AlumniModel.fromJson(Map<String, dynamic> json){
    return AlumniModel(
      id: json["_id"], 
      name: json["name"], 
      colleges: (json["colleges"] ?? []).map<CollegeApprovalModel>((college) => CollegeApprovalModel.fromJson(college)).toList(), 
      mobile: json["mobile"], 
      email: json["email"], 
      mobilePrefs: json["mobilePrefs"], 
      emailPrefs: json["emailPrefs"], 
      linkedUrl: json["linkedUrl"], 
      designation: json["designation"]
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'colleges': colleges.map((x) => x.toJson()).toList()});
    result.addAll({'mobile': mobile});
    result.addAll({'email': email});
    result.addAll({'mobilePrefs': mobilePrefs});
    result.addAll({'emailPrefs': emailPrefs});
    result.addAll({'linkedUrl': linkedUrl});
    result.addAll({'designation': designation});
  
    return result;
  }


}

class CollegeApprovalModel {
  final int id;
  final String collegeName;
  final String departmentName;
  final String currentOrPoYear;
  final String approvalStatus;
  CollegeApprovalModel({
    required this.id,
    required this.collegeName,
    required this.departmentName,
    required this.currentOrPoYear,
    required this.approvalStatus,
  });



  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'collegeName': collegeName});
    result.addAll({'departmentName': departmentName});
    result.addAll({'currentOrPoYear': currentOrPoYear});
    result.addAll({'approvalStatus': approvalStatus});
  
    return result;
  }

  factory CollegeApprovalModel.fromJson(Map<String, dynamic> json) {
    return CollegeApprovalModel(
      id: json['id']?.toInt() ?? 0,
      collegeName: json['collegeName'] ?? '',
      departmentName: json['departmentName'] ?? '',
      currentOrPoYear: json['currentOrPoYear'] ?? '',
      approvalStatus: json['approvalStatus'] ?? '',
    );
  }

}
