import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String senderPhotoUrl;
  final String receiverId;
  final String text;
  final bool isRead;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.senderPhotoUrl,
    required this.receiverId,
    required this.text,
    required this.isRead,
    required this.createdAt,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map, String docId) {
    return MessageModel(
      id: docId,
      conversationId: map['conversationId'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      senderPhotoUrl: map['senderPhotoUrl'] ?? '',
      receiverId: map['receiverId'] ?? '',
      text: map['text'] ?? '',
      isRead: map['isRead'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory MessageModel.fromFirebase(DocumentSnapshot doc) {
    return MessageModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'conversationId': conversationId,
      'senderId': senderId,
      'senderName': senderName,
      'senderPhotoUrl': senderPhotoUrl,
      'receiverId': receiverId,
      'text': text,
      'isRead': isRead,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  MessageModel copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? senderName,
    String? senderPhotoUrl,
    String? receiverId,
    String? text,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return MessageModel(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderPhotoUrl: senderPhotoUrl ?? this.senderPhotoUrl,
      receiverId: receiverId ?? this.receiverId,
      text: text ?? this.text,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ConversationModel {
  final String id;
  final String userId1;
  final String userId1Name;
  final String userId1Photo;
  final String userId2;
  final String userId2Name;
  final String userId2Photo;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  ConversationModel({
    required this.id,
    required this.userId1,
    required this.userId1Name,
    required this.userId1Photo,
    required this.userId2,
    required this.userId2Name,
    required this.userId2Photo,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });

  factory ConversationModel.fromMap(Map<String, dynamic> map, String docId) {
    return ConversationModel(
      id: docId,
      userId1: map['userId1'] ?? '',
      userId1Name: map['userId1Name'] ?? '',
      userId1Photo: map['userId1Photo'] ?? '',
      userId2: map['userId2'] ?? '',
      userId2Name: map['userId2Name'] ?? '',
      userId2Photo: map['userId2Photo'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: (map['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      unreadCount: map['unreadCount'] ?? 0,
    );
  }

  factory ConversationModel.fromFirebase(DocumentSnapshot doc) {
    return ConversationModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'userId1': userId1,
      'userId1Name': userId1Name,
      'userId1Photo': userId1Photo,
      'userId2': userId2,
      'userId2Name': userId2Name,
      'userId2Photo': userId2Photo,
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'unreadCount': unreadCount,
    };
  }

  ConversationModel copyWith({
    String? id,
    String? userId1,
    String? userId1Name,
    String? userId1Photo,
    String? userId2,
    String? userId2Name,
    String? userId2Photo,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      userId1: userId1 ?? this.userId1,
      userId1Name: userId1Name ?? this.userId1Name,
      userId1Photo: userId1Photo ?? this.userId1Photo,
      userId2: userId2 ?? this.userId2,
      userId2Name: userId2Name ?? this.userId2Name,
      userId2Photo: userId2Photo ?? this.userId2Photo,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
