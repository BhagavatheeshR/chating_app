enum MessageType { text, image, file, audio }

class Message {
  final String id;
  final String
  senderId; // Make sure this property exists and is spelled correctly
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final bool isRead;
  final MessageType type;

  Message({
    required this.id,
    required this.senderId, // This must match the property name used in MessageBubble
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.isRead = false,
    this.type = MessageType.text,
  });
}
