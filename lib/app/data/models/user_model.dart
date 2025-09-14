
class UserModel {
  String? id;
  String? name;
  String? email;
  String? about;
  String? image;
  String? createdAt;
  String? lastSeen;
  String? pushToken;
  bool? online;
  List? myUsers;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.about,
    required this.image,
    required this.createdAt,
    required this.lastSeen,
    required this.pushToken,
    required this.online,
    required this.myUsers,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json["id"] ?? "",
        name: json["name"],
        email: json["email"],
        about: json["about"],
        image: json["image"],
        createdAt: json["created_at"],
        lastSeen: json["last_seen"],
        pushToken: json["push_token"],
      online: json["online"],
      myUsers: json["my_users"],
    );
  }

  Map<String, dynamic> toJson() {
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
      "my_users": myUsers,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? about,
    String? image,
    String? createdAt,
    String? lastSeen,
    String? pushToken,
    bool? online,
    List? myUsers,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      about: about ?? this.about,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      lastSeen: lastSeen ?? this.lastSeen,
      pushToken: pushToken ?? this.pushToken,
      online: online ?? this.online,
      myUsers: myUsers ?? this.myUsers,
    );
  }
}
