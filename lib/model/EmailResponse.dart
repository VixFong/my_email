import 'package:final_essays/model/AttachmentDTO.dart';

class EmailResponse {
  final String id;
  final String senderName;
  final String senderEmail;
  final String subject;
  final String body; // Populated in detailed view
  final String preview; // Short snippet of body for basic view
  final DateTime createdAt;
  final bool isRead;
  bool isStarred;
  final String folder;
  final List<String>? labels;
  final List<AttachmentDTO>? attachments;

  EmailResponse({
    required this.id,
    required this.senderName,
    required this.senderEmail,
    required this.subject,
    required this.body,
    required this.preview,
    required this.createdAt,
    required this.isRead,
    this.isStarred = false,
    required this.folder,
    this.labels,
    this.attachments,
  });

  factory EmailResponse.fromJson(Map<String, dynamic> json) {
    return EmailResponse(
      id: json['id'],
      senderName: json['senderName'],
      senderEmail: json['senderEmail'],
      subject: json['subject'],
      body: json['body'] ?? "",
      preview: json['preview'] ?? "",
      createdAt: DateTime.parse(json['createdAt']),
      isRead: json['isRead'] ?? false, // Default to false if null
      isStarred: json['isStarred'] ?? false, // Default to false if null
      folder: json['folder'] ?? "Inbox", // Default to "Inbox" if null
      labels: (json['labels'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => AttachmentDTO.fromJson(e))
              .toList() ??
          [],
    );
  }
}
