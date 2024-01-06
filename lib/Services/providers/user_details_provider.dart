import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDetailsProvider{

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
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phoneNumber;

  get firstName => _firstName;
  get lastName => _lastName;
  get email => _email;
  get phoneNumber => _phoneNumber;

  void initProperties( Map<String, dynamic>? value) async{
      if(value!=null){
        _firstName = value['first_name'];
        _lastName = value['last_name'];
        _email = value['email'];
        _phoneNumber = value['phone_number'];
      }
    }
}