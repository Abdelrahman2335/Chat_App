import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();

class Message {
  String? id;
  String? senderName;
  String? receiverId;
  String? senderId;
  String messageContent;
  // make the type enum
  String? type;
  String? createdAt;
  String? read;

  Message({
    String? id,
    required this.receiverId,
    required this.senderName,
    required this.senderId,
    required this.messageContent,
    required this.type,
    required this.createdAt,
    required this.read,
  }) : id = id ?? uuid.v6();

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json["id"],
      receiverId: json["to_id"],
      senderName: json["sender_name"],
      senderId: json["from_id"],
      messageContent: json["msg"],
      type: json["type"],
      createdAt: json["created_at"],
      read: json["read"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "sender_name": senderName,
      "to_id": receiverId,
      "from_id": senderId,
      "msg": messageContent,
      "type": type,
      "created_at": createdAt,
      "read": read,
    };
  }
}
