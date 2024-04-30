
class ChatUser {
  String? id;
  String? name;
  String? email;
  String? about;
  String? image;
  String? createdAt;
  String? lastSeen;
  String? pushToken;
  bool? online;

  ChatUser({
    required this.id,
    required this.name,
    required this.email,
    required this.about,
    required this.image,
    required this.createdAt,
    required this.lastSeen,
    required this.pushToken,
    required this.online,
  });

  factory ChatUser.fromjson(Map<String, dynamic> json) {
    return ChatUser(
        id: json["id"] ?? "",
        name: json["name"],
        email: json["email"],
        about: json["about"],
        image: json["image"],
        createdAt: json["created_at"],
        lastSeen: json["last_seen"],
        pushToken: json["push_token"],
        online: json["online"]);
  }

  Map<String, dynamic> tojson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "about": about,
      "image": image,
      "created_at": createdAt,
      "last_seen": lastSeen,
      "push_token": pushToken,
      "online": online,
    };
  }
}
