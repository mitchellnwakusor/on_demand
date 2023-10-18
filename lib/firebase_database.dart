import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:on_demand/firebase_authentication.dart';
import 'package:on_demand/error_handler.dart';

class FirestoreCloudServices {
  //Singleton instance
  static FirestoreCloudServices instance = FirestoreCloudServices._init();
  FirestoreCloudServices._init();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
/*Relational model
  User registration
  crud */

    //create user document
    Future<void> createUserDocument(BuildContext context) async {
      String collectionPath = 'user';
      String? documentPath = FirebaseAuthServices.instance.currentUserUID;
      if(documentPath!=null) {
        Map<String,dynamic> data = {'uid': FirebaseAuthServices.instance.currentUserUID};
        await _firestore.collection(collectionPath).doc(documentPath).set(data);
      }
      else {
        ErrorHandler().authDisplayError(FirebaseAuthException(code: 'user-not-found'), context);
      }
    }

    //create user detail document
    Future<void> createUserDetailDocument(Map<String,dynamic> data,BuildContext context) async {
      String collectionPath = 'user detail';
      String? documentPath = FirebaseAuthServices.instance.currentUserUID;
      if(documentPath!=null) {
        await _firestore.collection(collectionPath).doc(documentPath).set(data);
      }
      else {
        ErrorHandler().authDisplayError(FirebaseAuthException(code: 'user-not-found'), context);
      }
    }

    //read document
    Future<Map<String, dynamic>?> getCurrentUserDetailDocument(BuildContext context) async {
      String collectionPath = 'user detail';
      String? documentPath = FirebaseAuthServices.instance.currentUserUID;
      if(documentPath!=null) {
       var snapshot = await _firestore.collection(collectionPath).doc(documentPath).get();
       return snapshot.data();
      }
      else {
        ErrorHandler().authDisplayError(FirebaseAuthException(code: 'user-not-found'), context);
        return null;
      }
    }
}


