class EventsModel {
  final String id;
  final String alumniId;
  final String collegeId;
  final String title;
  final String image;
  final String description;
  final String eventDate;
  final String eventType;
  final String criteria;
  final String createdBy;
  final String location;
  final String approvalStatus;
  final List<String> revpOptions;
  EventsModel({
    required this.id,
    required this.title,
    required this.alumniId,
    required this.collegeId,
    required this.description,
    required this.image,
    required this.eventDate,
    required this.eventType,
    required this.criteria,
    required this.createdBy,
    required this.location,
    required this.approvalStatus,
    required this.revpOptions,
  });


  factory EventsModel.fromMap(Map<String, dynamic> map) {
    return EventsModel(
      id: map['_id'] ?? '',
      alumniId: map['alumni_id'] ?? '',
      collegeId: map['college_id'] ?? '',
      title: map['event_title'] ?? '',
      image: map['event_image'] ?? '',
      description: map['description'] ?? '',
      eventDate: map['date'] ?? '',
      eventType: map['event_type'] ?? '',
      criteria: map['criteria'] ?? '',
      createdBy: map['created_by'] ?? '',
      location: map['location'] ?? '',
      approvalStatus: map['approval_status'] ?? '',
      revpOptions: List<String>.from(map['rsvp_options']),
    );
  }

}

