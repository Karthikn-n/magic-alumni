class NotificationsModel {
  final int id;
  final String title;
  final String description;
  final String date;
  final Map<String, dynamic> data;
  NotificationsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'description': description});
    result.addAll({'date': date});
    result.addAll({'data': data});
  
    return result;
  }

  factory NotificationsModel.fromJson(Map<String, dynamic> map) {
    return NotificationsModel(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: map['date'] ?? '',
      data: Map<String, dynamic>.from(map['data']),
    );
  }
}
