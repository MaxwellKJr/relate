class Message {
  final String senderId;
  final String senderUserName;
  final String receiverId;
  final String time;
  final String message;

  Message({
    required this.senderId,
    required this.senderUserName,
    required this.receiverId,
    required this.time,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId,
      "senderUserName": senderUserName,
      "recieverId": receiverId,
      "message": message,
      "time": time,
    };
  }
}
