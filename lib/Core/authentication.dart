import 'package:firebase_auth/firebase_auth.dart';

class Authentication {

 static final Authentication instance = Authentication._init();
 Authentication._init();

 final FirebaseAuth _authInstance = FirebaseAuth.instance;

 Stream<User?> get authChanges => _authInstance.userChanges();



}