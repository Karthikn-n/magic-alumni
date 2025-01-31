class NotificationsModel {
  final int id;
  final String title;
  final String content;
  final String date;
  final String? requestId;
  final String type;
  final String message;
  final String? eventId;
  final String? status;
  final String? createdAt;
  NotificationsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.type,
    required this.message,
    this.eventId,
    this.requestId,
    this.status,
    this.createdAt,
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
    result.addAll({"status": status});
    result.addAll({"message": message});
    result.addAll({"created_at": createdAt});
    return result;
  }

  factory NotificationsModel.fromJson(Map<String, dynamic> map) {
    return NotificationsModel(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      date: map['date'] ?? "",
      type: map['type'] ?? "",
      requestId: map["data"]["request_id"] ?? "",
      eventId: map["data"]["event_id"] ?? "",
      status: map["status"] ?? "",
      message: map["message"] ?? "",
      createdAt: map["created_at"] ?? ""
    );
  }
}
