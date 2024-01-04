import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UserDetailsProvider {

  //get dataMap from db
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<Map<String, dynamic>?> getData() async {
    String collectionPath = 'user detail';
    Map<String,dynamic>? docMap;
    User? user = FirebaseAuth.instance.currentUser;
    if(user!=null){
      var docSnapshot = await firestore.collection(collectionPath).doc(user.uid).get();
      if(docSnapshot.exists){
        docMap = docSnapshot.data()!;
        return docMap;
      }
    }
    return docMap;
  }

  //convert map data to object data
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;

  void createObject() async{
    await getData().then((value) {
      if(value!=null){
        firstName = value['first_name'];
        lastName = value['last_name'];
        email = value['email'];
        phoneNumber = value['phone_number'];
      }
      print('running');
    });

  }
}