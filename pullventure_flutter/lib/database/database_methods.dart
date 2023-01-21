import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final firestore = FirebaseFirestore.instance;

  Future addInvestor(info) async {
    await firestore.collection('investors').add(info);
  }

  Future addStartup(info) async {
    await firestore.collection('startups').add(info);
  }
} 