import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DatabaseMethods {
  final firestore = FirebaseFirestore.instance;

  getUserbyusername(String username, String type) async {
    return await FirebaseFirestore.instance
        .collection(type == "startup" ? "startups" : "investors")
        .where("Name", isEqualTo: username)
        .get();
  }

  getUserTokenbyEmail(String email, String type) async {
    return await FirebaseFirestore.instance
        .collection(type == "startup" ? "investors" : "startups")
        .where("email", isEqualTo: email)
        .get()
        .then((value) {
      return value.docs.first['token'];
    });
  }

  Future addInvestor(info) async {
    await firestore.collection('investors').add(info);
  }

  Future addStartup(info) async {
    await firestore.collection('startups').add(info);
  }

  Future updateInvestorWithToken(token, email, type) async {
    final v = await FirebaseFirestore.instance
        .collection(type == "investor" ? "investors" : "startups")
        .get();
    for (var element in v.docs) {
      if (element.data()['email'] == email) {
        FirebaseFirestore.instance
            .collection(type == "investor" ? "investors" : "startups")
            .doc(element.id)
            .update({"token": token});
        return;
      }
    }
  }

  Future uploadLogo(BuildContext context,
      {PlatformFile? image, String? email, String? type}) async {
    final path = "$type/${email}_photo";
    final file = File(image?.path ?? '');

    final ref = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask = ref.putFile(file);
    await uploadTask.whenComplete(() => {});
  }

  Future<Map<String, String>> getAllLogos(String type) async {
    Map<String, String> downloadUrls = {};
    await FirebaseStorage.instance.ref(type).listAll().then((value) async {
      for (var element in value.items) {
        await element.getDownloadURL().then((value1) {
          downloadUrls.addEntries({MapEntry(element.name, value1)});
        });
      }
    });
    return downloadUrls;
  }

  Future<List<Map<String, dynamic>>> getAllInvestors() {
    return firestore
        .collection('investors')
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
  }

  Future<List<Map<String, dynamic>>> getAllStartups() {
    return firestore
        .collection('startups')
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
  }

  createChatroom(String? roomid, chatroomMap, BuildContext context) {
    FirebaseFirestore.instance
        .collection("chatroom")
        .doc(roomid)
        .set(chatroomMap)
        .catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    });
  }

  addConversationMsg(String chatroomid, messagemap) {
    FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatroomid)
        .collection("chats")
        .add(messagemap);
  }

  getConversationMsg(String chatroomid) async {
    return FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatroomid)
        .collection("chats")
        .orderBy("timeOrder")
        .snapshots();
  }

  getChatRoom(String? username) async {
    return FirebaseFirestore.instance
        .collection("chatroom")
        .where("users", arrayContains: username)
        .snapshots();
  }
}
