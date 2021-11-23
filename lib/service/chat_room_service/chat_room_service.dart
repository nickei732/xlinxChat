import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:XLINXCHAT/model/message_model.dart';
import 'package:XLINXCHAT/utils/app_state.dart';
import 'package:XLINXCHAT/utils/exception.dart';
import 'package:XLINXCHAT/utils/collections.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRoomService {
  CollectionReference chatRoom =
      FirebaseFirestore.instance.collection(Collections.chatRoom);

  Future<void> createChatRoom(Map<String, dynamic> data) async {
    try {
      await chatRoom.doc(data['id']).set(data);
    } catch (e) {
      print(e);
      handleException(e);
      throw e;
    }
  }

  Future<void> deleteChatRoom(String chatId) async {
    try {
      await chatRoom.doc(chatId).delete();
      await chatRoom.doc(chatId).collection(chatId).get().then((value) {
        for (DocumentSnapshot ds in value.docs) {
          ds.reference.delete();
        }
      });
    } catch (e) {
      print(e);
      handleException(e);
      throw e;
    }
  }

  Future<void> updateGroupMembers(String chatId, List<String> members) async {
    try {
      await chatRoom.doc(chatId).update({"membersId": members});
    } catch (e) {
      print(e);
      handleException(e);
      throw e;
    }
  }

  Future<void> updateGroupNewMessage(String chatId, String userId) async {
    try {
      await chatRoom.doc(chatId).update({"${userId}_newMessage": 1});
    } catch (e) {
      print(e);
      handleException(e);
      throw e;
    }
  }

  Stream<QuerySnapshot> streamRooms([SharedPreferences prefs]) {
        print("CurrentId::::${prefs.getString("UserId")}");
        try {
          return chatRoom
              .where("membersId", arrayContains:prefs.getString("UserId"))
              .orderBy("lastMessageTime", descending: true)
              .snapshots();
        } catch (e) {
          print(e);
          handleException(e);
          throw e;
      }

  }

  Future<QuerySnapshot> getAllRooms([SharedPreferences prefs]) async {
    try {
      return await chatRoom
          .where("membersId", arrayContains: prefs.getString("UserId"))
          .orderBy("lastMessageTime", descending: true)
          .get();
    } catch (e) {
      print(e);
      handleException(e);
      throw e;
    }
  }

  Stream<QuerySnapshot> getCurrentUserRooms([SharedPreferences prefs]) {
    try {
      return chatRoom
          .where("isGroup", isEqualTo: false)
          .where("membersId", arrayContains: prefs.getString("UserId"))
          .snapshots();
    } catch (e) {
      print(e);
      handleException(e);
      throw e;
    }
  }

  Stream<DocumentSnapshot> streamParticularRoom(String id) {
    try {
      return chatRoom.doc(id).snapshots();
    } catch (e) {
      print(e);
      handleException(e);
      throw e;
    }
  }

  Future<DocumentSnapshot> getParticularRoom(String id) {
    try {
      return chatRoom.doc(id).get();
    } catch (e) {
      print(e);
      handleException(e);
      throw e;
    }
  }

  Query getMessages(
    String chatId,
    int limit,
  ) {
    return chatRoom
        .doc(chatId)
        .collection(chatId)
        .orderBy('sendTime', descending: true);
  }

  Future<void> sendMessage(MessageModel message, String roomId) async {
    await chatRoom.doc(roomId).collection(roomId).add(message.toMap());
  }

  Future<void> updateLastMessage(
      Map<String, dynamic> data, String roomId) async {
    await chatRoom.doc(roomId).get().then((value) {
      if (value.exists) {
        value.reference.update(data);
      }
    });
  }

  Future<void> deleteMessage(String messageId, String roomId) async {
    await chatRoom.doc(roomId).collection(roomId).doc(messageId).delete();
  }

  Future<DocumentSnapshot> isRoomAvailable(String roomId) async {
    return await chatRoom.doc(roomId).get();
  }
}
