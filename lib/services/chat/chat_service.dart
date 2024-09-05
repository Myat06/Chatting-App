import 'package:chatapp/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  // get instance of firestore & auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get all users stream

  /*
    List<Map<String,dynamic> =
    [
    {
      'email': myat@gmail.com,
      'id': ..
    },
    {
      'email': myat@gmail.com,
      'id': ..
    },]
  */

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // go through each individual key
        final user = doc.data();

        //return user
        return user;
      }).toList();
    });
  }

  //get all users stream except blocked users
  Stream<List<Map<String, dynamic>>> getUsersStreamExcludingBlocked() {
    final currentUser = _auth.currentUser;

    return _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      //get blocked user ids
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

      //get all users
      final usersSnapshot = await _firestore.collection('users').get();

      //return as stream list, excluding current user and blocked users
      final usersData = await Future.wait(
        usersSnapshot.docs
            .where((doc) =>
                doc.data()['email'] != currentUser.email &&
                !blockedUserIds.contains(doc.id))
            .map((doc) async {
          final userData = doc.data();
          final chatRoomID = [currentUser.uid, doc.id]..sort();
          final unreadMessagesSnapsshot = await _firestore
              .collection("chat_rooms")
              .doc(chatRoomID.join('_'))
              .collection("messages")
              .where('receiverID', isEqualTo: currentUser.uid)
              .where('isRead', isEqualTo: false)
              .get();
          userData['unreadCount'] = unreadMessagesSnapsshot.docs.length;
          return userData;
        }).toList(),
      );
      return usersData;
    });
  }

  //send message
  Future<void> sendMessage(String receiverID, message) async {
    //get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp,
        isRead: false);

    //construct chat room ID for the two users (sorted to ensure uniqueness)
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); // sort the ids (this ensure the chatroom ID is the same for any 2 people)
    String chatRoomID = ids.join('_');

    //add new message to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  //get messages
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    //construct a chatrom ID for the two users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  // mark messages as read
  Future<void> markMessagesAsRead(String receiverId) async {
    //get current user id
    final currentUserID = _auth.currentUser!.uid;

    //get chat room
    List<String> ids = [currentUserID, receiverId];
    ids.sort();
    String chatRoomID = ids.join('_');

    //get unread messages
    final unreadMessagesQuery = _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .where('receiverID', isEqualTo: currentUserID)
        .where('isRead', isEqualTo: false);

    final unreadMessagesSnapshot = await unreadMessagesQuery.get();

    //go through each messages and mark as read
    for (var doc in unreadMessagesSnapshot.docs) {
      await doc.reference.update({'isRead': true});
    }
  }

  //Report user
  Future<void> reportUser(String messageId, String userId) async {
    final currentUser = _auth.currentUser;
    final report = {
      'reportdBy': currentUser!.uid,
      'messageId': messageId,
      'messageOwnerId': userId,
      'timestamp': FieldValue.serverTimestamp()
    };
    await _firestore.collection('Reports').add(report);
  }

  //block user
  Future<void> blockUser(String userId) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(userId)
        .set({});
    notifyListeners();
  }

  //unblock user
  Future<void> unblockUser(String blockedUserId) async {
    final currentUser = _auth.currentUser;

    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(blockedUserId)
        .delete();
    notifyListeners();
  }

  //get blocked users stream
  Stream<List<Map<String, dynamic>>> getBlockedUsersStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      //get list of blocked user ids

      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

      final userDocs = await Future.wait(blockedUserIds
          .map((id) => _firestore.collection('users').doc(id).get()));

      //return as a list
      return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
}
