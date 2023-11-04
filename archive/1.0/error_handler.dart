import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ErrorHandler {

  final String _errorTitle = 'Oops, an error occurred';
  String _errorMessage = 'A critical error occurred, and a report has been generated. We\'ll begin looking into this.';

  String _authGetErrorMessage(FirebaseAuthException exception) {
    switch (exception.code) {
      //General errors
      case 'network-request-failed':
        _errorMessage = 'Unable to connect to the internet. An active internet connection is required.';
        return _errorMessage;
      case 'invalid-email':
        _errorMessage = 'The email address provided is invalid. Check the address and try again.';
        return _errorMessage;
      case 'operation-not-allowed':
        _errorMessage = 'Sorry this current operation is not allowed. Please retry at another time.';
        return _errorMessage;
      // Sign in with email errors
      case 'user-not-found':
        _errorMessage = 'Sorry no account is linked to this user. Create an account first and then try again.';
        return _errorMessage;
      case 'user-disabled':
        _errorMessage = 'Sorry this account has been disabled. Contact support for assistance.';
        return _errorMessage;
      case 'wrong-password':
        _errorMessage = 'Sorry the password is incorrect. Check your password and try again or reset password.';
        return _errorMessage;

      // Create user with email_password errors
      case 'email-already-in-use':
        _errorMessage = 'Sorry this email address is already in use. Sign in to your account or use a different email.';
        return _errorMessage;
      case 'weak-password':
        _errorMessage = 'The password provided is not secure. A secure password is a mix of Uppercase,lowercase characters, symbols and digits';
        return _errorMessage;

      // Sign in with credential
      case 'account-exists-with-different-credential':
        _errorMessage = 'This account already exists with a different signup provider like Facebook or Google. Sign in to your account and then link credentials';
        return _errorMessage;
      case 'invalid-credential':
        _errorMessage = 'Sorry this session has expired or is invalid. Let\'s try that again';
        return _errorMessage;
      case 'invalid-verification-code':
        _errorMessage = 'Sorry the sms code provided is incorrect. Recheck and try again';
        return _errorMessage;
      case 'invalid-verification-id':
        _errorMessage = 'Sorry invalid verification id. Contact support for assistance';
        return _errorMessage;

      // authenticate with credential
      case 'user-mismatch':
        _errorMessage = 'Sorry this account does not match the given credential. Check your details and try again';
        return _errorMessage;
      case 'expired-action-code':
        _errorMessage = 'Sorry action code has expired. let\'s restart the process.';
        return _errorMessage;
      default:
        return _errorMessage;
    }
  }

  //error has two overrides, one accepts a method to try-catch, the other accepts an exception to display a dialog
  void authDisplayError(FirebaseAuthException exception, BuildContext context) {
    String errorMessage = _authGetErrorMessage(exception);

    // how to introduce context without mixing it with auth service method
    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: Text(_errorTitle),
              children: [Text(errorMessage)],
            ));
  }
  void authCheckMethod( dynamic Function() method,BuildContext context) {
    try{
      method();
    }
    on FirebaseAuthException catch (exception) {
      authDisplayError(exception, context);
    }
  }

}
