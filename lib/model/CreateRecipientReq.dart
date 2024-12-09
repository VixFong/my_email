class CreateRecipientReq {
  final String userId; // email of the recipient
  final String type; // "TO", "CC", or "BCC"

  CreateRecipientReq({
    required this.userId,
    required this.type,
  });
  @override
  String toString() {
    return 'CreateRecipientReq(userId: $userId, type: $type)';
  }

  // Convert a CreateRecipientReq to a Map (for sending as JSON)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
    };
  }

  // Create a CreateRecipientReq from a Map (for parsing from JSON)
  factory CreateRecipientReq.fromMap(Map<String, dynamic> map) {
    return CreateRecipientReq(
      userId: map['userId'],
      type: map['type'],
    );
  }
}
