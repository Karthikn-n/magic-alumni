class NewsModel {
  final int id;
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
    required this.title,
    required this.description,
    required this.postedDate,
    required this.createdBy,
    required this.link,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'image': image});
    result.addAll({'location': location});
    result.addAll({'title': title});
    result.addAll({'description': description});
    result.addAll({'postedDate': postedDate});
    result.addAll({'createdBy': createdBy});
    result.addAll({'link': link});
  
    return result;
  }

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      id: map['id']?.toInt() ?? 0,
      image: map['image'] ?? '',
      location: map['location'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      postedDate: map['posted_date'] ?? '',
      createdBy: map['created_by'] ?? '',
      link: map['link'] ?? '',
    );
  }
}
