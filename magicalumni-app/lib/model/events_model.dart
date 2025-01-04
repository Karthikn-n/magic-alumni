class EventsModel {
  final int id;
  final String title;
  final String description;
  final String eventDate;
  final String eventType;
  final String createdDate;
  final String createdBy;
  final String location;
  final String approvalStatus;
  final List<String> revpOptions;
  EventsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.eventType,
    required this.createdDate,
    required this.createdBy,
    required this.location,
    required this.approvalStatus,
    required this.revpOptions,
  });


  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'description': description});
    result.addAll({'eventDate': eventDate});
    result.addAll({'eventType': eventType});
    result.addAll({'createdDate': createdDate});
    result.addAll({'createdBy': createdBy});
    result.addAll({'location': location});
    result.addAll({'approvalStatus': approvalStatus});
    result.addAll({'revpOptions': revpOptions});
  
    return result;
  }

  factory EventsModel.fromMap(Map<String, dynamic> map) {
    return EventsModel(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      eventDate: map['event_date'] ?? '',
      eventType: map['event_type'] ?? '',
      createdDate: map['created_date'] ?? '',
      createdBy: map['created_by'] ?? '',
      location: map['event_location'] ?? '',
      approvalStatus: map['approval_status'] ?? '',
      revpOptions: List<String>.from(map['revp_options']),
    );
  }

}

