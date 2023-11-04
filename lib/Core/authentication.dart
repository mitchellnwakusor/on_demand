import 'package:firebase_auth/firebase_auth.dart';

class Authentication {

 final FirebaseAuth _authInstance = FirebaseAuth.instance;

 Stream<User?> get authChanges => _authInstance.userChanges();



}