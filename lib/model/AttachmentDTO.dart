class AttachmentDTO {
  final String id;
  final String fileName;
  final String fileUrl;

  AttachmentDTO({

    required this.id,
    required this.fileName,
    required this.fileUrl,
  });

  factory AttachmentDTO.fromJson(Map<String, dynamic> json) {
    return AttachmentDTO(
      id: json['id'],
      fileName: json['fileName'],
      fileUrl: json['fileUrl'],
    );
  }
}