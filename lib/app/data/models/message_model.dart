import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();

class Message {
  String? id;
  String? senderName;
  String? toId;
  String? fromId;
  String msg;
  String? type;
  String? createdAt;
  String? read;

  Message({
    String? id,
    required this.toId,
    required this.senderName,
    required this.fromId,
    required this.msg,
    required this.type,
    required this.createdAt,
    required this.read,
  }) : id = id ?? uuid.v6() ;

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json["id"],
      toId: json["to_id"],
      senderName: json["sender_name"],
      fromId: json["from_id"],
      msg: json["msg"],
      type: json["type"],
      createdAt: json["created_at"],
      read: json["read"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "sender_name": senderName,
      "to_id": toId,
      "from_id": fromId,
      "msg": msg,
      "type": type,
      "created_at": createdAt,
      "read": read,
    };
  }
}
