import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/message_model.dart';

class MessageService {
  static final MessageService _instance = MessageService._internal();

  factory MessageService() {
    return _instance;
  }

  MessageService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _uuid = Uuid();

  /// Generate conversation ID from two user IDs (consistent ordering)
  String _generateConversationId(String userId1, String userId2) {
    final ids = [userId1, userId2];
    ids.sort();
    return '${ids[0]}_${ids[1]}';
  }

  /// Send a message
  Future<MessageModel> sendMessage({
    required String senderId,
    required String senderName,
    required String senderPhotoUrl,
    required String receiverId,
    required String receiverName,
    required String receiverPhotoUrl,
    required String text,
  }) async {
    try {
      final messageId = _uuid.v4();
      final now = DateTime.now();
      final conversationId = _generateConversationId(senderId, receiverId);

      final messageData = MessageModel(
        id: messageId,
        conversationId: conversationId,
        senderId: senderId,
        senderName: senderName,
        senderPhotoUrl: senderPhotoUrl,
        receiverId: receiverId,
        text: text,
        isRead: false,
        createdAt: now,
      );

      // Save message
      await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .doc(messageId)
          .set(messageData.toMap());

      // Update or create conversation
      await _firestore
          .collection('conversations')
          .doc(conversationId)
          .set({
        'userId1': senderId,
        'userId1Name': senderName,
        'userId1Photo': senderPhotoUrl,
        'userId2': receiverId,
        'userId2Name': receiverName,
        'userId2Photo': receiverPhotoUrl,
        'lastMessage': text,
        'lastMessageTime': Timestamp.now(),
        'unreadCount': FieldValue.increment(1),
      }, SetOptions(merge: true));

      return messageData;
    } catch (e) {
      throw Exception('خطا در ارسال پیام: $e');
    }
  }

  /// Get conversations stream for a user
  Stream<List<ConversationModel>> getUserConversationsStream(String userId) {
    try {
      return _firestore
          .collection('conversations')
          .where('userId1', isEqualTo: userId)
          .orderBy('lastMessageTime', descending: true)
          .snapshots()
          .asyncMap((snapshot1) async {
        final conversations1 = snapshot1.docs
            .map((doc) => ConversationModel.fromFirebase(doc))
            .toList();

        // Also get conversations where user is userId2
        final snapshot2 = await _firestore
            .collection('conversations')
            .where('userId2', isEqualTo: userId)
            .orderBy('lastMessageTime', descending: true)
            .get();

        final conversations2 = snapshot2.docs
            .map((doc) => ConversationModel.fromFirebase(doc))
            .toList();

        // Merge and sort by timestamp
        final allConversations = [...conversations1, ...conversations2];
        allConversations.sort((a, b) =>
            b.lastMessageTime.compareTo(a.lastMessageTime));

        return allConversations;
      });
    } catch (e) {
      throw Exception('خطا در دریافت محادثات: $e');
    }
  }

  /// Get messages in a conversation
  Stream<List<MessageModel>> getConversationMessagesStream(
    String conversationId, {
    int limit = 50,
  }) {
    try {
      return _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => MessageModel.fromFirebase(doc))
            .toList();
      });
    } catch (e) {
      throw Exception('خطا در دریافت پیام‌ها: $e');
    }
  }

  /// Mark message as read
  Future<void> markMessageAsRead({
    required String conversationId,
    required String messageId,
  }) async {
    try {
      await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .doc(messageId)
          .update({'isRead': true});
    } catch (e) {
      throw Exception('خطا در بروز‌رسانی وضعیت پیام: $e');
    }
  }

  /// Mark all messages as read
  Future<void> markAllMessagesAsRead({
    required String conversationId,
    required String userId,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .where('receiverId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.update({'isRead': true});
      }

      // Reset unread count
      await _firestore
          .collection('conversations')
          .doc(conversationId)
          .update({'unreadCount': 0});
    } catch (e) {
      throw Exception('خطا در بروز‌رسانی وضعیت پیام‌ها: $e');
    }
  }

  /// Delete a message
  Future<void> deleteMessage({
    required String conversationId,
    required String messageId,
  }) async {
    try {
      await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .doc(messageId)
          .delete();
    } catch (e) {
      throw Exception('خطا در حذف پیام: $e');
    }
  }

  /// Get unread message count for user
  Future<int> getUnreadMessageCount(String userId) async {
    try {
      // Get all conversations for user
      final snapshot = await _firestore
          .collection('conversations')
          .where('userId2', isEqualTo: userId)
          .get();

      int totalUnread = 0;
      for (var doc in snapshot.docs) {
        totalUnread += (doc['unreadCount'] as int?) ?? 0;
      }

      return totalUnread;
    } catch (e) {
      throw Exception('خطا در دریافت تعداد پیام‌های خوانده‌نشده: $e');
    }
  }
}
