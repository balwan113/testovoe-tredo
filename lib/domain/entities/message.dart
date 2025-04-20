class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String senderName;
  final String text;
  final DateTime timestamp;
  final bool isRead;

  Message({
    required this.id, 
    required this.senderId,
     required this.receiverId, 
     required this.senderName, 
     required this.text, 
     required this.timestamp,
      required this.isRead
      });
  
}