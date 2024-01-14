import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:on_demand/Services/firebase_database.dart';
import 'package:on_demand/Services/providers/signup_provider.dart';
import 'package:on_demand/UI/Screens/business_detail_screen.dart';
import 'package:on_demand/UI/Screens/document_upload_screen.dart';
import 'package:on_demand/UI/Screens/email_verification_screen.dart';
import 'package:on_demand/UI/Screens/home_screen.dart';
import 'package:provider/provider.dart';
import '../UI/Screens/account_selection_screen.dart';
import '../Services/authentication.dart';
import '../Utilities/constants.dart';

class AuthenticationHandler extends StatefulWidget {
  const AuthenticationHandler({super.key});
  static const id = 'authentication_handler_screen';

  @override
  State<AuthenticationHandler> createState() => _AuthenticationHandlerState();
}

class _AuthenticationHandlerState extends State<AuthenticationHandler> {

  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
            (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          //Todo inverse isDeviceConnected
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      //listens for firebase auth user events
      stream: Authentication.instance.authChanges,
      builder: (BuildContext context, AsyncSnapshot<User?> user) {
        //routing conditions
        //- if user is logged in
        //- if user is logged out
        late Widget screen;
        switch (user.hasData) {
          case true:
            //links email+password credential to currentUser if email is empty
            if (user.data!.email == null || user.data!.email!.isEmpty) {
              var email = Provider.of<SignupProvider>(context)
                  .signupPersonalData['email'];
              var password = Provider.of<SignupProvider>(context)
                  .signupPersonalData['password'];
              Authentication.instance.linkEmailCredential(email, password);
              // save user details
              Map<String,dynamic> data = Provider.of<SignupProvider>(context,listen: false).signupPersonalData;
              data.remove('password');
              FirebaseDatabase.saveSignUpDetails(data: data, uid: user.data!.uid);
            }

            //if internet connection
            screen = FutureBuilder(
              future: FirebaseDatabase.getCurrentUserType(user.data!.uid),
              builder: (context, snapshot) {
                Widget? placeHolder;
                if (snapshot.hasData) {
                  if (snapshot.data == UserType.artisan.name) {
                    placeHolder = FutureBuilder(
                        future: FirebaseDatabase.businessDetailExist(
                            uid: user.data!.uid),
                        builder: (context, snapshot) {
                          Widget? tempScreen;
                          if (snapshot.hasData) {
                            if (snapshot.data == false) {
                              tempScreen = const BusinessDetailScreen();
                            } else if (snapshot.data == true) {
                              tempScreen = FutureBuilder(
                                  future:
                                  FirebaseDatabase.verificationDetailExist(
                                      uid: user.data!.uid),
                                  builder: (context, snapshot) {
                                    Widget? secondScreen;
                                    if (snapshot.hasData) {
                                      if (snapshot.data == false) {
                                        secondScreen =
                                        const DocumentUploadScreen();
                                      } else {
                                        if (!user.data!.emailVerified) {
                                          secondScreen =
                                          const EmailVerificationScreen();
                                        } else {
                                          secondScreen = const Center(
                                            child: ArtisanHomeScreen(),
                                            // ElevatedButton(
                                            //   onPressed: () {
                                            //     FirebaseAuth.instance.signOut();
                                            //   },
                                            //   child:
                                            //   const Text('Artisan Log out'),
                                            // ),
                                          );
                                        }

                                        //check if user detail has been stored instead
                                      }
                                    }
                                    return secondScreen ??
                                        const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                  });
                            }
                          }
                          return tempScreen ??
                              const Center(
                                child: CircularProgressIndicator(),
                              );
                        });
                  } else if (snapshot.data == UserType.client.name) {
                    placeHolder = FutureBuilder(
                        future: FirebaseDatabase.verificationDetailExist(uid: user.data!.uid),
                        builder: (context, snapshot) {
                          Widget? secondScreen;
                          if (snapshot.hasData) {
                            if (snapshot.data == false) {
                              secondScreen = const DocumentUploadScreen();
                            } else {
                              if (!user.data!.emailVerified) {
                                secondScreen = const EmailVerificationScreen();
                              } else {
                                secondScreen = Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      FirebaseAuth.instance.signOut();
                                    },
                                    child: const Text('Client Log out'),
                                  ),
                                );
                              }

                              //check if user detail has been stored instead
                            }
                          }
                          return secondScreen ??
                              const Center(
                                child: CircularProgressIndicator(),
                              );
                        });
                  }
                }

                return placeHolder ?? const Center(child: CircularProgressIndicator(),);
              },
            );
            return screen;
          case false:
            screen = const AccountSelectionScreen();
            return screen;
        }
      },
    );
  }

  showDialogBox() {
    showCupertinoDialog<String>(
    context: context,
    builder: (BuildContext context) =>
      CupertinoAlertDialog(
      title: const Text('No Connection'),
      content: const Text('Please check your internet connection and try again'),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            Navigator.pop(context, 'Cancel');
            setState(() => isAlertSet = false);
            isDeviceConnected =
            await InternetConnectionChecker().hasConnection;
            if (!isDeviceConnected && isAlertSet == false) {
              showDialogBox();
              setState(() => isAlertSet = true);
            }
          },
          child: const Text('Retry'),
        ),
      ],
    ),
  );
  }

}
