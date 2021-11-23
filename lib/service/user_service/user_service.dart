import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:XLINXCHAT/model/ContactList.dart';
import 'package:XLINXCHAT/model/user_model.dart';
import 'package:XLINXCHAT/service/auth_service/auth_service.dart';
import 'package:XLINXCHAT/utils/app.dart';
import 'package:XLINXCHAT/utils/exception.dart';
import 'package:XLINXCHAT/utils/collections.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  CollectionReference users =
      FirebaseFirestore.instance.collection(Collections.users);

  Future<void> createUser(UserModel userModel) async {
    try {
      await users.doc(userModel.uid).set(userModel.toMap());
    } catch (e) {
      handleException(e);
      throw e;
    }
  }

  Stream<QuerySnapshot> getUsersStream() {
    try {
      return users
          .where("uid", isNotEqualTo: firebaseAuth.currentUser.uid)
          .snapshots();
    } catch (e) {
      handleException(e);
      throw e;
    }
  }

  CombineLatestStream<QuerySnapshot, List<QuerySnapshot>> roomStream() {
    try {
      Stream<QuerySnapshot> s1 = users
          .where("uid", isNotEqualTo: firebaseAuth.currentUser.uid)
          .snapshots();
      Stream<QuerySnapshot> s2 = groupService.streamGroup();
      return CombineLatestStream.list<QuerySnapshot>([s1, s2]);
    } catch (e) {
      handleException(e);
      throw e;
    }
  }

  Future<DocumentSnapshot> getUser(String uid) async {
    try {
      return await users.doc(uid).get();
    } catch (e) {
      handleException(e);
      throw e;
    }
  }

  Stream<DocumentSnapshot> getUserStream(String uid) {
    try {
      return users.doc(uid).snapshots();
    } catch (e) {
      handleException(e);
      throw e;
    }
  }

    Stream<DocumentSnapshot> getRoomUserStream(
      List<String> membersId, SharedPreferences prefs) {
    try {
      String id = membersId.firstWhere((element) => element != prefs.getString("UserId"));
      return users.doc(id).snapshots();
    } catch (e) {
      handleException(e);
      throw e;
    }
  }

  Future<QuerySnapshot> getUsers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      return await users
          .where("uid", isNotEqualTo: prefs.getString("UserId"))
          .get();
    } catch (e) {
      handleException(e);
      throw e;
    }
  }

  Future<QuerySnapshot> searchUser() async {
    try {
      return await users
          .where("uid", isNotEqualTo: firebaseAuth.currentUser.uid)
          .get();
    } catch (e) {
      handleException(e);
      throw e;
    }
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      await users.doc(uid).update(data);
    } catch (e) {
      handleException(e);
      throw e;
    }
  }

  Future<UserModel> getUserModel(String uid) async {
    try {
      DocumentSnapshot doc = await users.doc(uid).get();
      return UserModel.fromMap(doc.data());
    } catch (e) {
      handleException(e);
      throw e;
    }
  }

  Future<CategoryData> contactList(String uid) async {
    CategoryList categoryList;
    List<CategoryData> categoryDataList = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.https('www.harisangam.com', '/index.php/api/user/test/users');


    Response response = await post(
      url,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    print("CategoryList::$responseBody");
    if (statusCode == 200) {
      return CategoryData.fromMap(jsonDecode(responseBody));
    }
  }
}
