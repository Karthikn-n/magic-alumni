import 'package:magic_alumni/model/alumni_model.dart';

class MobileRequestModel{
  final String id;
  final String requestId;
  final AlumniModel sender;
  final String requestedDate; 
  final String status;

  MobileRequestModel({
    required this.id,
    required this.sender,
    required this.status,
    required this.requestId,
    required this.requestedDate,
  });

  factory MobileRequestModel.fromJson(Map<String, dynamic> json) {
    return MobileRequestModel(
      id: json["_id"] ?? "",
      sender: AlumniModel.fromJson(json["sender"] ?? ""),
      status: json["status"] ?? "",
      requestId: json["request_id"] ?? "",
      requestedDate: json["requested_date"] ?? ""
    );
  }
}