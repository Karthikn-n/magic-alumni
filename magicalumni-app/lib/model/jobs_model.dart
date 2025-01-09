class JobsModel {
  final String id;
  final String alumniId;
  final String collegeId;
  final String title;
  final String companyName;
  final String location;
  final String lastDate;
  final String jobType;
  final List<String> tags;
  final String applyLink;
  final String email;


  JobsModel({
    required this.id,
    required this.title,
    required this.alumniId,
    required this.collegeId,
    required this.location,
    required this.lastDate,
    required this.jobType,
    required this.companyName,
    required this.tags,
    required this.applyLink,
    required this.email,
  });

  factory JobsModel.fromMap(Map<String, dynamic> map) {
    return JobsModel(
      id: map['_id'] ?? "",
      alumniId: map["alumni_id"] ?? "",
      collegeId: map["college_id"] ?? "",
      title: map['job_title'] ?? '',
      companyName: map["company_name"] ?? "",
      location: map['location'] ?? '',
      tags: List<String>.from(map["tag"] ?? []),
      lastDate: map['last_date'] ?? '',
      jobType: map['job_type'] ?? '',
      applyLink: map['job_url'] ?? '',
      email: map['email'] ?? '',
    );
  }

}
