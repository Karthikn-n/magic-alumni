class JobsModel {
  final int id;
  final String title;
  final String image;
  final String location;
  final String lastDate;
  final String jobType;
  final String applyLink;
  final String email;
  JobsModel({
    required this.id,
    required this.title,
    required this.image,
    required this.location,
    required this.lastDate,
    required this.jobType,
    required this.applyLink,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'image': image});
    result.addAll({'location': location});
    result.addAll({'lastDate': lastDate});
    result.addAll({'jobType': jobType});
    result.addAll({'applyLink': applyLink});
    result.addAll({'email': email});
  
    return result;
  }

  factory JobsModel.fromMap(Map<String, dynamic> map) {
    return JobsModel(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      image: map['image'] ?? '',
      location: map['job_location'] ?? '',
      lastDate: map['last_date'] ?? '',
      jobType: map['job_type'] ?? '',
      applyLink: map['apply_link'] ?? '',
      email: map['email'] ?? '',
    );
  }

}
