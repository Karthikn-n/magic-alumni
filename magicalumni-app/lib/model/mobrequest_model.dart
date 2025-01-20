import 'package:magic_alumni/model/alumni_model.dart';

class MobileRequestModel{
  final String id;
  final String senderId;
  final String receiverId;
  final String requestId;
  final AlumniProfileModel sender;
  final String requestedDate; 
  final String status;

  MobileRequestModel({
    required this.id,
    required this.sender,
    required this.senderId,
    required this.receiverId,
    required this.status,
    required this.requestId,
    required this.requestedDate,
  });

  factory MobileRequestModel.fromJson(Map<String, dynamic> json) {
    return MobileRequestModel(
      id: json["_id"] ?? "",
      senderId: json["sender"] ?? "",
      receiverId: json["receiver"] ?? "",
      sender: AlumniProfileModel.fromJson(json["senderProfile"] ?? ""),
      status: json["status"] ?? "",
      requestId: json["request_id"] ?? "",
      requestedDate: json["createdAt"] ?? ""
    );
  }
}