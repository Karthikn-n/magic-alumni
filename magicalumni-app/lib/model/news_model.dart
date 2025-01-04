class NewsModel {
  final String id;
  final String collegeId;
  final String alumniId;
  final String image;
  final String location;
  final String title;
  final String description;
  final String postedDate;
  final String createdBy;
  final String link;


  NewsModel({
    required this.id,
    required this.image,
    required this.location,
    required this.collegeId,
    required this.alumniId,
    required this.title,
    required this.description,
    required this.postedDate,
    required this.createdBy,
    required this.link,
  });

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      id: map['_id']?? " ",
      image: map['image'] ?? '',
      collegeId: map['college_id'] ?? '',
      alumniId: map['alumni_id'] ?? '', 
      location: map['location'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      postedDate: map['news_posted'] ?? '',
      createdBy: map['creator_name'] ?? '',
      link: map['news_link'] ?? '',
    );
  }
}
