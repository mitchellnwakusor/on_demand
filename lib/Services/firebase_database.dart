import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:on_demand/Core/routes.dart';
import 'package:on_demand/Services/authentication.dart';
import 'package:on_demand/Services/internet_checker.dart';

class FirebaseDatabase {
  static Future<bool> userExists(
      String phoneNumber, String emailAddress) async {
    var email = await _doesEmailExist(emailAddress);
    var phone = await _doesNumberExist(phoneNumber);
    if (email || phone) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> userTypeExists(
      String phoneNumber, String emailAddress, String userType) async {
    var email = await _doesNumberExistUserType(phoneNumber, userType);
    var phone = await _doesEmailExistUserType(emailAddress, userType);
    if (email || phone) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> _doesEmailExistUserType(
      String emailAddress, String userType) async {
    String collection = 'user detail',
        keyword = 'email',
        secondKeyword = 'user_type';
    final query = await FirebaseFirestore.instance
        .collection(collection)
        .where(keyword, isEqualTo: emailAddress)
        .where(secondKeyword, isEqualTo: userType)
        .get()
        .timeout(const Duration(seconds: 10));
    if (query.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> _doesNumberExistUserType(
      String phoneNumber, String userType) async {
    String collection = 'user detail',
        keyword = 'phone_number',
        secondKeyword = 'user_type';
    final query = await FirebaseFirestore.instance
        .collection(collection)
        .where(keyword, isEqualTo: phoneNumber)
        .where(secondKeyword, isEqualTo: userType)
        .get()
        .timeout(
          const Duration(seconds: 10),
        );
    if (query.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> _doesNumberExist(String phoneNumber) async {
    String collection = 'user detail', keyword = 'phone_number';
    final query = await FirebaseFirestore.instance
        .collection(collection)
        .where(keyword, isEqualTo: phoneNumber)
        .get()
        .timeout(
          const Duration(seconds: 10),
        );
    if (query.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> _doesEmailExist(String emailAddress) async {
    String collection = 'user detail', keyword = 'email';
    final query = await FirebaseFirestore.instance
        .collection(collection)
        .where(keyword, isEqualTo: emailAddress)
        .get()
        .timeout(const Duration(seconds: 10));
    if (query.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> businessDetailExist({required String uid}) async {
    String collection = 'business detail';
    var doc =
        await FirebaseFirestore.instance.collection(collection).doc(uid).get();
    if (doc.exists) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> verificationDetailExist({required String uid}) async {
    String collection = 'verification detail';
    var doc =
        await FirebaseFirestore.instance.collection(collection).doc(uid).get();
    if (doc.exists) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String> getCurrentUserType(String uid) async {
    String userType;
    String collectionPath = 'user detail';
    var snapshot = await FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(uid)
        .get();
    if (snapshot.exists) {
      Map<String, dynamic> dataMap = snapshot.data()!;
      userType = dataMap['user_type'];
    } else {
      userType = '';
    }
    return userType;
  }

  static Future<void> saveSignUpDetails(
      {required Map<String, dynamic> data, required String uid}) async {
    String collectionPath = 'user detail';
    String userCollectionPath = 'user';
    Map<String, dynamic> userData = {"uid": uid};

    await FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(uid)
        .set(data);
    await FirebaseFirestore.instance
        .collection(userCollectionPath)
        .doc(uid)
        .set(userData);
  }

  static Future<void> updateUserDetails(
      {required Map<String, dynamic> data, required String uid}) async {
    String collectionPath = 'user detail';
    await FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(uid)
        .update(data);
    Fluttertoast.showToast(msg: "Profile Updated.");
  }

  static Future<void> saveBusinessDetails(BuildContext context,
      {required Map<String, dynamic> data, required String uid}) async {
    String collectionPath = 'business detail';
    if (await InternetChecker.checkInternet() == true) {
      await FirebaseFirestore.instance
          .collection(collectionPath)
          .doc(uid)
          .set(data);
    } else {
      if (!context.mounted) return;
      Navigator.pop(context);
      // TODO
      Fluttertoast.showToast(msg: "No internet connection, please try again.");
    }
  }

  static Future<void> saveVerificationDocuments(
      {required Map<String, dynamic> data, required String uid}) async {
    String collectionPath = 'verification detail';
    await FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(uid)
        .set(data, SetOptions(merge: true));
  }

  static void uploadVerificationDocument(
      {required BuildContext context,
      required File file,
      required String userType,
      required String uid}) async {
    if (await InternetChecker.checkInternet() == true) {
      FirebaseStorage.instance
          .ref(userType)
          .child("verification documents/$uid/file.jpg")
          .putFile(file)
          .snapshotEvents
          .listen((taskSnapShot) {
        if (taskSnapShot.state == TaskState.success) {
          var path = FirebaseStorage.instance
              .ref(userType)
              .child("verification documents/$uid/file.jpg")
              .fullPath;
          Map<String, dynamic> data = {'document_path': path};
          saveVerificationDocuments(data: data, uid: uid);
          Navigator.pushReplacementNamed(context, authHandlerScreen);
        }
      });
    } else {
      if (!context.mounted) return;
      Navigator.pop(context);
      // TODO
      Fluttertoast.showToast(msg: "No internet connection, please try again.");
    }
  }

  static Future<void> saveProfilePicture(
      {required Map<String, dynamic> data,
      required String uid,
      required BuildContext context}) async {
    String collectionPath = 'user detail';
    await FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(uid)
        .set(data, SetOptions(merge: true));
    Fluttertoast.showToast(msg: "Profile Updated.");
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, authHandlerScreen);
    }
  }

  static Future<void> updateLocation(
      {required Map<String, dynamic> data, required String uid}) async {
    String collectionPath = 'business detail';
    await FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(uid)
        .set(data, SetOptions(merge: true));
    Fluttertoast.showToast(msg: "Profile Updated.");
  }

  static Future<void> updateRate(
      {required Map<String, dynamic> data, required String uid}) async {
    String collectionPath = 'business detail';
    await FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(uid)
        .set(data, SetOptions(merge: true));
    Fluttertoast.showToast(msg: "Profile Updated.");
  }

  static void uploadProfilePicture(
      BuildContext context, File file, String uid) async {
    if (await InternetChecker.checkInternet() == true) {
      FirebaseStorage.instance
          .ref("artisan")
          .child("profile picture/$uid/file.jpg")
          .putFile(file)
          .snapshotEvents
          .listen((taskSnapShot) async {
        if (taskSnapShot.state == TaskState.success) {
          final path = FirebaseStorage.instance
              .ref("artisan")
              .child("profile picture/$uid/file.jpg");
          String imageURL = await path.getDownloadURL();
          Map<String, dynamic> data = {'profile_picture': imageURL};
          if (context.mounted) {
            saveProfilePicture(data: data, uid: uid, context: context);
          }
          if (context.mounted) Navigator.of(context).pop();
        }
      });
    } else {
      if (!context.mounted) return;
      Navigator.pop(context);
      // TODO
      Fluttertoast.showToast(msg: "No internet connection, please try again.");
    }
  }

  //*********** Portfolio ***********//

  static void createPortfolio(BuildContext context, String portfolioTitle, File portfolioImageFile) async {
    try {
      if (await InternetChecker.checkInternet() == true) {
        String docPath = Authentication.instance.currentUser!.uid;
        String collectionPath = 'artisan profile';
        String subImageURL;
        String subCollectionPath = 'portfolio';
        String subCollectionDocPath = DateTime.now().toIso8601String();
        //save image in firestore
          String uid = Authentication.instance.currentUser!.uid;
          FirebaseStorage.instance
              .ref("artisan profile/$uid")
              .child("portfolio/$subCollectionDocPath/file.jpg")
              .putFile(portfolioImageFile)
              .snapshotEvents
              .listen((taskSnapShot) async {
            if (taskSnapShot.state == TaskState.success) {
              subImageURL = await FirebaseStorage.instance
                  .ref("artisan profile/$uid")
                  .child("portfolio/$subCollectionDocPath/file.jpg").getDownloadURL();
                  // .fullPath;
              Map<String, dynamic> data = {
                'title': portfolioTitle,
                'time': subCollectionDocPath,
                'image url': subImageURL
              };
              //
              FirebaseFirestore.instance
                  .collection(collectionPath)
                  .doc(docPath)
                  .collection(subCollectionPath)
                  .doc(subCollectionDocPath)
                  .set(data);
              if (context.mounted) {
                Navigator.pop(context); //progress view
                Navigator.pop(context);
              }
            }
          });

      }
    } on FirebaseException catch (exception) {
      if (!context.mounted) return;
      Navigator.pop(context);
      // TODO
      Fluttertoast.showToast(msg: exception.message!);
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getPortfolioDataStream() {
    String docPath = Authentication.instance.currentUser!.uid;
    String collectionPath = 'artisan profile';
    String subCollectionPath = 'portfolio';

    //query cloud database

    final streamSnapshot = FirebaseFirestore.instance.collection(collectionPath).doc(docPath).collection(subCollectionPath).snapshots();
    return streamSnapshot;
  }

  static void deletePortfolio(BuildContext context,String docID) async {
    String docPath = Authentication.instance.currentUser!.uid;
    String collectionPath = 'artisan profile';
    String subCollectionPath = 'portfolio';
    String subCollectionDocPath = docID;

    try {
      if (await InternetChecker.checkInternet() == true) {
        //query portfolio to delete
        FirebaseFirestore.instance.collection(collectionPath).doc(docPath).collection(subCollectionPath).doc(subCollectionDocPath).delete().then((value) {
          FirebaseFirestore.instance.collection(collectionPath).doc(docPath).delete().then((value) {
            FirebaseStorage.instance.ref("artisan profile/$docPath").child("portfolio/$subCollectionDocPath/file.jpg").delete().then((value) {
              Fluttertoast.showToast(msg: 'Portfolio deleted');
              Navigator.pop(context); //progress view
              Navigator.pop(context);
            });
          });
        });
      }
    } on FirebaseException catch (exception) {
      if (!context.mounted) return;
      Navigator.pop(context);
      // TODO
      Fluttertoast.showToast(msg: exception.message!);
    }


  }

  static void editPortfolioTitle(BuildContext context,String docID,String newTitle) async{
    String docPath = Authentication.instance.currentUser!.uid;
    String collectionPath = 'artisan profile';
    String subCollectionPath = 'portfolio';
    String subCollectionDocPath = docID;

    try{
      if (await InternetChecker.checkInternet() == true){
        FirebaseFirestore.instance.collection(collectionPath).doc(docPath).collection(subCollectionPath).doc(subCollectionDocPath).update(
            {'title': newTitle}).then((value) {
              Fluttertoast.showToast(msg: 'Edit saved');
              Navigator.pop(context); //progress view
              Navigator.pop(context); //progress view
        });

      }
    }
    on FirebaseException catch(exception){
      if (!context.mounted) return;
      Navigator.pop(context);
      // TODO
      Fluttertoast.showToast(msg: exception.message!);
    }
  }
}
