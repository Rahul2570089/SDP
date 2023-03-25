import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DatabaseMethods {
  final firestore = FirebaseFirestore.instance;

  Future getUserbyemail(String email, String type) async {
    return await firestore
        .collection("${type}s")
        .where("email", isEqualTo: email)
        .get();
  }

  Future getUserTokenbyEmail(String email, String type) async {
    return await firestore
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
    final v = await firestore
        .collection(type == "investor" ? "investors" : "startups")
        .get();
    for (var element in v.docs) {
      if (element.data()['email'] == email) {
        firestore
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
    firestore
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
    firestore
        .collection("chatroom")
        .doc(chatroomid)
        .collection("chats")
        .add(messagemap);
  }

  Future getConversationMsg(String chatroomid) async {
    return firestore
        .collection("chatroom")
        .doc(chatroomid)
        .collection("chats")
        .orderBy("timeOrder")
        .snapshots();
  }

  Future getChatRoom(String? username) async {
    return firestore
        .collection("chatroom")
        .where("users", arrayContains: username)
        .snapshots();
  }

  addFriendRequest(String type, BuildContext context,
      {required String currentName,
      required String name,
      required String currentEmail,
      required String email,
      required String amount,
      required String message}) async {
    if (type == "investor") {
      await firestore
          .collection("investors")
          .where("email", isEqualTo: currentEmail)
          .get()
          .then((value) async {
        final v = await firestore
            .collection("investors")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .where("email", isEqualTo: email)
            .get();

        if (v.docs.isNotEmpty) {
          if (v.docs.first['status'] == "pending") {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Request already sent"),
                ),
              );
              return;
            }
          }
          return;
        }

        firestore
            .collection("investors")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .add({
          "name": name,
          "email": email,
          "amount": amount,
          "message": message,
          "sender": currentEmail,
          "status": "pending"
        });
      });

      await firestore
          .collection("startups")
          .where("email", isEqualTo: email)
          .get()
          .then((value) {
        firestore
            .collection("startups")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .add({
          "name": currentName,
          "email": currentEmail,
          "amount": amount,
          "message": message,
          "sender": currentEmail,
          "status": "pending"
        });
      });
    } else {
      await firestore
          .collection("startups")
          .where("email", isEqualTo: currentEmail)
          .get()
          .then((value) async {
        final v = await firestore
            .collection("startups")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .where("email", isEqualTo: email)
            .get();

        if (v.docs.isNotEmpty) {
          if (v.docs.first['status'] == "pending") {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Request already sent"),
                ),
              );
              return;
            }
          }
          return;
        }

        firestore
            .collection("startups")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .add({
          "name": name,
          "email": email,
          "amount": amount,
          "message": message,
          "sender": currentEmail,
          "status": "pending"
        });
      });

      await firestore
          .collection("investors")
          .where("email", isEqualTo: email)
          .get()
          .then((value) {
        firestore
            .collection("investors")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .add({
          "name": currentName,
          "email": currentEmail,
          "amount": amount,
          "message": message,
          "sender": currentEmail,
          "status": "pending"
        });
      });
    }
  }

  Future getFriendRequests(String type, String email) async {
    if (type == "investor") {
      final v = await firestore
          .collection("investors")
          .where("email", isEqualTo: email)
          .get();
      return firestore
          .collection("investors")
          .doc(v.docs.first.id)
          .collection("friendlist")
          .where("status", isEqualTo: "pending")
          .snapshots();
    } else {
      final v = await firestore
          .collection("startups")
          .where("email", isEqualTo: email)
          .get();
      return firestore
          .collection("startups")
          .doc(v.docs.first.id)
          .collection("friendlist")
          .where("status", isEqualTo: "pending")
          .snapshots();
    }
  }

  withdrawRequest(
    String type, {
    required String currentEmail,
    required String email,
  }) async {
    if (type == "investor") {
      await firestore
          .collection("investors")
          .where("email", isEqualTo: currentEmail)
          .get()
          .then((value) async {
        final v = await firestore
            .collection("investors")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .where("email", isEqualTo: email)
            .get();
        firestore
            .collection("investors")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .doc(v.docs.first.id)
            .delete();
      });

      await firestore
          .collection("startups")
          .where("email", isEqualTo: email)
          .get()
          .then((value) async {
        final v = await firestore
            .collection("startups")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .where("email", isEqualTo: currentEmail)
            .get();
        firestore
            .collection("startups")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .doc(v.docs.first.id)
            .delete();
      });
    } else {
      await firestore
          .collection("startups")
          .where("email", isEqualTo: currentEmail)
          .get()
          .then((value) async {
        final v = await firestore
            .collection("startups")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .where("email", isEqualTo: email)
            .get();
        firestore
            .collection("startups")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .doc(v.docs.first.id)
            .delete();
      });

      await firestore
          .collection("investors")
          .where("email", isEqualTo: email)
          .get()
          .then((value) async {
        final v = await firestore
            .collection("investors")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .where("email", isEqualTo: currentEmail)
            .get();
        firestore
            .collection("investors")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .doc(v.docs.first.id)
            .delete();
      });
    }
  }

  acceptRequest(String type,
      {required String currentEmail, required String email}) async {
    if (type == "investor") {
      await firestore
          .collection("investors")
          .where("email", isEqualTo: currentEmail)
          .get()
          .then((value) async {
        final v = await firestore
            .collection("investors")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .where("email", isEqualTo: email)
            .get();
        firestore
            .collection("investors")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .doc(v.docs.first.id)
            .update({"status": "accepted"});
      });

      await firestore
          .collection("startups")
          .where("email", isEqualTo: email)
          .get()
          .then((value) async {
        final v = await firestore
            .collection("startups")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .where("email", isEqualTo: currentEmail)
            .get();
        firestore
            .collection("startups")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .doc(v.docs.first.id)
            .update({"status": "accepted"});
      });
    } else {
      await firestore
          .collection("startups")
          .where("email", isEqualTo: currentEmail)
          .get()
          .then((value) async {
        final v = await firestore
            .collection("startups")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .where("email", isEqualTo: email)
            .get();
        firestore
            .collection("startups")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .doc(v.docs.first.id)
            .update({"status": "accepted"});
      });

      await firestore
          .collection("investors")
          .where("email", isEqualTo: email)
          .get()
          .then((value) async {
        final v = await firestore
            .collection("investors")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .where("email", isEqualTo: currentEmail)
            .get();
        firestore
            .collection("investors")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .doc(v.docs.first.id)
            .update({"status": "accepted"});
      });
    }
  }

  rejectRequest(String type,
      {required String currentEmail, required String email}) async {
    if (type == "investor") {
      await firestore
          .collection("investors")
          .where("email", isEqualTo: currentEmail)
          .get()
          .then((value) async {
        final v = await firestore
            .collection("investors")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .where("email", isEqualTo: email)
            .get();
        firestore
            .collection("investors")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .doc(v.docs.first.id)
            .update({"status": "rejected"});
      });

      await firestore
          .collection("startups")
          .where("email", isEqualTo: email)
          .get()
          .then((value) async {
        final v = await firestore
            .collection("startups")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .where("email", isEqualTo: currentEmail)
            .get();
        firestore
            .collection("startups")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .doc(v.docs.first.id)
            .update({"status": "rejected"});
      });
    } else {
      await firestore
          .collection("startups")
          .where("email", isEqualTo: currentEmail)
          .get()
          .then((value) async {
        final v = await firestore
            .collection("startups")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .where("email", isEqualTo: email)
            .get();
        firestore
            .collection("startups")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .doc(v.docs.first.id)
            .update({"status": "rejected"});
      });

      await firestore
          .collection("investors")
          .where("email", isEqualTo: email)
          .get()
          .then((value) async {
        final v = await firestore
            .collection("investors")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .where("email", isEqualTo: currentEmail)
            .get();
        firestore
            .collection("investors")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .doc(v.docs.first.id)
            .update({"status": "rejected"});
      });
    }
  }

  Future getFriends(String type, String email) async {
    if (type == "investor") {
      final v = await firestore
          .collection("investors")
          .where("email", isEqualTo: email)
          .get();
      return firestore
          .collection("investors")
          .doc(v.docs.first.id)
          .collection("friendlist")
          .where("status", isEqualTo: "accepted")
          .snapshots();
    } else {
      final v = await firestore
          .collection("startups")
          .where("email", isEqualTo: email)
          .get();
      return firestore
          .collection("startups")
          .doc(v.docs.first.id)
          .collection("friendlist")
          .where("status", isEqualTo: "accepted")
          .snapshots();
    }
  }

  Future<bool> isFriend(String type,
      {required String currentEmail, required String email}) async {
    if (type == "investor") {
      final v = await firestore
          .collection("investors")
          .where("email", isEqualTo: currentEmail)
          .get();

      final v1 = await firestore
          .collection("investors")
          .doc(v.docs.first.id)
          .collection("friendlist")
          .where("email", isEqualTo: email)
          .get();

      if (v1.docs.isNotEmpty && v1.docs.first['status'] == "accepted") {
        return true;
      } else {
        return false;
      }
    } else {
      final v = await firestore
          .collection("startups")
          .where("email", isEqualTo: currentEmail)
          .get();
      final v1 = await firestore
          .collection("startups")
          .doc(v.docs.first.id)
          .collection("friendlist")
          .where("email", isEqualTo: email)
          .get();

      if (v1.docs.isNotEmpty && v1.docs.first['status'] == "accepted") {
        return true;
      } else {
        return false;
      }
    }
  }

  updateAbout(
      {required String type,
      required String email,
      required String newContent}) {
    if (type == "investor") {
      firestore
          .collection("investors")
          .where("email", isEqualTo: email)
          .get()
          .then((value) async {
        firestore
            .collection("investors")
            .doc(value.docs.first.id)
            .update({"about": newContent});
      });
    } else {
      firestore
          .collection("startups")
          .where("email", isEqualTo: email)
          .get()
          .then((value) async {
        firestore
            .collection("startups")
            .doc(value.docs.first.id)
            .update({"description": newContent});
      });
    }
  }

  updateSector(
      {required String type,
      required String email,
      required String newSector}) {
    if (type == "investor") {
      firestore
          .collection("investors")
          .where("email", isEqualTo: email)
          .get()
          .then((value) async {
        firestore
            .collection("investors")
            .doc(value.docs.first.id)
            .update({"investmentsector": newSector});
      });
    } else {
      firestore
          .collection("startups")
          .where("email", isEqualTo: email)
          .get()
          .then((value) async {
        firestore
            .collection("startups")
            .doc(value.docs.first.id)
            .update({"sector": newSector});
      });
    }
  }

  updateHeadquarters({required String email, required String newHeadquarters}) {
    firestore
        .collection("startups")
        .where("email", isEqualTo: email)
        .get()
        .then((value) async {
      firestore
          .collection("startups")
          .doc(value.docs.first.id)
          .update({"headquarters": newHeadquarters});
    });
  }

  addExperience(
      {required String email,
      required String title,
      required String company,
      required String description}) {
    firestore
        .collection("investors")
        .where("email", isEqualTo: email)
        .get()
        .then((value) async {
      firestore.collection("investors").doc(value.docs.first.id).update({
        "companytitle": title,
        "companyname": company,
        "aboutcompany": description,
      });
    });
  }

  removeStartupAsFriend({required String email, required String currentEmail}) {
    firestore
        .collection("startups")
        .where("email", isEqualTo: currentEmail)
        .get()
        .then((value) async {
      firestore
          .collection("startups")
          .doc(value.docs.first.id)
          .collection("friendlist")
          .where("email", isEqualTo: email)
          .get()
          .then((value2) async {
        firestore
            .collection("startups")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .doc(value2.docs.first.id)
            .delete();
      });
    });

    firestore
        .collection("investors")
        .where("email", isEqualTo: email)
        .get()
        .then((value) async {
      firestore
          .collection("investors")
          .doc(value.docs.first.id)
          .collection("friendlist")
          .where("email", isEqualTo: currentEmail)
          .get()
          .then((value2) async {
        firestore
            .collection("investors")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .doc(value2.docs.first.id)
            .delete();
      });
    });
  }

  removeInvestorAsFriend(
      {required String email, required String currentEmail}) {
    firestore
        .collection("investors")
        .where("email", isEqualTo: currentEmail)
        .get()
        .then((value) async {
      firestore
          .collection("investors")
          .doc(value.docs.first.id)
          .collection("friendlist")
          .where("email", isEqualTo: email)
          .get()
          .then((value2) async {
        firestore
            .collection("investors")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .doc(value2.docs.first.id)
            .delete();
      });
    });

    firestore
        .collection("startups")
        .where("email", isEqualTo: email)
        .get()
        .then((value) async {
      firestore
          .collection("startups")
          .doc(value.docs.first.id)
          .collection("friendlist")
          .where("email", isEqualTo: currentEmail)
          .get()
          .then((value2) async {
        firestore
            .collection("startups")
            .doc(value.docs.first.id)
            .collection("friendlist")
            .doc(value2.docs.first.id)
            .delete();
      });
    });
  }
}
