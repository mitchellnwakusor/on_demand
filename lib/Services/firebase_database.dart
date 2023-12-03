import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDatabase {
  static Future<bool> userExists(String phoneNumber,String emailAddress) async{
    var email = await _doesEmailExist(emailAddress);
    var phone = await _doesNumberExist(phoneNumber);
    if(email || phone){
      return true;
    }
    else{
      return false;
    }
  }
  static Future<bool> businessDetailExist(String uid) async {
    String collection = 'business detail';
    var doc = await FirebaseFirestore.instance.collection(collection).doc(uid).get();
    if(doc.exists){
      return true;
    }
    else{
      return false;

    }
  }
  static Future<bool> verificationDetailExist(String uid) async {
    String collection = 'verification detail';
    var doc = await FirebaseFirestore.instance.collection(collection).doc(uid).get();
    if(doc.exists){
      return true;
    }
    else{
      return false;

    }
  }

  static Future<bool> _doesNumberExist(String phoneNumber) async {
    String collection = 'user detail', keyword = 'phone_number';
    final query =  await FirebaseFirestore.instance.collection(collection).where(keyword, isEqualTo: phoneNumber).get().timeout(
      const Duration(seconds: 10),
    );
    if(query.docs.isEmpty){
      return false;
    }
    else{
      return true;
    }
  }
  static Future<bool> _doesEmailExist(String emailAddress) async {
    String collection = 'user detail', keyword = 'email';
    final query =  await FirebaseFirestore.instance.collection(collection).where(keyword, isEqualTo: emailAddress).get().timeout(
        const Duration(seconds: 10));
    if(query.docs.isEmpty){
      return false;
    }
    else{
      return true;
    }
  }
}

