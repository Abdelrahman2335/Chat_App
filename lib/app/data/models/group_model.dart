
import 'package:uuid/uuid.dart';

String id = const Uuid().v6();

class GroupRoom {
  String id;
  String name;
  List? admin;
  List members;
  String? image;
  String createdAt;
  String? lastMessage;
  String? lastMessageTime;

  GroupRoom({
    String? id,
    required this.name,
    required this.admin,
    required this.createdAt,
    required this.members,
    required this.image,
    required this.lastMessage,
    required this.lastMessageTime,
  }): id = id ?? const Uuid().v6();

  factory GroupRoom.fromJson(Map<String, dynamic> json) {
    return GroupRoom(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      createdAt: json["created_at"],
      members: json["members"] ?? [],
      admin: json["admin"] ?? [],
      image: json["image"] ?? "",
      lastMessage: json["lastMessage"] ?? "",
      lastMessageTime: json["lastMessageTime"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "created_at": createdAt,
      "members": members,
      "admin": admin,
      "image": image,
      "lastMessage": lastMessage,
      "lastMessageTime": lastMessageTime,
    };
  }
}
