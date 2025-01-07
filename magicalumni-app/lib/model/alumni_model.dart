import 'package:magic_alumni/model/colleges_model.dart';

class AlumniModel {
  final AlumniProfileModel alumniProfileDetail;
  final List<CollegesModel> colleges;
  AlumniModel({
    required this.alumniProfileDetail,
    required this.colleges,
  });

  factory AlumniModel.fromJson(Map<String, dynamic> json){
    return AlumniModel(
      alumniProfileDetail: AlumniProfileModel.fromJson(json['alumniProfileDetail']),
      colleges: (json["colleges"] ?? []).map<CollegesModel>((college) => CollegesModel.fromMap(college)).toList(), 
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'alumniProfileDetail': alumniProfileDetail.toMap()});
    result.addAll({'colleges': colleges.map((x) => x.toMap()).toList()});
  
    return result;
  }


}


class AlumniProfileModel {
  final String id;
  final String name;
  final String mobile;
  final String email;
  final String role;
  final String linkedUrl;
  final String designation;
  AlumniProfileModel({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
    required this.role,
    required this.linkedUrl,
    required this.designation,
  });
  factory AlumniProfileModel.fromJson(Map<String, dynamic> json){
    return AlumniProfileModel(
      id: json["_id"] ?? "", 
      name: json["name"] ?? "", 
      role: json["role"] ?? "",
      mobile: (json["mobile_number"] ?? "").toString(), 
      email: json["email"] ?? "", 
      linkedUrl: json["linkedin_url"] ?? "", 
      designation: json["designation"] ?? ""
    );
  }

  Map<String, dynamic> toMap() {
     return {
      '_id': id,
      'name': name,
      'mobile_number': mobile,
      'role': role,
      'email': email,
      'linkedin_url': linkedUrl,
      'designation': designation,
    };
  }
}
