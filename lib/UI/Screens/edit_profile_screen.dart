import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:on_demand/Services/authentication.dart';
import 'package:provider/provider.dart';

import '../../Core/routes.dart';
import '../../Services/firebase_database.dart';
import '../../Services/providers/signup_provider.dart';
import '../../Services/providers/user_details_provider.dart';
import '../Components/location_drop_down.dart';
import '../Components/progress_dialog.dart';
import '../Components/text_field.dart';



class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  static const id = 'edit_profile_screen';


  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>  {
  late TabController tabController;


  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> updateEmailFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> updatePhoneFormKey = GlobalKey<FormState>();
  TextEditingController fNameField = TextEditingController();
  TextEditingController lNameField = TextEditingController();
  TextEditingController emailField = TextEditingController();
  TextEditingController phoneField = TextEditingController();
  TextEditingController passwordField = TextEditingController();
  TextEditingController rateField = TextEditingController();



  bool isVerified = false;
  String name = 'blank';
  String occupation = 'blank';
  String location = 'blank';
  double rating = 4;
  String? email ;
  String? phone;
  String? rate;
  String? profilePicture;

  @override
  void initState() {
    var fName = Provider.of<UserDetailsProvider>(context,listen: false).firstName;
    var lName = Provider.of<UserDetailsProvider>(context,listen: false).lastName;
    var eMail = Provider.of<UserDetailsProvider>(context,listen: false).email;
    var phoneNumber = Provider.of<UserDetailsProvider>(context,listen: false).phoneNumber;
    var rAte = Provider.of<UserDetailsProvider>(context,listen: false).rate;
    var profilePic = Provider.of<UserDetailsProvider>(context,listen: false).profilePicture;

    if(profilePic == null){
      profilePicture = "https://static.vecteezy.com/system/resources/thumbnails/020/765/399/small/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg";
    }else{
      profilePicture='$profilePic';
    }


    email ='$eMail';
    name = '$fName $lName';
    phone = '$phoneNumber';
    occupation = Provider.of<UserDetailsProvider>(context,listen: false).occupation;
    location = Provider.of<UserDetailsProvider>(context,listen: false).location;
    rate ="$rAte";




    super.initState();
  }

   File? _selectedImagePath;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context,constraints){
            return ConstrainedBox(
              constraints: constraints,
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                          color: Color(0xffF2F2F2)
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                     CircleAvatar(radius: 40,backgroundImage: NetworkImage('$profilePicture') ),
                                    // _imageFile == null
                                    //     ? AssetImage("assets/profile.jpeg")
                                    //     : FileImage(File(_imageFile.path)),

                                    Positioned(
                                      right: -5,
                                      top: -2,
                                      child: InkWell(
                                        onTap: () async{
                                          showUploadOptions(context);
                                        },
                                        child: const Icon(
                                          Icons.edit_outlined,
                                          color: Colors.teal,
                                          size: 28.0,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 8,),

                                  ],
                                ),
                                const SizedBox(height: 8,),
                                Column(
                                  children: [
                                    isVerified ? const Icon(Icons.verified,color: Colors.green,) : const Icon(Icons.verified_outlined,color: Colors.red,),
                                    const SizedBox(width: 8,),
                                    isVerified ? const Text('Verified') : const Text('Unverified')
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 8,),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(name,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 18,),),
                                const SizedBox(height: 8,),
                                Text(occupation,style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 16),),
                                const SizedBox(height: 8,),
                                Text(location,style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 16),),
                                const SizedBox(height: 8,),
                                RatingBarIndicator(
                                  itemBuilder: (context,number){
                                    return const Icon(Icons.star);
                                  },
                                  itemPadding: EdgeInsets.zero,
                                  itemCount: 5,
                                  itemSize: 20,
                                  rating: rating,


                                )

                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                    const SizedBox(height: 8,),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 24,
                                  ),
                                   LocationDropDown(currentLocation: location),

                                  const SizedBox(
                                    height: 24,
                                  ),

                                  CustomTextField(
                                    controller: rateField,
                                    type: TextFieldType.rate,
                                    label: 'Base rate',
                                    hint: rate ?? "",

                                  ),

                                  const SizedBox(
                                    height: 24,
                                  ),


                                  Form(
                                    key: updateEmailFormKey,
                                    child: CustomTextField(
                                      controller: emailField,
                                      type: TextFieldType.email,
                                      label: 'Update email Address',
                                      hint: email,
                                      onEditingComplete: () {
                                        if(emailField.text.isNotEmpty){
                                          if(updateEmailFormKey.currentState!.validate()) {
                                            //dismiss keyboard
                                            FocusScopeNode currentFocus = FocusScope.of(context);
                                            if (!currentFocus.hasPrimaryFocus) {
                                              currentFocus.unfocus();
                                            }
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.question,
                                              title: 'Change email address',
                                              desc: 'Are you sure you want to change your email address?',
                                              btnCancelOnPress: (){

                                                // Navigator.pop(context);
                                              },
                                              btnOkOnPress: (){
                                                //call update function
                                                Authentication.instance.updateEmail(emailField,context);
                                              },
                                            ).show();
                                          }
                                        }
                                      },
                                      helperText: 'You will be required to sign in and then verify your new email address.',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Form(
                                    key: updatePhoneFormKey,
                                    child: CustomTextField(
                                      controller: phoneField,
                                      type: TextFieldType.phone,
                                      label: 'Change phone number',
                                      hint: phone,
                                      onEditingComplete: () {
                                        if(phoneField.text.isNotEmpty){
                                          if(updatePhoneFormKey.currentState!.validate()) {
                                            //dismiss keyboard
                                            FocusScopeNode currentFocus = FocusScope.of(context);
                                            if (!currentFocus.hasPrimaryFocus) {
                                              currentFocus.unfocus();
                                            }
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.question,
                                              title: 'Change phone number',
                                              desc: 'Are you sure you want to change your phone number?',
                                              btnCancelOnPress: (){

                                                // Navigator.pop(context);
                                              },
                                              btnOkOnPress: (){
                                                //save new number in provider for otp screen and database
                                                Provider.of<SignupProvider>(context,listen: false).addDataSignup(key: 'new_number', value: phoneField.text);
                                                //call update function
                                                Authentication.instance.updatePhoneNumber(phoneField,context);
                                              },
                                            ).show();
                                          }
                                        }
                                      },
                                      helperText: 'You will be required to sign in and then verify your new phone number address.',
                                    ),
                                  ),
                                  // const SizedBox(
                                  //   height: 24,
                                  // ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 48,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (rateField.text != ""){
                                      progressView();
                                      FirebaseDatabase.updateRate(data: {'rate': rateField.text}, uid: Authentication.instance.currentUser!.uid);
                                      Navigator.pop(context);
                                      Navigator.pushReplacementNamed(context, authHandlerScreen);
                                    }
                                    if (Provider.of<SignupProvider>(context,listen: false).signupBusinessData['location'].toString() != location  ){
                                      progressView();
                                      FirebaseDatabase.updateLocation(
                                          data: {'location': Provider.of<SignupProvider>(context,listen: false).signupBusinessData['location'].toString()},
                                          uid: Authentication.instance.currentUser!.uid);
                                      Navigator.pop(context);
                                      Navigator.pushReplacementNamed(context, authHandlerScreen);
                                    }
                                  }, child: const Text('Continue'),
                                ),
                                const SizedBox(height: 24,),

                                const SizedBox(height: 24,),
                                // const SizedBox(
                                //   height: 24,
                                // ),
                                // const ThirdPartyCredentials(),
                              ],
                            ),
                            const SizedBox(height: 48,),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  Future _picImageInGallery(ImageSource source) async {
    final returnedImage = await ImagePicker().pickImage(source: source);

    if (returnedImage == null) return;
     setState(() {
       _selectedImagePath = File(returnedImage.path) ;
       // _selectedImage = FileImage(File(_selectedImagePath!.path));
       progressView();
       FirebaseDatabase.uploadProfilePicture(
           context, _selectedImagePath!, Authentication.instance.currentUser!.uid);

     });

  }



   Future <void> showUploadOptions (BuildContext context) async {
    return await showDialog(context: context, builder: (context){
      return AlertDialog(
        actionsPadding: const EdgeInsets.all(16),
        actions: <Widget>[
          ElevatedButton.icon(
            icon: const Icon(Icons.camera),
            onPressed: () {
              Navigator.of(context).pop();
              _picImageInGallery(ImageSource.camera);
            },
            label: const Text("Camera"),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.image),
            onPressed: () async {
              Navigator.of(context).pop();
              _picImageInGallery(ImageSource.gallery);
            },
            label: const Text("Gallery"),
          ),
        ],
      );
    }
    );
  }

  void progressView() async
  {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        context = context;
        return ProgressDialog(message: "Uploading Profile, Please wait...",);
      },
    );

  }

}
