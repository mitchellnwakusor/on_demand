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


  static Future<Map<String, dynamic>?> getAllData() async{
    String userCollectionPath = 'user detail';
    String businessCollectionPath = 'business detail';
    String verificationCollectionPath = 'verification detail';
    Map<String,dynamic>? docMap;
    User? user = FirebaseAuth.instance.currentUser;
    
    if(user!=null){
      Map<String,dynamic> tempMap = {};
      var userDetails = await firestore.collection(userCollectionPath).doc(user.uid).get();
      if(userDetails.exists){
        tempMap.addAll(userDetails.data()!);
        var businessDetails = await firestore.collection(businessCollectionPath).doc(user.uid).get();
        if(businessDetails.exists){
          tempMap.addAll(businessDetails.data()!);
          var verificationDetails = await firestore.collection(verificationCollectionPath).doc(user.uid).get();
          if(verificationDetails.exists){
            tempMap.addAll(verificationDetails.data()!);
            docMap = tempMap;
            return docMap;
          }
        }
      }
      //  firestore.collection(userCollectionPath).doc(user.uid).get().then((userValue){
      //  if(userValue.exists){
      //     firestore.collection(businessCollectionPath).doc(user.uid).get().then((businessValue){
      //      if(businessValue.exists){
      //        firestore.collection(verificationCollectionPath).doc(user.uid).get().then((verificationValue) {
      //          if(verificationValue.exists){
      //           tempMap.addAll(userValue.data()!);
      //           tempMap.addAll(businessValue.data()!);
      //           tempMap.addAll(verificationValue.data()!);
      //           docMap = tempMap;
      //           return docMap;
      //          }
      //        });
      //      }
      //    });
      //  }
      // });
    }
    return docMap;

  }
  //convert map data to object data
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phoneNumber;
  String? _userType;
  String? _occupation;
  String? _businessType;
  String? _location;
  String? _documentPath;

  get firstName => _firstName;
  get lastName => _lastName;
  get email => _email;
  get phoneNumber => _phoneNumber;
  get userType => _userType;
  get occupation => _occupation;
  get businessType => _businessType;
  get location => _location;
  get documentPath => _documentPath;

  void initProperties( Map<String, dynamic>? value) async{
      if(value!=null){
        _firstName = value['first_name'];
        _lastName = value['last_name'];
        _email = value['email'];
        _phoneNumber = value['phone_number'];
        _documentPath = value['document_path'];
        _location = value['location'];
        _businessType = value['business_type'];
        _occupation = value['occupation'];
        _userType = value['user_type'];
      }
    }
}