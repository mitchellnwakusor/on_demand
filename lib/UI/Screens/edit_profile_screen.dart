import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:on_demand/Core/routes.dart';
import 'package:provider/provider.dart';

import '../../Services/providers/user_details_provider.dart';
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
  TextEditingController fNameField = TextEditingController();
  TextEditingController lNameField = TextEditingController();
  TextEditingController emailField = TextEditingController();
  TextEditingController phoneField = TextEditingController();
  TextEditingController passwordField = TextEditingController();


  bool isPortfolio = false;
  bool isVerified = false;
  String name = 'blank';
  String occupation = 'blank';
  String location = 'blank';
  String priceRate = '0000';
  double rating = 4;
  String? Uemail ;

  @override
  void initState() {
    var fName = Provider.of<UserDetailsProvider>(context,listen: false).firstName;
    var lName = Provider.of<UserDetailsProvider>(context,listen: false).lastName;
    var email = Provider.of<UserDetailsProvider>(context,listen: false).email;
    Uemail ='$email';
    name = '$fName $lName';
    occupation = Provider.of<UserDetailsProvider>(context,listen: false).occupation;
    location = Provider.of<UserDetailsProvider>(context,listen: false).location;

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Profile'),
        actions: [Visibility(visible: isPortfolio,child: IconButton(onPressed: (){}, icon: const Icon(Icons.add)))],
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
                                const CircleAvatar(radius: 40,backgroundImage: null,),
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
                                  CustomTextField(
                                    controller: emailField,
                                    type: TextFieldType.email,
                                    label: 'Email',
                                    hint: Uemail,
                                    helperText: Text('You will be required to sign in and then verify your new email address.',)
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  CustomTextField(
                                    controller: phoneField,
                                    type: TextFieldType.phone,
                                    label: 'Phone number',
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  CustomTextField(
                                    controller: passwordField,
                                    type: TextFieldType.password,
                                    label: 'Password',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 48,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {}, child: const Text('Continue'),
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
}
