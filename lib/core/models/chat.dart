class Chat {
  final String id;
  final String message;
  final String shared;
  final String sender;
  final String senderUsername;
  final DateTime sendAt;

  Chat({
    this.id,
    this.message,
    this.shared,
    this.sender,
    this.sendAt,
    this.senderUsername,
  });

  factory Chat.fromMap(Map data, String id) {
    return Chat(
      id: id ?? '',
      message: data['message'] ?? '',
      shared: data['shared'] ?? '',
      sendAt: data['sendAt'] ?? null,
      sender: data['sender'] ?? '',
      senderUsername: data['senderUsername'] ?? '',
    );
  }
}
