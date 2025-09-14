class NotificationModel {
  String? id;
  String title;
  String body;
  String? roomId;
  String? senderId;
  String? senderName;
  String? senderImage;
  NotificationType type;
  Map<String, dynamic>? data;
  bool? isRead;
  String? image;
  String? clickAction;
  String token;
  String? createdAt;

  NotificationModel({
    this.id,
    required this.title,
    required this.body,
    this.roomId,
    this.senderId,
    this.senderName,
    this.senderImage,
    required this.type,
    this.data,
    this.isRead,
    this.image,
    this.clickAction,
    required this.token,
    this.createdAt,
  });

  // Convert from JSON (from Firestore or API)
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      roomId: json['room_id'],
      senderId: json['sender_id'],
      senderName: json['sender_name'],
      senderImage: json['sender_image'],
      type: NotificationType.fromString(json['type'] ?? 'message'),
      data:
          json['data'] != null ? Map<String, dynamic>.from(json['data']) : null,
      isRead: json['is_read'],
      image: json['image'],
      clickAction: json['click_action'],
      token: json['token'] ?? '',
      createdAt: json['created_at'],
    );
  }

  // Convert to JSON (for Firestore or API)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'body': body,
      if (roomId != null) 'room_id': roomId,
      if (senderId != null) 'sender_id': senderId,
      if (senderName != null) 'sender_name': senderName,
      if (senderImage != null) 'sender_image': senderImage,
      'type': type.value,
      if (data != null) 'data': data,
      if (isRead != null) 'is_read': isRead,
      'token': token,
      if (image != null) 'image': image,
      if (clickAction != null) 'click_action': clickAction,
      if (createdAt != null) 'created_at': createdAt,
    };
  }

  // Copy with method for updating properties
  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? roomId,
    String? senderId,
    String? senderName,
    String? senderImage,
    NotificationType? type,
    Map<String, dynamic>? data,
    bool? isRead,
    String? image,
    String? clickAction,
    String? token,
    String? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      roomId: roomId ?? this.roomId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderImage: senderImage ?? this.senderImage,
      type: type ?? this.type,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      image: image ?? this.image,
      clickAction: clickAction ?? this.clickAction,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// Notification types enum
enum NotificationType {
  message('message', 'CHAT_MESSAGE'),
  groupInvite('group_invite', 'GROUP_INVITE'),
  friendRequest('friend_request', 'FRIEND_REQUEST'),
  system('system', 'SYSTEM');

  const NotificationType(this.value, this.apnsCategory);

  final String value;
  final String apnsCategory;

  static NotificationType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'message':
        return NotificationType.message;
      case 'group_invite':
        return NotificationType.groupInvite;
      case 'friend_request':
        return NotificationType.friendRequest;
      case 'system':
        return NotificationType.system;
      default:
        return NotificationType.message;
    }
  }
}
