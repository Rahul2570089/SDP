import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DatabaseMethods {
  final firestore = FirebaseFirestore.instance;

  Future addInvestor(info) async {
    await firestore.collection('investors').add(info);
  }

  Future addStartup(info) async {
    await firestore.collection('startups').add(info);
  }

  Future uploadLogo(BuildContext context ,{PlatformFile? image, String? email, String? type}) async {
    final path = "$type/$email/${image?.name}";
    final file = File(image?.path ?? '');

    final ref = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask = ref.putFile(file);
    await uploadTask.whenComplete(() => {});
  }
} 