
class ChatRoom {
  String? id;
  List? members;
  String? lastMessage;
  String? lastMessageTime;
  String? createdAt;

  ChatRoom({
    required this.id,
    required this.createdAt,
    required this.members,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  factory ChatRoom.fromjson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json["id"] ?? "",
      createdAt: json["created_at"],
      members: json["members"] ?? [],
      lastMessage: json["lastMessage"] ?? "",
      lastMessageTime: json["lastMessageTime"] ?? "",
    );
  }

  Map<String, dynamic> tojson() {
    return {
      "id": id,
      "created_at": createdAt,
      "members": members,
      "lastMessage": lastMessage,
      "lastMessageTime": lastMessageTime,
    };
  }
}
