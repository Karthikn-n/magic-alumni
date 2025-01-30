class NotificationsModel {
  final int id;
  final String title;
  final String content;
  final String date;
  final String? requestId;
  final String type;
  final String? eventId;
  NotificationsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.type,
    this.eventId,
    this.requestId,
  });

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'content': content});
    result.addAll({'date': date});
    result.addAll({"event_id": eventId});
    result.addAll({'request_id': requestId});
    result.addAll({"type": type});
    return result;
  }

  factory NotificationsModel.fromJson(Map<String, dynamic> map) {
    return NotificationsModel(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      date: map['date'] ?? "",
      type: map['type'] ?? "",
      requestId: map["request_id"] ?? "",
      eventId: map["event_id"] ?? ""
    );
  }
}
